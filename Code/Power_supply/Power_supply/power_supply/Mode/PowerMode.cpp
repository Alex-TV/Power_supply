/*
* PowerMode.cpp
*
* Created: 18.10.2018 17:32:31
* Author: koval
*/
#include "PowerMode.h"

// default constructor
PowerMode::PowerMode()
{
} //PowerMode
PowerMode::PowerMode(IMode* voltageMode, IMode* amperagedMode, IDisplay* display)
{
	this->display = display;
	this->amperagedMode = amperagedMode;
	this->voltageMode = voltageMode;
}

// default destructor
PowerMode::~PowerMode()
{
} //~PowerMode

void PowerMode::IncrementEncoderValue() {}
void PowerMode::DecrementEncoderValue() {}
ModeEnum PowerMode::GetTypeMode(){
	return ModeEnum::PowerMode;
}
void PowerMode::SaveEEPROM(){}
void PowerMode::ReadEEPROM(){}
void PowerMode::PrintState(){
	this->display->PowerPrint(voltageMode->GetValue() * amperagedMode->GetValue());
}
void PowerMode::ReadADC(){}
void PowerMode::WritePWM(){}
void PowerMode::PrintMode(){}
void PowerMode::SavePWMInEeprom(ButtonEnum){}
void PowerMode::ReadPWMInEeprom(ButtonEnum){}

