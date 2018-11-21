#include "ButtonEnum.h"
#include "ModeEnum.h"
#include "IMode.h"
/* 
* PowerMode.h
*
* Created: 18.10.2018 17:32:31
* Author: koval
*/


#ifndef __POWERMODE_H__
#define __POWERMODE_H__


class PowerMode :  public IMode
{
//variables
public:
protected:
private:
IMode* voltageMode;
IMode* amperagedMode;
//functions
public:
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
	PowerMode();
	PowerMode (IMode*, IMode*, IDisplay*);
	~PowerMode();
protected:
private:
	PowerMode( const PowerMode &c );
	PowerMode& operator=( const PowerMode &c );

}; //PowerMode

#endif //__POWERMODE_H__
