/*
* SetVoltage.h
*
* Created: 08.09.2018 0:37:26
* Author: koval
*/
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
	const float maxVoltagesValue = 21;
	const float voltagesOneCount = maxVoltagesValue/ADCCounts;		
	
	const int memoryPWMAdress =1;
	const int memoryPWMAdress1 =2;
	const int memoryPWMAdress2 =3;
	const int memoryPWMAdress3 =4;
	//functions
	public:
	SetVoltageMode();
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
