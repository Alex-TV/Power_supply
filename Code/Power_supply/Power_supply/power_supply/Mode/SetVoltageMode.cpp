/*
* SetVoltage.cpp
*
* Created: 08.09.2018 0:37:26
* Author: koval
*/
#include "SetVoltageMode.h"

// default constructor
SetVoltageMode::SetVoltageMode(int pwmWritePin, int readValuePin, IDisplay* display)
{
	_pwmWritePin = pwmWritePin;
	_readValuePin = readValuePin;
	_display = display;
	//pwmValue =100;
	pinMode(_readValuePin, INPUT);
	pinMode(_pwmWritePin, OUTPUT);
} //SetAmperagedMode
// default destructor
SetVoltageMode::~SetVoltageMode()
{
} //~SetVoltage

void SetVoltageMode:: IncrementEncoderValue()
{
	if(_pwmValue >= 254) return;
	_pwmValue++;
}

void SetVoltageMode:: DecrementEncoderValue()
{
	if(_pwmValue <= 0) return;
	_pwmValue--;
}

ModeEnum SetVoltageMode:: GetTypeMode()
{
	return ModeEnum::SetVoltage;
}

void SetVoltageMode::SaveEEPROM()
{
	EEPROM.update(memoryPWMAdress,  (uint8_t)_pwmValue);
	delay(4*64);
}

void SetVoltageMode::ReadEEPROM()
{
	_pwmValue =EEPROM.read(memoryPWMAdress);
}

void SetVoltageMode::PrintState(){
	_display->VoltagesPrint(_pwmValue, _currentValue);
}

void SetVoltageMode::PrintMode()
{
	_display->ModePrint(ModeEnum::SetVoltage);
}

void SetVoltageMode::ReadADC()
{
	_currentValue = ReadMedian(_readValuePin,5) * voltagesOneCount;
}

void SetVoltageMode::WritePWM()
{
	analogWrite(_pwmWritePin, _pwmValue);
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
	EEPROM.update(memoryPWMAdress1, (uint8_t)_pwmValue);
	_display->MemorySavePrint(numForPrint);
	delay(this->_logoSavePWMVoltageInEepromTime);
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
	if(_pwmValue == readValue) return;
	_display->MemoryReadPrint(numForPrint);
	delay(_logoReadPWMVoltageInEepromTime);
}


