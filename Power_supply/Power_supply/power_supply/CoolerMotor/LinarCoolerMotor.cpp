/*
* LinarCoolerMotor.cpp
*
* Created: 07.09.2018 23:47:13
* Author: koval
*/


#include "LinarCoolerMotor.h"
#include "Arduino.h"

// default constructor
LinarCoolerMotor::LinarCoolerMotor()
{
} //LinarCoolerMotor

LinarCoolerMotor::LinarCoolerMotor(int pwmPin)
{
	coolerMotorPin = pwmPin;
	pinMode(coolerMotorPin, OUTPUT);
}

// default destructor
LinarCoolerMotor::~LinarCoolerMotor()
{
} //~LinarCoolerMotor

void LinarCoolerMotor:: Update(int temperature)
{
	if(temperature <= startCoolerMotorTemperature)
	{
		currentCoolerMotorPWM =0;
	}
	else
	{
		currentCoolerMotorPWM = (temperature - startCoolerMotorTemperature)*coolPwmOneCount;
	}
	analogWrite(coolerMotorPin, min(currentCoolerMotorPWM, PWMCounts));
}

int LinarCoolerMotor:: GetPowerProcent()
{
	return currentCoolerMotorPWM*100/PWMCounts;
}

