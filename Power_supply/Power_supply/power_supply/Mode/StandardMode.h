/*
* StandardMode.h
*
* Created: 08.09.2018 0:24:44
* Author: koval
*/
#include <IMode.h>
#include "ModeEnum.h"

#ifndef __STANDARDMODE_H__
#define __STANDARDMODE_H__


class StandardMode : public IMode
{
	//variables
	public:
	protected:
	private:

	//functions
	public:
	StandardMode();
	StandardMode(IDisplay*);
	~StandardMode();
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
	StandardMode( const StandardMode &c );
	StandardMode& operator=( const StandardMode &c );

}; //StandardMode

#endif //__STANDARDMODE_H__
