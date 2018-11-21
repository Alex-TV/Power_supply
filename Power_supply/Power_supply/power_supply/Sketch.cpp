/*Begining of Auto generated code by Atmel studio */
#include <Arduino.h>

/*End of auto generated code by Atmel studio */

// Visual Micro is in vMicro>General>Tutorial Mode
//
/*
Name:       Power_Supply.ino
Created:	29.08.2018 12:16:23
Author:     GML-AKOVALEV\koval
*/

#include <EEPROM.h>
#include <LiquidCrystal_I2C.h>
#include <SimpleTimer.h>
#include <DallasTemperature.h>
#include <OneWire.h>
#include <math.h>
#include "Display/Display16x2.h"
#include "ButtonEnum.h"
#include "ModeEnum.h"
#include "IMode.h"
#include "Mode/StandardMode.h"
#include "Mode/SetVoltageMode.h"
#include "Mode/UnknownMode.h"
#include "Mode/OFFMode.h"
#include "Mode/SetAmperagedMode.h"
#include "Mode/FunMode.h"
#include "Mode/PowerMode.h"

//порты
#define EncoderRightPin PD3
#define EncoderLeftPin PD4
#define ButtonPin PC3

#define RealAmperagePin PC0
#define BackupAmperagePin PC1
#define RealVoltagesPin PC2

#define StabAmperageLedPin 8//PB0

#define PWMAmperagedPin 9//PB1
#define PWMVoltagesPin 10//PB2
#define PSONPin 7//PB2

#define TemperaturePin 12

#pragma region
//Beginning of Auto generated function prototypes by Atmel Studio
void InitDisplay();
void PrepareData(int adc_result);
void EncoderScan();
void ReadADC();
void EncoderUpdate();
void RegEncoderButton();
void ModeSelection();
void GetButtonClick();
void OnButtonDownClick(ButtonEnum);
void OnButtonUpClick(ButtonEnum);
void IncrementEncoderValue();
void DecrementEncoderValue();
void SelectModeReset();
void PressButtonTime();
void SavePWMVoltageInEeprom();
void SaveModeValueInEeprom();
void ReadPWMVoltageInEeprom(ButtonEnum);
void OnPowerSeplay();
int ReadMedian (int, int);
void CheckMaxTemperature();
//End of Auto generated function prototypes by Atmel Studio
#pragma endregion

const char* strVer ="ver 1.0";

SimpleTimer timerSelectModeReset; // таймер сброса режима редактирования
SimpleTimer timerPressButtonTime;// таймер удержания кнопки для записи в EEPROM
SimpleTimer timerUpdateTemperature;// таймер удержания кнопки для записи в EEPROM
SimpleTimer timerRegEncoderButton;
int timerSelectModeResetId;//id таймера сброса режима.
int timerPressButtonTimeId;//id таймера удержания кнопки для записи в EEPROM.
int timerUpdateTemperatureId;
int timerRegEncoderButtonId;

ButtonEnum oldCurrenButtonClick = ButtonEnum::Unknown; //нажата кнопка по умолчанию.
int const buttonCount =5; // количество кнопок на аналоговом порту оброботки нажатия клавишь PC3
int const adcKeyValue[buttonCount] = {30, 155, 500, 535, 1300}; // пороги срабатывания кнопок.

//bool isStabilization = false;//идикация стабилизации тока.

unsigned int const logoTime = 2*64000; //время показа стартового лого
long const selectModeResetTime = 3*64000; //через сколько сборосится режим редактирования PWM.
long const buttonSavePWMVoltageInEepromTime = 3*64000; //время удержания кнопки памяти до сохраниения PWM.
long const timeUpdateTemperature = .5*64000; // период проверки максимальной температуры.
long const timeRegEncoderButton = .5*64000; // премя ожидания следуюцего нажатия кнопки энкодера.

//температура
// Создаем объект OneWire
OneWire oneWire(TemperaturePin);
// Создаем объект DallasTemperature для работы с сенсорами, передавая ему ссылку на объект для работы с 1-Wire.
DallasTemperature dallasSensors(&oneWire);
int currentTemperature =0;
int const maxTemperature = 80;
bool temperatuerFuse = false;

int countEncoderButtonClick =0; //количество нажатий кнопки энкодера.

IDisplay* disply = new Display16x2();
int const modesCount = 5;
IMode* modes[modesCount];
IMode* funMode;
IMode* oldMode;
IMode* mode;

void setup()
{
	TCCR0B = TCCR0B & B11111000 | B00000001;
	//TCCR1B = TCCR1B & B11111000 | B00000001;
	
	modes[0] = new OFFMode(disply);
	modes[1] = new StandardMode(disply);
	modes[2] = new SetVoltageMode(PWMVoltagesPin, RealVoltagesPin, disply);
	modes[3] = new SetAmperagedMode(PWMAmperagedPin, RealAmperagePin, BackupAmperagePin, StabAmperageLedPin, disply);
	modes[4] = new PowerMode(modes[2], modes[3], disply);
	funMode = new FunMode(disply, &currentTemperature);
	
	oldMode =  modes[0];
	mode = modes[0];
	
	//енкодер
	pinMode(EncoderRightPin, INPUT);//-энкодер право/лево
	pinMode(EncoderLeftPin, INPUT);//-энкодер право/лево

	//кнопки
	pinMode(ButtonPin, INPUT);

	pinMode(StabAmperageLedPin, OUTPUT);//-светодиод стабилизации тока
	
	pinMode(PSONPin, OUTPUT); // включение БП.
	
	//прерывание для энкодера
	attachInterrupt(INT1, EncoderUpdate, CHANGE);
	//инициализация датчика температуры
	dallasSensors.setWaitForConversion(false);
	dallasSensors.begin();
	//инициализация таймера автоматического вызода из режима редактирования.
	timerSelectModeResetId = timerSelectModeReset.setInterval(selectModeResetTime, SelectModeReset);
	//таймер для отсчета удержания кнопки памяти.
	timerPressButtonTimeId = timerPressButtonTime.setInterval(buttonSavePWMVoltageInEepromTime, SavePWMVoltageInEeprom);
	//таймер для проверки превышения температуры
	timerUpdateTemperatureId = timerUpdateTemperature.setInterval(timeUpdateTemperature, CheckMaxTemperature);
	//таймер регистрации количество нажатия кнопки энкодера
	timerRegEncoderButtonId = timerRegEncoderButton.setInterval(timeRegEncoderButton, RegEncoderButton);

	//инициализация дисплея и стартовая заставка.
	disply->InitDisplay(strVer);
	//востаовми настройки из памяти.
	for(int i=0;i<modesCount;i++)
	{
		modes[i]->ReadEEPROM();
	}
	funMode->ReadEEPROM();

	delay(logoTime);
	mode->PrintState();
}

// Add the main program code into the continuous loop() function
void loop()
{
	OnPowerSeplay();
	GetButtonClick();
	
	timerSelectModeReset.run();
	timerUpdateTemperature.run();
	timerRegEncoderButton.run();
	
	mode->PrintMode();
	
	funMode->WritePWM();
	
	if(mode->GetTypeMode() == ModeEnum::OFF
	|| (mode->GetTypeMode() == ModeEnum::FunMode
	&& oldMode->GetTypeMode() == ModeEnum::OFF)) return;

	for(int i=0;i<modesCount; i++)
	{
		modes[i]->WritePWM();
	}

	ReadADC();
	if(mode->GetTypeMode() == ModeEnum::Standard
	||mode->GetTypeMode() == ModeEnum::SetAmperaged
	||mode->GetTypeMode() == ModeEnum::SetVoltage )
	{
		for(int i=1;i<modesCount; i++)
		{
			modes[i]->PrintState();
		}
	}
}

void CheckMaxTemperature()
{
	dallasSensors.requestTemperatures();
	currentTemperature = max((int)dallasSensors.getTempCByIndex(0), -99);
	if(currentTemperature< maxTemperature)
	{
		if(temperatuerFuse)
		{
			temperatuerFuse = false;
			modes[0]->PrintState();
		}
		return;
	}
	temperatuerFuse = true;
	mode = modes[0];
	disply->TemperaturePrint(currentTemperature);
}

void OnPowerSeplay()
{
	digitalWrite(PSONPin, mode->GetTypeMode() == ModeEnum::OFF
	||  (mode->GetTypeMode() == ModeEnum::FunMode
	&& oldMode->GetTypeMode() == ModeEnum::OFF) ? LOW:HIGH);
}

void SelectModeReset()
{
	if(mode->GetTypeMode() == ModeEnum::OFF
	|| mode->GetTypeMode() == ModeEnum::Standard
	|| mode->GetTypeMode() == ModeEnum::FunMode) return;
	SaveModeValueInEeprom();
	mode = modes[1];
}

void ReadPWMVoltageInEeprom(ButtonEnum arg)
{
	if(mode->GetTypeMode() != ModeEnum::SetVoltage ) return;
	mode->ReadPWMInEeprom(arg);
}

void SavePWMVoltageInEeprom()
{
	if(mode->GetTypeMode() == ModeEnum::SetVoltage )
	{
		mode->SavePWMInEeprom(oldCurrenButtonClick);
	}
}

void ReadADC()
{
	for(int i=0;i<modesCount; i++)
	{
		modes[i]->ReadADC();
	}
}

void EncoderUpdate()
{
	int pinAValue = digitalRead(EncoderRightPin);            // Получаем состояние пинов A и B
	int pinBValue = digitalRead(EncoderLeftPin);
	int state =0;
	cli();    // Запрещаем обработку прерываний, чтобы не отвлекаться
	if (!pinAValue &&  pinBValue)
	{
		state = 1;  // Если при спаде линии А на линии B лог. единица, то вращение в одну сторону
	}
	if (!pinAValue && !pinBValue)
	{
		state = -1; // Если при спаде линии А на линии B лог. ноль, то вращение в другую сторону
	}
	if (!pinAValue && state != 0) {
		if (state == -1 && !pinBValue)
		{
			IncrementEncoderValue();
		}
		if( state == 1 && pinBValue) { // Если на линии А снова единица, фиксируем шаг
			DecrementEncoderValue();
		}
	}
	sei(); // Разрешаем обработку прерываний
	timerSelectModeReset.restartTimer(timerSelectModeResetId);
}

void RegEncoderButton()
{
	if(countEncoderButtonClick == 0)
	{
		return;
	}
	if(mode->GetTypeMode() !=ModeEnum::OFF
	&& countEncoderButtonClick >= 5)
	{
		mode = modes[0];
		disply->Clear();
		mode->PrintState();
	}
	else if(countEncoderButtonClick == 3)
	{
		if(mode->GetTypeMode() != ModeEnum::FunMode)
		{
			oldMode = mode;
		}
		mode = funMode;
		mode->PrintState();
	}
	else if(mode->GetTypeMode() ==ModeEnum::FunMode)
	{
		mode =oldMode;
		disply->Clear();
		mode->PrintState();
	}
	else
	{
		ModeSelection();
	}
	countEncoderButtonClick = 0;
}

void IncrementEncoderValue()
{
	mode->IncrementEncoderValue();
}

void DecrementEncoderValue()
{
	mode->DecrementEncoderValue();
}

void ModeSelection()
{
	switch(mode->GetTypeMode())
	{
		case ModeEnum::OFF:
		{
			disply->Clear();
			mode = modes[1];
			break;
		}
		case ModeEnum::Standard:
		{
			mode = modes[2];
			break;
		}
		case ModeEnum::SetVoltage:
		{
			SaveModeValueInEeprom();
			mode =  modes[3];
			break;
		}
		case ModeEnum::SetAmperaged:
		{
			SaveModeValueInEeprom();
			mode =   modes[1];
			break;
		}
	}
}

void SaveModeValueInEeprom()
{
	mode->SaveEEPROM();
}

void GetButtonClick()
{
	int input = analogRead(ButtonPin);
	for(int i = 0; i < buttonCount; i++)
	{
		if(input < adcKeyValue[i])
		{
			ButtonEnum currenButtonClick = static_cast<ButtonEnum>(i);
			if(oldCurrenButtonClick != currenButtonClick)
			{
				OnButtonDownClick(currenButtonClick);
				OnButtonUpClick(oldCurrenButtonClick);
				oldCurrenButtonClick = currenButtonClick;
			}
			else
			{
				PressButtonTime();
			}
			break;
		}
	}
}

void OnButtonUpClick(ButtonEnum arg)
{
	ReadPWMVoltageInEeprom(arg);
	timerSelectModeReset.restartTimer(timerSelectModeResetId);
}

void PressButtonTime()
{
	if(oldCurrenButtonClick == ButtonEnum::MemoryButton1
	|| oldCurrenButtonClick == ButtonEnum::MemoryButton2
	|| oldCurrenButtonClick == ButtonEnum::MemoryButton3
	|| oldCurrenButtonClick == ButtonEnum::EncoderButton)
	{
		timerPressButtonTime.run();
		timerSelectModeReset.restartTimer(timerSelectModeResetId);
	}
}

void OnButtonDownClick(ButtonEnum arg)
{
	timerPressButtonTime.restartTimer(timerPressButtonTimeId);
	if(arg == ButtonEnum::EncoderButton)
	{
		countEncoderButtonClick++;
		timerSelectModeReset.restartTimer(timerSelectModeResetId);
		timerRegEncoderButton.restartTimer(timerRegEncoderButtonId);
	}
}

