/*
* Display.cpp
*
* Created: 04.09.2018 12:33:45
* Author: koval
*/

#include "Display16x2.h"

void Display16x2:: InitDisplay(const char* strVer)
{
	// продключение дисплея
	_lcd = new LiquidCrystal_I2C(0x27, 16, 2);	//параметры дисплея
	_lcd->begin();
	_lcd->clear();
	_lcd->setCursor(2,0);
	_lcd->print("power supply");
	_lcd->setCursor(4,1);
	_lcd->print(strVer);
}

void Display16x2::OffPrint()
{
	_lcd->clear();
	_lcd->setCursor(6,0);
	_lcd->print("OFF");
}

void Display16x2::TemperaturePrint(float temperature)
{
	_lcd->clear();
	_lcd->setCursor(0,0);
	_lcd->print("max temperature");
	_lcd->setCursor(0,1);
	_lcd->print("exceeded");
	_lcd->setCursor(9,1);
	int va = temperature*10;
	String strTemperature =  String(va/10, DEC);
	strTemperature +="C";
	_lcd->print(strTemperature);
}

void Display16x2::MemoryReadPrint(int memNum)
{
	_lcd->clear();
	_lcd->setCursor(1,0);
	_lcd->print("Memory read");
	_lcd->setCursor(13,0);
	_lcd->print(memNum);
}

void Display16x2::MemorySavePrint(int memNum)
{
	_lcd->clear();
	_lcd->setCursor(1,0);
	_lcd->print("Memory saved");
	_lcd->setCursor(13,0);
	_lcd->print(memNum);
}


void Display16x2::VoltagesPrint(float pwmVoltagesValue, float currentVoltagesValue)
{
	//напряжения
	_lcd->setCursor(1,0);
	_lcd->print("U:");
	_lcd->setCursor(3,0);
	_lcd->print(ValueToDisplyStr(currentVoltagesValue));
}

void Display16x2::PowerPrint(float powerValue)
{
	//ваты
	_lcd->setCursor(1,1);
	_lcd->print("W:");
	_lcd->setCursor(3,1);
	_lcd->print(ValueToDisplyStr(powerValue));
}

void Display16x2::AmperagedPrint(float setAmperagedValue, float currentAmperagedValue)
{
	//ток
	_lcd->setCursor(10,0);
	_lcd->print("I:");
	_lcd->setCursor(12,0);
	_lcd->print(ValueToDisplyStr(setAmperagedValue));
	_lcd->setCursor(10,1);
	_lcd->print("I:");
	_lcd->setCursor(12,1);
	_lcd->print(ValueToDisplyStr(currentAmperagedValue));
}

void Display16x2::ModePrint(ModeEnum mode)
{
	//состояние
	if(mode == ModeEnum::SetVoltage)
	{
		_lcd->setCursor(9,0);
		_lcd->print(" ");
		_lcd->setCursor(0,0);
		_lcd->print(">");
	}
	else if(mode == ModeEnum::SetAmperaged)
	{
		_lcd->setCursor(0,0);
		_lcd->print(" ");
		_lcd->setCursor(9,0);
		_lcd->print(">");
	}
	else
	{
		_lcd->setCursor(0,0);
		_lcd->print(" ");
		_lcd->setCursor(9,0);
		_lcd->print(" ");
	}
}

void Display16x2::SetCursor(int pos, int line)
{
	_lcd->setCursor(pos, line);
	
}

void Display16x2::Print(const char c[])
{
	_lcd->print(c);
}

void Display16x2::Print(int i)
{
	_lcd->print(i);
}

void Display16x2::Clear()
{
	_lcd->clear();
}

void Display16x2::Write(int value)
{
	_lcd->write(value);
}

void  Display16x2::PrintProgressBar(int line, int procent)
{
	int progress = round(((float)16*(float)min(procent,100))/(float)100);
	for(int i=0; i<progress;i++)
	{
		_lcd->setCursor(i,line);
		_lcd->write(0xFF);
	}
	
	for(int i=15; i>= progress;i--)
	{
		_lcd->setCursor(i,line);
		_lcd->print(" ");
	}
}

void Display16x2::PrintTempAndFunStatus(int temp, int funPower)
{
	_lcd->setCursor(0,0);
	_lcd->print("t=");
	_lcd->setCursor(2,0);
	if(temp<-55)
	{
		_lcd->print("non ");
	}
	else
	{
		_lcd->print(ValueToDisplyStr(temp));
		_lcd->setCursor(5,0);
		_lcd->print("C");
	}
	
	_lcd->setCursor(8,0);
	_lcd->print("Fan=");
	_lcd->setCursor(12,0);
	if(funPower == 0)
	{
		_lcd->print("OFF ");
	}
	else
	{
		_lcd->print(ValueToDisplyStr(funPower));
		_lcd->setCursor(15,0);
		_lcd->print("%");
	}
}

// default constructor
Display16x2::Display16x2()
{
} //Display

// default destructor
Display16x2::~Display16x2()
{
} //~Display
