/*
* FunMode.cpp
*
* Created: 18.10.2018 14:49:46
* Author: koval
*/
#include "FunMode.h"
#include "..\CoolerMotor\LinarCoolerMotor.h"

// default constructor
FunMode::FunMode(){} //FunMode

FunMode::FunMode(IDisplay* display, int* temp)
{
	this->display = display;
	this->funMotor =  new LinarCoolerMotor(CoolerMotorPin);
	this->temp = temp;
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
	display->Clear();
}

void FunMode::ReadADC(){}

void FunMode::WritePWM(){
	funMotor->Update(*temp);
}

void FunMode::PrintMode(){
	display->PrintTempAndFunStatus(*temp, funMotor->GetPowerProcent());
	display->PrintProgressBar(1, funMotor->GetPowerProcent());
}
void FunMode::SavePWMInEeprom(ButtonEnum){}
void FunMode::ReadPWMInEeprom(ButtonEnum){}
