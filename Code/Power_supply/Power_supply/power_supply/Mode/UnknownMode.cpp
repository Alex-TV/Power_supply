/*
* UnknownMode.cpp
*
* Created: 08.09.2018 0:50:39
* Author: koval
*/


#include "UnknownMode.h"
#include "ModeEnum.h"

// default constructor
UnknownMode::UnknownMode()
{
} //UnknownMode

// default destructor
UnknownMode::~UnknownMode()
{
} //~UnknownMode

void UnknownMode::IncrementEncoderValue(){}
void UnknownMode::DecrementEncoderValue() {}
ModeEnum UnknownMode:: GetTypeMode()
{
	return ModeEnum::Unknown;
}


