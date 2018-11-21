/*
* UnknownMode.h
*
* Created: 08.09.2018 0:50:39
* Author: koval
*/
#include "IMode.h"
#include "ModeEnum.h"

#ifndef __UNKNOWNMODE_H__
#define __UNKNOWNMODE_H__


class UnknownMode : public IMode
{
	//variables
	public:
	protected:
	private:

	//functions
	public:
	UnknownMode();
	~UnknownMode();
	void IncrementEncoderValue();
	void DecrementEncoderValue();
	ModeEnum GetTypeMode();

	protected:
	private:
	UnknownMode( const UnknownMode &c );
	UnknownMode& operator=( const UnknownMode &c );

}; //UnknownMode

#endif //__UNKNOWNMODE_H__
