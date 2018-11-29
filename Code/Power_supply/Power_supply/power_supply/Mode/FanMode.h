/*
* FunMode.h
*
* Created: 18.10.2018 14:49:46
* Author: koval
*/
#include "IMode.h"
#include "ModeEnum.h"
#include "ButtonEnum.h"
#include "ICoolerMotor.h"
#include "..\CoolerMotor\LinarCoolerMotor.h"

#ifndef __FUNMODE_H__
#define __FUNMODE_H__

#define CoolerMotorPin PD6

class FanMode: public IMode
{
	//variables
	public:
	protected:
	private:
	ICoolerMotor* _fanMotor;
	int* _temp;
	//functions
	public:
	FanMode(IDisplay*, int*);
	~FanMode();
	void IncrementEncoderValue();
	void DecrementEncoderValue();
	ModeEnum GetTypeMode();
	void SaveEEPROM();
	void ReadEEPROM();
	void PrintState();
	void ReadADC();
	void WritePWM();
	void PrintMode();
	void SavePWMInEeprom(ButtonEnum);
	void ReadPWMInEeprom(ButtonEnum);
	protected:
	private:
	FanMode( const FanMode &c );
	FanMode& operator=( const FanMode &c );

}; //FunMode

#endif //__FUNMODE_H__
