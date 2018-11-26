/*
* IMode.h
*
* Created: 08.09.2018 0:22:37
* Author: koval
*/

#define ADCCounts  1024

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
		return _currentValue;
	}
	
	protected:
	int _memoryAdress =-1;
	int _pwmValue =0;
	int _pwmWritePin =-1;
	float _currentValue =-1;
	int _readValuePin =-1;
    unsigned int const _logoReadPWMVoltageInEepromTime = 3*64000;// ����� ������ ������� ������������� PWM �� ������.
    unsigned int const _logoSavePWMVoltageInEepromTime = 3*64000;// ����� ������ ������� ������ PWM � ������.
	IDisplay* _display;
	
	int ReadMedian (int pin, int samples){
		// ������ ��� �������� ������
		int raw[samples];
		// ��������� ���� � �������� �������� � ������ �������
		for (int i = 0; i < samples; i++){
			raw[i] = analogRead(pin);
		}
		// ��������� ������ �� ����������� �������� � �������
		int temp = 0; // ��������� ����������

		for (int i = 0; i < samples; i++){
			for (int j = 0; j < samples - 1; j++){
				if (raw[j] > raw[j + 1]){
					temp = raw[j];
					raw[j] = raw[j + 1];
					raw[j + 1] = temp;
				}
			}
		}
		// ���������� �������� ������� ������ �������
		return raw[samples/2];
	}
}; //IMode

#endif //__IMODE_H__
