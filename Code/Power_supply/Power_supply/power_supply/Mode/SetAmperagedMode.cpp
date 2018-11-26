/*
* SetAmperagedMode.cpp
*
* Created: 08.09.2018 0:52:05
* Author: koval
*/
#include "SetAmperagedMode.h"

// default constructor
SetAmperagedMode::SetAmperagedMode(int pwmWritePin, int readValuePin,  int backupReadPin, int stabAmperageLedPin, IDisplay* display)
{
	_pwmWritePin = pwmWritePin;
	_backupReadPin = backupReadPin;
	_readValuePin = readValuePin;
	_stabAmperageLedPin = stabAmperageLedPin;
	//pwmValue = 100;
	pinMode(_readValuePin, INPUT);
	pinMode(_backupReadPin, INPUT);
	pinMode(_pwmWritePin, OUTPUT);
	pinMode(_stabAmperageLedPin, OUTPUT);
	_display = display;
} //SetAmperagedMode

// default destructor
SetAmperagedMode::~SetAmperagedMode()
{
} //~SetAmperagedMode

void SetAmperagedMode::IncrementEncoderValue()
{
	if(_pwmValue >= 254) return;
	_pwmValue++;
}

void SetAmperagedMode::DecrementEncoderValue()
{
	if(_pwmValue <= 0) return;
	_pwmValue--;
}

ModeEnum SetAmperagedMode:: GetTypeMode()
{
	return ModeEnum::SetAmperaged;
}

void SetAmperagedMode:: SaveEEPROM()
{
	EEPROM.update(memoryPWMAdress,  (uint8_t)_pwmValue);
	delay(4*64);
}

void SetAmperagedMode:: ReadEEPROM()
{
	_pwmValue = EEPROM.read(memoryPWMAdress);
	delay(4*64);
}

void SetAmperagedMode:: PrintState()
{
	_display->AmperagedPrint(_backupValue, _currentValue);
}

void SetAmperagedMode::PrintMode()
{
	_display->ModePrint(GetTypeMode());
}

void SetAmperagedMode:: ReadADC()
{
	_currentValue = ReadMedian(_readValuePin,5)  * amperagedOneCount;
	_backupValue = ReadMedian(_backupReadPin,5) * amperagedOneCount;
	digitalWrite(_stabAmperageLedPin, _currentValue>=_backupValue? HIGH:LOW);
}

void SetAmperagedMode::WritePWM()
{
	analogWrite(_pwmWritePin, _pwmValue);
}

void SetAmperagedMode::SavePWMInEeprom(ButtonEnum button){}
void SetAmperagedMode::ReadPWMInEeprom(ButtonEnum button){}
