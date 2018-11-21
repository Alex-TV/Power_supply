/* 
* IMode.h
*
* Created: 08.09.2018 0:22:37
* Author: koval
*/
 #include "ModeEnum.h"
 #include "Arduino.h"
 #include "IDisplay.h"
 #include "ButtonEnum.h"
 
#ifndef __IMODE_H__
#define __IMODE_H__


class IMode
{
//functions
public:
	virtual ~IMode(){}
	virtual void IncrementEncoderValue() = 0;
	virtual void DecrementEncoderValue() = 0;
	virtual ModeEnum GetTypeMode()=0;
	virtual void SaveEEPROM()=0;
	virtual void ReadEEPROM()=0;
	virtual void PrintState()=0;
	virtual void ReadADC()=0;
	virtual void WritePWM()=0;
	virtual void PrintMode()=0;
	virtual void SavePWMInEeprom(ButtonEnum)=0;
	virtual void ReadPWMInEeprom(ButtonEnum)=0;
	float GetValue()
	{
		return currentValue;
	} 
	
protected:
	int memoryAdress =-1;
    int pwmValue =0;
	int pwmWritePin =-1;
	float currentValue =-1;
	int readValuePin =-1;
	int const ADCCounts = 1024;
    unsigned int const logoReadPWMVoltageInEepromTime = 3*64000;// врем€ показа надписи востановлени€ PWM из пам€ти.
	unsigned int const logoSavePWMVoltageInEepromTime = 3*64000;// врем€ показа надписи записи PWM в пам€ти.

	IDisplay *display;
	
	int ReadMedian (int pin, int samples){
		// массив дл€ хранени€ данных
		int raw[samples];
		// считываем вход и помещаем величину в €чейки массива
		for (int i = 0; i < samples; i++){
			raw[i] = analogRead(pin);
		}
		// сортируем массив по возрастанию значений в €чейках
		int temp = 0; // временна€ переменна€

		for (int i = 0; i < samples; i++){
			for (int j = 0; j < samples - 1; j++){
				if (raw[j] > raw[j + 1]){
					temp = raw[j];
					raw[j] = raw[j + 1];
					raw[j + 1] = temp;
				}
			}
		}
		// возвращаем значение средней €чейки массива
		return raw[samples/2];
	}

}; //IMode

#endif //__IMODE_H__
