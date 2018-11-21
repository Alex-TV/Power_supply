/*
* Display16x2.h
*
* Created: 04.09.2018 12:33:45
* Author: koval
*/

#include <WString.h>
#include <ModeEnum.h>
#include <IDisplay.h>
#ifndef __DISPLAY16X2_H__
#define __DISPLAY16X2_H__


class Display16x2 : public IDisplay
{
	//variables
	public:
	protected:
	private:

	//functions
	public:
	Display16x2();
	~Display16x2();
	void InitDisplay(const char* strVer);
	void OffPrint();
	void TemperaturePrint(float temperature);
	void MemoryReadPrint(int memNum);
	void MemorySavePrint(int memNum);
	void VoltagesPrint(float pwmVoltagesValue, float currentVoltagesValue);
	void AmperagedPrint(float setAmperagedValue, float currentAmperagedValue);
	void ModePrint(ModeEnum mode);
	void Clear();
	void SetCursor(int pos, int line);
	void Print(const char[]);
	void Print(int);
	void Write(int);
	void PrintProgressBar(int, int);
	void PrintTempAndFunStatus(int, int);
	void PowerPrint(float);
	protected:
	private:
	Display16x2( const Display16x2 &c );
	Display16x2& operator=( const Display16x2 &c );
}; //Display16x2

#endif //__DISPLAY16X2_H__
