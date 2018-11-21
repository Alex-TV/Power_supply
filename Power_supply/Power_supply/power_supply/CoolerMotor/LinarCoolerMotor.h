/*
* LinarCoolerMotor.h
*
* Created: 07.09.2018 23:47:13
* Author: koval
*/
#include "ICoolerMotor.h"

#ifndef __LINARCOOLERMOTOR_H__
#define __LINARCOOLERMOTOR_H__


class LinarCoolerMotor : public ICoolerMotor
{
	//variables
	public:
	protected:
	private: 
	int coolerMotorPin;
	int const startCoolerMotorTemperature =40;
	int const maxPowerTemperature = 80;
	int const PWMCounts = 255;

	float const coolPwmOneCount =  PWMCounts/(maxPowerTemperature - startCoolerMotorTemperature );
	int currentCoolerMotorPWM =0;
	//functions
	public:
	LinarCoolerMotor();
	LinarCoolerMotor(int);
	~LinarCoolerMotor();
	void Update(int);
	int GetPowerProcent();

	protected:
	private:
	LinarCoolerMotor( const LinarCoolerMotor &c );
	LinarCoolerMotor& operator=( const LinarCoolerMotor &c );

}; //LinarCoolerMotor

#endif //__LINARCOOLERMOTOR_H__
