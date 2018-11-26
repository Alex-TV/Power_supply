/*
* FunMode.cpp
*
* Created: 18.10.2018 14:49:46
* Author: koval
*/
#include "FunMode.h"

// default constructor
FunMode::FunMode(IDisplay* display, int* temp)
{
	_display = display;
	_funMotor =  new LinarCoolerMotor(CoolerMotorPin);
	_temp = temp;
} //FunMode

// default destructor
FunMode::~FunMode()
{
} //~FunMode

void FunMode::IncrementEncoderValue(){}
void FunMode::DecrementEncoderValue(){}

ModeEnum FunMode::GetTypeMode()
{
	return ModeEnum::FunMode;
}

void FunMode::SaveEEPROM(){}
void FunMode::ReadEEPROM(){}

void FunMode::PrintState(){
	_display->Clear();
}

void FunMode::ReadADC(){}

void FunMode::WritePWM(){
	_funMotor->Update(*_temp);
}

void FunMode::PrintMode(){
	_display->PrintTempAndFunStatus(*_temp, _funMotor->GetPowerProcent());
	_display->PrintProgressBar(1, _funMotor->GetPowerProcent());
}
void FunMode::SavePWMInEeprom(ButtonEnum){}
void FunMode::ReadPWMInEeprom(ButtonEnum){}
