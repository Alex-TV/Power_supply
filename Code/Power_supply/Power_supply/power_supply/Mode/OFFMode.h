/*
* OFFMode.h
*
* Created: 08.09.2018 0:51:23
* Author: koval
*/
#include "IMode.h"
#include "ModeEnum.h"
#include "ButtonEnum.h"

#ifndef __OFFMODE_H__
#define __OFFMODE_H__


class OFFMode : public IMode
{
	//variables
	public:
	protected:
	private:

	//functions
	public:
	OFFMode();	  
	OFFMode(IDisplay*);
	~OFFMode();
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
	OFFMode(const OFFMode &c );
	OFFMode& operator=(const OFFMode &c );

}; //OFFMode

#endif //__OFFMODE_H__
