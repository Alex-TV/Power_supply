/*
* Display.cpp
*
* Created: 04.09.2018 12:33:45
* Author: koval
*/
#include "Display16x2.h"
#include <LiquidCrystal_I2C.h>
#include "ModeEnum.h"
#include "..\..\ArduinoCore\include\core\Arduino.h"

// продключение дисплея
LiquidCrystal_I2C  lcd (0x27, 16, 2);//параметры дисплея

void Display16x2:: InitDisplay(const char* strVer)
{
	lcd.begin();
	lcd.clear();
	lcd.setCursor(2,0);
	lcd.print("power supply");
	lcd.setCursor(4,1);
	lcd.print(strVer);
}

void Display16x2::OffPrint()
{
	lcd.clear();
	lcd.setCursor(6,0);
	lcd.print("OFF");
}

void Display16x2::TemperaturePrint(float temperature)
{
	lcd.clear();
	lcd.setCursor(0,0);
	lcd.print("max temperature");
	lcd.setCursor(0,1);
	lcd.print("exceeded");
	lcd.setCursor(9,1);
	int va = temperature*10;
	String strTemperature =  String(va/10, DEC);
	strTemperature +="C";
	lcd.print(strTemperature);
}

void Display16x2::MemoryReadPrint(int memNum)
{
	lcd.clear();
	lcd.setCursor(1,0);
	lcd.print("Memory read");
	lcd.setCursor(13,0);
	lcd.print(memNum);
}

void Display16x2::MemorySavePrint(int memNum)
{
	lcd.clear();
	lcd.setCursor(1,0);
	lcd.print("Memory saved");
	lcd.setCursor(13,0);
	lcd.print(memNum);
}


void Display16x2::VoltagesPrint(float pwmVoltagesValue, float currentVoltagesValue)
{
	//напряжения
	lcd.setCursor(1,0);
	lcd.print("U:");
	lcd.setCursor(3,0);
	lcd.print(ValueToDisplyStr(currentVoltagesValue));
}

void Display16x2::PowerPrint(float powerValue)
{
	//ваты
	lcd.setCursor(1,1);
	lcd.print("W:");
	lcd.setCursor(3,1);
	lcd.print(ValueToDisplyStr(powerValue));
}

void Display16x2::AmperagedPrint(float setAmperagedValue, float currentAmperagedValue)
{
	//ток
	lcd.setCursor(10,0);
	lcd.print("I:");
	lcd.setCursor(12,0);
	lcd.print(ValueToDisplyStr(setAmperagedValue));
	lcd.setCursor(10,1);
	lcd.print("I:");
	lcd.setCursor(12,1);
	lcd.print(ValueToDisplyStr(currentAmperagedValue));
}

void Display16x2::ModePrint(ModeEnum mode)
{
	//состояние
	if(mode == ModeEnum::SetVoltage)
	{
		lcd.setCursor(9,0);
		lcd.print(" ");
		lcd.setCursor(0,0);
		lcd.print(">");
	}
	else if(mode == ModeEnum::SetAmperaged)
	{
		lcd.setCursor(0,0);
		lcd.print(" ");
		lcd.setCursor(9,0);
		lcd.print(">");
	}
	else
	{
		lcd.setCursor(0,0);
		lcd.print(" ");
		lcd.setCursor(9,0);
		lcd.print(" ");
	}
}

void Display16x2::SetCursor(int pos, int line)
{
	lcd.setCursor(pos, line);
	
}

void Display16x2::Print(const char c[])
{
	lcd.print(c);
}

void Display16x2::Print(int i)
{
	lcd.print(i);
}

void Display16x2::Clear()
{
	lcd.clear();
}

void Display16x2::Write(int value)
{
	lcd.write(value);
}

void  Display16x2::PrintProgressBar(int line, int procent)
{
	int progress = round(((float)16*(float)min(procent,100))/(float)100);
	for(int i=0; i<progress;i++)
	{
		lcd.setCursor(i,line);
		lcd.write(0xFF);
	}
	
	for(int i=15; i>= progress;i--)
	{
		lcd.setCursor(i,line);
		lcd.print(" ");
	}
}

void Display16x2::PrintTempAndFunStatus(int temp, int funPower)
{
	lcd.setCursor(0,0);
	lcd.print("t=");
	lcd.setCursor(2,0);
	if(temp<-55)
	{
		lcd.print("non ");
	}
	else
	{
		lcd.print(ValueToDisplyStr(temp));
		lcd.setCursor(5,0);
		lcd.print("C");
	}
	
	lcd.setCursor(8,0);
	lcd.print("Fun=");
	lcd.setCursor(12,0);
	if(funPower == 0)
	{
		lcd.print("OFF ");
	}
	else
	{
		lcd.print(ValueToDisplyStr(funPower));
		lcd.setCursor(15,0);
		lcd.print("%");
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
