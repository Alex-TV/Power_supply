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

#ifndef __FUNMODE_H__
#define __FUNMODE_H__

#define CoolerMotorPin PD6

class FunMode: public IMode
{
	//variables
	public:
	protected:
	private:
	ICoolerMotor *funMotor;
	int *temp;
	//functions
	public:
	FunMode();
	FunMode(IDisplay*, int*);
	~FunMode();
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
	FunMode( const FunMode &c );
	FunMode& operator=( const FunMode &c );

}; //FunMode

#endif //__FUNMODE_H__
