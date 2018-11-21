/*
* IDisplay.h
*
* Created: 07.09.2018 23:22:21
* Author: koval
*/

#include <Print.h>

#ifndef __IDISPLAY_H__
#define __IDISPLAY_H__


class IDisplay
{
	//functions
	public:
	virtual ~IDisplay(){}
	virtual	void InitDisplay(const char* strVer) = 0;
	virtual	void OffPrint() = 0;
	virtual	void TemperaturePrint(float temperature) = 0;
	virtual	void MemoryReadPrint(int memNum) = 0;
	virtual	void MemorySavePrint(int memNum) = 0;
	virtual	void VoltagesPrint(float pwmVoltagesValue, float currentVoltagesValue) = 0;
	virtual	void AmperagedPrint(float setAmperagedValue, float currentAmperagedValue) = 0;
	virtual	void ModePrint(ModeEnum mode) = 0;
	virtual	void Clear() = 0;
	
	virtual	void SetCursor(int pos, int line)=0;
	virtual	void Print(const char[])=0;
	virtual	void Print(int)=0;
	virtual	void Write(int)=0;
	virtual void PrintProgressBar(int, int)=0;
	virtual void PrintTempAndFunStatus(int, int)=0;
	virtual void PowerPrint(float) = 0;
	protected :
	String ValueToDisplyStr(float val)
	{
		String result ="";
		int va = val*10;
		result = String(va/10, DEC);
		if(result.length()==2)
		{
			result += ".";
			result += String(va%10, DEC);
		}
		else if(result.length()<2)
		{
			result += ".";
			va = val*100;
			String drop = String(va%100, DEC);
			if(drop.length() == 1)
			drop="0"+drop;
			result += drop;
		}
		if(result.length()==3)
		{
			result += " ";
		}
		return result;
	}
	
	String ValueToDisplyStr(int val)
	{
		String result ="";
		result = String(val, DEC);
		if(result.length()==2)
		{
			result += " ";
		}
		else if(result.length()<2)
		{
			result += "  ";
		}
		return result;
	}

}; //IDisplay

#endif //__IDISPLAY_H__
