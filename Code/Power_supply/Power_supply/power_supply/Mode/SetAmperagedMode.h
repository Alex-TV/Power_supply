/*
* SetAmperagedMode.h
*
* Created: 08.09.2018 0:52:05
* Author: koval
*/
#define maxAmperagedValue 11
#define memoryPWMAdress 0
#define amperagedOneCount maxAmperagedValue/ADCCounts

#include <Arduino.h>
#include <EEPROM.h>
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
	float _backupValue=-1;
	float _backupReadPin =-1;
	int _stabAmperageLedPin=-1;

	//functions
	public:
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
