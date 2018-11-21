/*
* SetAmperagedMode.h
*
* Created: 08.09.2018 0:52:05
* Author: koval
*/
#include "IMode.h"
#include "ModeEnum.h"

#ifndef __SETAMPERAGEDMODE_H__
#define __SETAMPERAGEDMODE_H__


class SetAmperagedMode: public IMode
{
	//variables
	public:
	protected:
	private:
	float backupValue=-1;
	float backupReadPin =-1;
	const float maxAmperagedValue = 11;
	const float amperagedOneCount = maxAmperagedValue/ADCCounts;
	const int memoryPWMAdress =0;
	int stabAmperageLedPin=-1;
	//functions
	public:
	SetAmperagedMode();
	SetAmperagedMode(int,int,int,int, IDisplay*);
	~SetAmperagedMode();
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
	SetAmperagedMode( const SetAmperagedMode &c );
	SetAmperagedMode& operator=( const SetAmperagedMode &c );

}; //SetAmperagedMode

#endif //__SETAMPERAGEDMODE_H__
