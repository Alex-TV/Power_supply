/*
* OFFMode.cpp
*
* Created: 08.09.2018 0:51:23
* Author: koval
*/


#include "OFFMode.h"
#include "ModeEnum.h"

// default constructor
OFFMode::OFFMode(){} //OFFMode
OFFMode::OFFMode(IDisplay* display)
{
	this->display = display;
} //OFFMode
// default destructor
OFFMode::~OFFMode(){} //~OFFMode
void OFFMode::IncrementEncoderValue(){}
void OFFMode::DecrementEncoderValue() {}
void OFFMode::SaveEEPROM(){}
void OFFMode::ReadEEPROM(){}
void OFFMode::ReadADC(){}
void OFFMode::WritePWM(){};
void OFFMode::PrintMode(){}
void OFFMode::SavePWMInEeprom(ButtonEnum button){}
void OFFMode::ReadPWMInEeprom(ButtonEnum button){}

ModeEnum OFFMode::GetTypeMode()
{
	return ModeEnum::OFF;
}

void OFFMode::PrintState()
{
	this->display->OffPrint();
}
