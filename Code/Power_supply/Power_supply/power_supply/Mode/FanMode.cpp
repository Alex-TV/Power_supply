/*
* FunMode.cpp
*
* Created: 18.10.2018 14:49:46
* Author: koval
*/
#include "FanMode.h"

// default constructor
FanMode::FanMode(IDisplay* display, int* temp)
{
	_display = display;
	_fanMotor =  new LinarCoolerMotor(CoolerMotorPin);
	_temp = temp;
} //FunMode

// default destructor
FanMode::~FanMode()
{
} //~FunMode

void FanMode::IncrementEncoderValue(){}
void FanMode::DecrementEncoderValue(){}

ModeEnum FanMode::GetTypeMode()
{
	return ModeEnum::FunMode;
}

void FanMode::SaveEEPROM(){}
void FanMode::ReadEEPROM(){}

void FanMode::PrintState(){
	_display->Clear();
}

void FanMode::ReadADC(){}

void FanMode::WritePWM(){
	_fanMotor->Update(*_temp);
}

void FanMode::PrintMode(){
	_display->PrintTempAndFunStatus(*_temp, _fanMotor->GetPowerProcent());
	_display->PrintProgressBar(1, _fanMotor->GetPowerProcent());
}
void FanMode::SavePWMInEeprom(ButtonEnum){}
void FanMode::ReadPWMInEeprom(ButtonEnum){}
