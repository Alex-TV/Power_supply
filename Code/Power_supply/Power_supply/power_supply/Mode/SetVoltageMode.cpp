/*
* SetVoltage.cpp
*
* Created: 08.09.2018 0:37:26
* Author: koval
*/
#include "SetVoltageMode.h"
#include "ModeEnum.h"
#include "Arduino.h"
#include "EEPROM.h"

// default constructor
SetVoltageMode::SetVoltageMode()
{
} //SetVoltage

SetVoltageMode::SetVoltageMode(int pwmWritePin, int readValuePin, IDisplay* display)
{
	this->pwmWritePin = pwmWritePin;
	this->readValuePin = readValuePin;
	this->display = display;
	//pwmValue =100;
	pinMode(readValuePin, INPUT);
	pinMode(pwmWritePin, OUTPUT);
} //SetAmperagedMode
// default destructor
SetVoltageMode::~SetVoltageMode()
{
} //~SetVoltage

void SetVoltageMode:: IncrementEncoderValue()
{
	if(pwmValue >= 254) return;
	pwmValue++;
}

void SetVoltageMode:: DecrementEncoderValue()
{
	if(pwmValue <= 0) return;
	pwmValue--;
}

ModeEnum SetVoltageMode:: GetTypeMode()
{
	return ModeEnum::SetVoltage;
}

void SetVoltageMode::SaveEEPROM()
{
	EEPROM.update(memoryPWMAdress,  (uint8_t)pwmValue);
	delay(4*64);
}

void SetVoltageMode::ReadEEPROM()
{
	pwmValue =EEPROM.read(memoryPWMAdress);
}

void SetVoltageMode::PrintState(){
	this->display->VoltagesPrint(pwmValue, currentValue);
}

void SetVoltageMode::PrintMode()
{
	this->display->ModePrint(ModeEnum::SetVoltage);
}

void SetVoltageMode::ReadADC()
{
	currentValue = ReadMedian(readValuePin,5) * voltagesOneCount;
}

void SetVoltageMode::WritePWM()
{
	analogWrite(pwmWritePin, pwmValue);
}

void SetVoltageMode::SavePWMInEeprom(ButtonEnum button)
{
	int memAdress = -1;
	int numForPrint =-1;
	if(button == ButtonEnum::MemoryButton1)
	{
		memAdress =   memoryPWMAdress1;
		numForPrint = 1;
	}
	else if(button == ButtonEnum:: MemoryButton2)
	{
		memAdress =   memoryPWMAdress2;
		numForPrint = 2;
	}
	else if (button == ButtonEnum:: MemoryButton3)
	{
		memAdress =   memoryPWMAdress3;
		numForPrint = 3;
	}
	if(memAdress == -1) return;
	EEPROM.update(memoryPWMAdress1, (uint8_t)pwmValue);
	this->display->MemorySavePrint(numForPrint);
	delay(this->logoSavePWMVoltageInEepromTime);
}

void SetVoltageMode::ReadPWMInEeprom(ButtonEnum button)
{
	int memAdress = -1;
	int numForPrint =-1;
	if(button == ButtonEnum::MemoryButton1)
	{
		memAdress  = memoryPWMAdress1;
		numForPrint	=1;
	}
	else if(button == ButtonEnum:: MemoryButton2)
	{
		memAdress  = memoryPWMAdress2;
		numForPrint	=2;

	}
	else if (button == ButtonEnum:: MemoryButton3)
	{
		memAdress  = memoryPWMAdress3;
		numForPrint	=3;
	}
	if(memAdress == -1) return;
	int readValue = EEPROM.read(memAdress);
	if(pwmValue == readValue) return;
	this->display->MemoryReadPrint(numForPrint);
	delay(this->logoReadPWMVoltageInEepromTime);
}


