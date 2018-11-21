/*
* SetAmperagedMode.cpp
*
* Created: 08.09.2018 0:52:05
* Author: koval
*/
#include "SetAmperagedMode.h"
#include "ModeEnum.h"
#include <EEPROM.h>
#include "Arduino.h"

// default constructor
SetAmperagedMode::SetAmperagedMode() {} //SetAmperagedMode

SetAmperagedMode::SetAmperagedMode(int pwmWritePin, int readValuePin,  int backupReadPin, int stabAmperageLedPin, IDisplay* display)
{
	this->pwmWritePin = pwmWritePin;
	this->backupReadPin = backupReadPin;
	this ->readValuePin = readValuePin;
	this->stabAmperageLedPin = stabAmperageLedPin;
	//pwmValue = 100;
	pinMode(readValuePin, INPUT);
	pinMode(backupReadPin, INPUT);
	pinMode(pwmWritePin, OUTPUT);
	pinMode(stabAmperageLedPin, OUTPUT);
	this->display = display;
} //SetAmperagedMode

// default destructor
SetAmperagedMode::~SetAmperagedMode()
{
} //~SetAmperagedMode

void SetAmperagedMode::IncrementEncoderValue()
{
	if(pwmValue >= 254) return;
	pwmValue++;
}

void SetAmperagedMode::DecrementEncoderValue()
{
	if(pwmValue <= 0) return;
	pwmValue--;
}

ModeEnum SetAmperagedMode:: GetTypeMode()
{
	return ModeEnum::SetAmperaged;
}

void SetAmperagedMode:: SaveEEPROM()
{
	EEPROM.update(memoryPWMAdress,  (uint8_t)pwmValue);
	delay(4*64);
}

void SetAmperagedMode:: ReadEEPROM()
{
	pwmValue = EEPROM.read(memoryPWMAdress);
	delay(4*64);
}

void SetAmperagedMode:: PrintState()
{
	this->display->AmperagedPrint(backupValue, currentValue);
}

void SetAmperagedMode::PrintMode()
{
	this->display->ModePrint(GetTypeMode());
}

void SetAmperagedMode:: ReadADC()
{
	currentValue = ReadMedian(readValuePin,5)  * amperagedOneCount;
	backupValue = ReadMedian(backupReadPin,5) * amperagedOneCount;
	digitalWrite(stabAmperageLedPin, currentValue>=backupValue? HIGH:LOW);
}

void SetAmperagedMode::WritePWM()
{
	analogWrite(pwmWritePin, pwmValue);
}

void SetAmperagedMode::SavePWMInEeprom(ButtonEnum button){}
void SetAmperagedMode::ReadPWMInEeprom(ButtonEnum button){}
