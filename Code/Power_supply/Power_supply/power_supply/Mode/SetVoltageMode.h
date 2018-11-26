/*
* SetVoltage.h
*
* Created: 08.09.2018 0:37:26
* Author: koval
*/
#define maxVoltagesValue  21
#define voltagesOneCount  maxVoltagesValue/ADCCounts
#define memoryPWMAdress 1
#define memoryPWMAdress1 2
#define memoryPWMAdress2 3
#define memoryPWMAdress3 4

#include <Arduino.h>
#include <EEPROM.h>
#include "IMode.h"
#include "ModeEnum.h"
#include "ButtonEnum.h"

#ifndef __SETVOLTAGEMODE_H__
#define __SETVOLTAGEMODE_H__


class SetVoltageMode : public IMode
{
	//variables
	public:
	protected:
	private:
	//functions
	public:
	SetVoltageMode(int, int, IDisplay*);
	~SetVoltageMode();
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
	SetVoltageMode( const SetVoltageMode &c );
	SetVoltageMode& operator=( const SetVoltageMode &c );

}; //SetVoltageMode

#endif //__SETVOLTAGEMODE_H__
