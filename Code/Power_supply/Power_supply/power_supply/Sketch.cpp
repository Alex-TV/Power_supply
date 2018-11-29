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
#include "Mode/FanMode.h"
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

#define modesCount 5
#define maxTemperature 80
#define buttonCount 5
#define logoTime  2*64000 //время показа стартового лого
#define selectModeResetTime 3*64000 //через сколько сборосится режим редактирования PWM.
#define buttonSavePWMVoltageInEepromTime 3*64000 //время удержания кнопки памяти до сохраниения PWM.
#define timeUpdateTemperature .5*64000 // период проверки максимальной температуры.
#define timeRegEncoderButton .5*64000 // премя ожидания следуюцего нажатия кнопки энкодера.

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

const char* _strVer ="ver 1.0";

SimpleTimer* _timer; // таймер сброса режима редактирования
SimpleTimer* _timerPressButtonTime;// таймер удержания кнопки для записи в EEPROM
int _timerSelectModeResetId;//id таймера сброса режима.
int _timerPressButtonTimeId;//id таймера удержания кнопки для записи в EEPROM.
int _timerUpdateTemperatureId;
int _timerRegEncoderButtonId;

ButtonEnum _oldCurrenButtonClick = ButtonEnum::Unknown; //нажата кнопка по умолчанию.
int const _adcKeyValue[buttonCount] = {30, 155, 500, 535, 1300}; // пороги срабатывания кнопок.

//температура
OneWire* _oneWire;
// Создаем объект DallasTemperature для работы с сенсорами, передавая ему ссылку на объект для работы с 1-Wire.
DallasTemperature* _dallasSensors;
int _currentTemperature =0;
bool _temperatuerFuse = false;

int _countEncoderButtonClick =0; //количество нажатий кнопки энкодера.

IDisplay* _disply;
IMode** _modesArray;
IMode* _fanMode;
IMode* _oldMode;
IMode* _mode;

void setup()
{
	TCCR0B = TCCR0B & B11111000 | B00000001;
	//инициализация дисплея и стартовая заставка.
	_disply = new Display16x2();
	_modesArray = new  IMode*[modesCount];
	_modesArray[0] =  new OFFMode(_disply);
	_modesArray[1] =  new StandardMode(_disply);
	_modesArray[2] =  new SetVoltageMode(PWMVoltagesPin, RealVoltagesPin, _disply);
	_modesArray[3] =  new SetAmperagedMode(PWMAmperagedPin, RealAmperagePin, BackupAmperagePin, StabAmperageLedPin, _disply);
	_modesArray[4] =  new PowerMode(_modesArray[2], _modesArray[3], _disply);
	_fanMode = new FanMode(_disply, &_currentTemperature);
	
	_oldMode =  _modesArray[0];
	_mode = _modesArray[0];
	_oneWire = new OneWire(TemperaturePin);
	
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
	_dallasSensors = new DallasTemperature(_oneWire);
	_dallasSensors->setWaitForConversion(false);
	_dallasSensors->begin();
	_timer = new SimpleTimer();
	//инициализация таймера автоматического вызода из режима редактирования.
	_timerSelectModeResetId = _timer->setInterval(selectModeResetTime, SelectModeReset);
	//таймер для проверки превышения температуры
	_timerUpdateTemperatureId = _timer->setInterval(timeUpdateTemperature, CheckMaxTemperature);
	//таймер регистрации количество нажатия кнопки энкодера
	_timerRegEncoderButtonId = _timer->setInterval(timeRegEncoderButton, RegEncoderButton);
	_timerPressButtonTime = new SimpleTimer();
	//таймер для отсчета удержания кнопки памяти.
	_timerPressButtonTimeId = _timerPressButtonTime->setInterval(buttonSavePWMVoltageInEepromTime, SavePWMVoltageInEeprom);

	// стартовая заставка.
	_disply->InitDisplay(_strVer);
	//востаовми настройки из памяти.
	for(int i=0;i<modesCount;i++)
	{
		_modesArray[i]->ReadEEPROM();
	}
	_fanMode->ReadEEPROM();

	delay(logoTime);
	_mode->PrintState();
}

// Add the main program code into the continuous loop() function
void loop()
{
	OnPowerSeplay();
	GetButtonClick();
	
	_timer->run();
	
	_mode->PrintMode();
	
	_fanMode->WritePWM();
	
	if(_mode->GetTypeMode() == ModeEnum::OFF
	|| (_mode->GetTypeMode() == ModeEnum::FunMode
	&& _oldMode->GetTypeMode() == ModeEnum::OFF)) return;

	for(int i=0;i<modesCount; i++)
	{
		_modesArray[i]->WritePWM();
	}

	ReadADC();
	if(_mode->GetTypeMode() == ModeEnum::Standard
	||_mode->GetTypeMode() == ModeEnum::SetAmperaged
	||_mode->GetTypeMode() == ModeEnum::SetVoltage )
	{
		for(int i=1;i<modesCount; i++)
		{
			_modesArray[i]->PrintState();
		}
	}
}

void CheckMaxTemperature()
{
	_dallasSensors->requestTemperatures();
	_currentTemperature = max((int)_dallasSensors->getTempCByIndex(0), -99);
	if(_currentTemperature< maxTemperature)
	{
		if(_temperatuerFuse)
		{
			_temperatuerFuse = false;
			_modesArray[0]->PrintState();
		}
		return;
	}
	_temperatuerFuse = true;
	_mode = _modesArray[0];
	_disply->TemperaturePrint(_currentTemperature);
}

void OnPowerSeplay()
{
	digitalWrite(PSONPin, _mode->GetTypeMode() == ModeEnum::OFF
	||  (_mode->GetTypeMode() == ModeEnum::FunMode
	&& _oldMode->GetTypeMode() == ModeEnum::OFF) ? LOW:HIGH);
}

void SelectModeReset()
{
	if(_mode->GetTypeMode() == ModeEnum::OFF
	|| _mode->GetTypeMode() == ModeEnum::Standard
	|| _mode->GetTypeMode() == ModeEnum::FunMode) return;
	SaveModeValueInEeprom();
	_mode = _modesArray[1];
}

void ReadPWMVoltageInEeprom(ButtonEnum arg)
{
	if(_mode->GetTypeMode() != ModeEnum::SetVoltage ) return;
	_mode->ReadPWMInEeprom(arg);
}

void SavePWMVoltageInEeprom()
{
	if(_mode->GetTypeMode() == ModeEnum::SetVoltage )
	{
		_mode->SavePWMInEeprom(_oldCurrenButtonClick);
	}
}

void ReadADC()
{
	for(int i=0;i<modesCount; i++)
	{
		_modesArray[i]->ReadADC();
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
	_timer->restartTimer(_timerSelectModeResetId);
}

void RegEncoderButton()
{
	if(_countEncoderButtonClick == 0)
	{
		return;
	}
	if(_mode->GetTypeMode() !=ModeEnum::OFF
	&& _countEncoderButtonClick >= 5)
	{
		_mode = _modesArray[0];
		_disply->Clear();
		_mode->PrintState();
	}
	else if(_countEncoderButtonClick == 3)
	{
		if(_mode->GetTypeMode() != ModeEnum::FunMode)
		{
			_oldMode = _mode;
		}
		_mode = _fanMode;
		_mode->PrintState();
	}
	else if(_mode->GetTypeMode() ==ModeEnum::FunMode)
	{
		_mode =_oldMode;
		_disply->Clear();
		_mode->PrintState();
	}
	else
	{
		ModeSelection();
	}
	_countEncoderButtonClick = 0;
}

void IncrementEncoderValue()
{
	_mode->IncrementEncoderValue();
}

void DecrementEncoderValue()
{
	_mode->DecrementEncoderValue();
}

void ModeSelection()
{
	switch(_mode->GetTypeMode())
	{
		case ModeEnum::OFF:
		{
			_disply->Clear();
			_mode = _modesArray[1];
			break;
		}
		case ModeEnum::Standard:
		{
			_mode = _modesArray[2];
			break;
		}
		case ModeEnum::SetVoltage:
		{
			SaveModeValueInEeprom();
			_mode = _modesArray[3];
			break;
		}
		case ModeEnum::SetAmperaged:
		{
			SaveModeValueInEeprom();
			_mode = _modesArray[1];
			break;
		}
	}
}

void SaveModeValueInEeprom()
{
	_mode->SaveEEPROM();
}

void GetButtonClick()
{
	int input = analogRead(ButtonPin);
	for(int i = 0; i < buttonCount; i++)
	{
		if(input < _adcKeyValue[i])
		{
			ButtonEnum currenButtonClick = static_cast<ButtonEnum>(i);
			if(_oldCurrenButtonClick != currenButtonClick)
			{
				OnButtonDownClick(currenButtonClick);
				OnButtonUpClick(_oldCurrenButtonClick);
				_oldCurrenButtonClick = currenButtonClick;
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
	_timer->restartTimer(_timerSelectModeResetId);
}

void PressButtonTime()
{
	if(_oldCurrenButtonClick == ButtonEnum::MemoryButton1
	|| _oldCurrenButtonClick == ButtonEnum::MemoryButton2
	|| _oldCurrenButtonClick == ButtonEnum::MemoryButton3
	|| _oldCurrenButtonClick == ButtonEnum::EncoderButton)
	{
		_timerPressButtonTime->run();
		_timer->restartTimer(_timerSelectModeResetId);
	}
}

void OnButtonDownClick(ButtonEnum arg)
{
	_timerPressButtonTime->restartTimer(_timerPressButtonTimeId);
	if(arg == ButtonEnum::EncoderButton)
	{
		_countEncoderButtonClick++;
		_timer->restartTimer(_timerSelectModeResetId);
		_timer->restartTimer(_timerRegEncoderButtonId);
	}
}

