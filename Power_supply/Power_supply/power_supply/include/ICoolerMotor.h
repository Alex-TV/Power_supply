/*
* ICoolerMotor.h
*
* Created: 07.09.2018 23:45:57
* Author: koval
*/


#ifndef __ICOOLERMOTOR_H__
#define __ICOOLERMOTOR_H__


class ICoolerMotor
{
	//functions
	public:
	virtual ~ICoolerMotor(){}
	virtual void Update(int)=0;
	virtual int GetPowerProcent()=0;
}; //ICoolerMotor

#endif //__ICOOLERMOTOR_H__
