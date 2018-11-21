/*
* StandardMode.cpp
*
* Created: 08.09.2018 0:24:44
* Author: koval
*/


#include "StandardMode.h"
#include "ModeEnum.h"

// default constructor
StandardMode::StandardMode()
{
} //StandardMode

StandardMode::StandardMode(IDisplay* display)
{
	this->display =display;
} //StandardMode

// default destructor
StandardMode::~StandardMode()
{
} //~StandardMode

ModeEnum StandardMode:: GetTypeMode()
{
	return ModeEnum::Standard;
}
void StandardMode::PrintMode()
{
	this->display->ModePrint(GetTypeMode());
}

void StandardMode:: IncrementEncoderValue(){}
void StandardMode::DecrementEncoderValue(){}
void StandardMode:: SaveEEPROM(){}
void StandardMode:: ReadEEPROM(){}
void StandardMode:: PrintState(){}
void StandardMode:: ReadADC(){}
void StandardMode::WritePWM(){}
void StandardMode::SavePWMInEeprom(ButtonEnum){}
void StandardMode::ReadPWMInEeprom(ButtonEnum){}

