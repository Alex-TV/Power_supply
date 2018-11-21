
;CodeVisionAVR C Compiler V1.25.9 Standard
;(C) Copyright 1998-2008 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Chip type              : ATmega8
;Program type           : Application
;Clock frequency        : 8,000000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External SRAM size     : 0
;Data Stack size        : 256 byte(s)
;Heap size              : 0 byte(s)
;Promote char to int    : No
;char is unsigned       : Yes
;8 bit enums            : Yes
;Word align FLASH struct: No
;Enhanced core instructions    : On
;Smart register allocation : On
;Automatic register allocation : On

	#pragma AVRPART ADMIN PART_NAME ATmega8
	#pragma AVRPART MEMORY PROG_FLASH 8192
	#pragma AVRPART MEMORY EEPROM 512
	#pragma AVRPART MEMORY INT_SRAM SIZE 1024
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU SPSR=0xE
	.EQU SPDR=0xF
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU EEARH=0x1F
	.EQU WDTCR=0x21
	.EQU MCUCR=0x35
	.EQU GICR=0x3B
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM
	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM
	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM
	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM
	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM
	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM
	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+@1
	ANDI R30,LOW(@2)
	STS  @0+@1,R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+@1
	ANDI R30,LOW(@2)
	STS  @0+@1,R30
	LDS  R30,@0+@1+1
	ANDI R30,HIGH(@2)
	STS  @0+@1+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+@1
	ORI  R30,LOW(@2)
	STS  @0+@1,R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+@1
	ORI  R30,LOW(@2)
	STS  @0+@1,R30
	LDS  R30,@0+@1+1
	ORI  R30,HIGH(@2)
	STS  @0+@1+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __CLRD1S
	LDI  R30,0
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+@1)
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+@1)
	LDI  R31,HIGH(@0+@1)
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+@1)
	LDI  R31,HIGH(2*@0+@1)
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+@1)
	LDI  R31,HIGH(2*@0+@1)
	LDI  R22,BYTE3(2*@0+@1)
	LDI  R23,BYTE4(2*@0+@1)
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+@1)
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+@1)
	LDI  R27,HIGH(@0+@1)
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+@2)
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+@3)
	LDI  R@1,HIGH(@2+@3)
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+@3)
	LDI  R@1,HIGH(@2*2+@3)
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+@1
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+@1
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+@1
	LDS  R31,@0+@1+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+@1
	LDS  R31,@0+@1+1
	LDS  R22,@0+@1+2
	LDS  R23,@0+@1+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+@2
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+@3
	LDS  R@1,@2+@3+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+@1
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+@1
	LDS  R27,@0+@1+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+@1
	LDS  R27,@0+@1+1
	LDS  R24,@0+@1+2
	LDS  R25,@0+@1+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+@1,R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+@1,R30
	STS  @0+@1+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+@1,R30
	STS  @0+@1+1,R31
	STS  @0+@1+2,R22
	STS  @0+@1+3,R23
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+@1,R0
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+@1,R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+@1,R@2
	STS  @0+@1+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+@1
	LDS  R31,@0+@1+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+@1)
	LDI  R31,HIGH(2*@0+@1)
	RCALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	LDI  R26,LOW(@0+@1)
	LDI  R27,HIGH(@0+@1)
	RCALL __EEPROMRDW
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	RCALL __PUTDP1
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	CLR  R0
	ST   Z+,R0
	ST   Z,R0
	.ENDM

	.MACRO __CLRD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	CLR  R0
	ST   Z+,R0
	ST   Z+,R0
	ST   Z+,R0
	ST   Z,R0
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R@1
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

	.CSEG
	.ORG 0

	.INCLUDE "power supply.vec"
	.INCLUDE "power supply.inc"

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  GICR,R31
	OUT  GICR,R30
	OUT  MCUCR,R30

;DISABLE WATCHDOG
	LDI  R31,0x18
	OUT  WDTCR,R31
	OUT  WDTCR,R30

;CLEAR R2-R14
	LDI  R24,13
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(0x400)
	LDI  R25,HIGH(0x400)
	LDI  R26,0x60
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

;STACK POINTER INITIALIZATION
	LDI  R30,LOW(0x45F)
	OUT  SPL,R30
	LDI  R30,HIGH(0x45F)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(0x160)
	LDI  R29,HIGH(0x160)

	RJMP _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x160
;       1 /*****************************************************
;       2 This program was produced by the
;       3 CodeWizardAVR V1.25.9 Standard
;       4 Automatic Program Generator
;       5 © Copyright 1998-2008 Pavel Haiduc, HP InfoTech s.r.l.
;       6 http://www.hpinfotech.com
;       7 
;       8 Project :
;       9 Version :
;      10 Date    : 29.10.2010
;      11 Author  : F4CG
;      12 Company : F4CG
;      13 Comments:
;      14 
;      15 
;      16 Chip type           : ATmega8
;      17 Program type        : Application
;      18 Clock frequency     : 8,000000 MHz
;      19 Memory model        : Small
;      20 External SRAM size  : 0
;      21 Data Stack size     : 256
;      22 *****************************************************/
;      23 
;      24 #include <mega8.h>
;      25 	#ifndef __SLEEP_DEFINED__
	#ifndef __SLEEP_DEFINED__
;      26 	#define __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
;      27 	.EQU __se_bit=0x80
	.EQU __se_bit=0x80
;      28 	.EQU __sm_mask=0x70
	.EQU __sm_mask=0x70
;      29 	.EQU __sm_powerdown=0x20
	.EQU __sm_powerdown=0x20
;      30 	.EQU __sm_powersave=0x30
	.EQU __sm_powersave=0x30
;      31 	.EQU __sm_standby=0x60
	.EQU __sm_standby=0x60
;      32 	.EQU __sm_ext_standby=0x70
	.EQU __sm_ext_standby=0x70
;      33 	.EQU __sm_adc_noise_red=0x10
	.EQU __sm_adc_noise_red=0x10
;      34 	.SET power_ctrl_reg=mcucr
	.SET power_ctrl_reg=mcucr
;      35 	#endif
	#endif
;      36  #include <lcd.h>
;      37 #include <delay.h>
;      38 
;      39 // Alphanumeric LCD Module functions
;      40 #asm
;      41    .equ __lcd_port=0x12 ;PORTD
   .equ __lcd_port=0x12 ;PORTD
;      42 #endasm
;      43 #include <lcd.h>
;      44 
;      45 eeprom unsigned int set_u=0;

	.ESEG
_set_u:
	.DW  0x0
;      46 eeprom unsigned int set_i=0;
_set_i:
	.DW  0x0
;      47 eeprom unsigned int set_u1=0;
_set_u1:
	.DW  0x0
;      48 eeprom unsigned int set_u2=0;
_set_u2:
	.DW  0x0
;      49 eeprom unsigned int set_u3=0;
_set_u3:
	.DW  0x0
;      50 int pwm_val_a=0,pwm_val_b=0,time_out=0,i=0;
;      51 unsigned char set_mode=0,EncState=0,cod_button=0,mode_Display=0;

	.DSEG
_cod_button:
	.BYTE 0x1
_mode_Display:
	.BYTE 0x1
;      52 unsigned char Dig[6];
_Dig:
	.BYTE 0x6
;      53 unsigned long int I_ust=0,I_izm=0,U=0;
_I_ust:
	.BYTE 0x4
_I_izm:
	.BYTE 0x4
_U:
	.BYTE 0x4
;      54 char Counter=0,count=5,k=1;
_Counter:
	.BYTE 0x1
_count:
	.BYTE 0x1
_k:
	.BYTE 0x1
;      55 
;      56 //Функция  антидребезга
;      57   unsigned char incod(void)
;      58   {

	.CSEG
_incod:
;      59    unsigned char cod0=0;
;      60    unsigned char k,cod1;
;      61 
;      62    for(k=0;k<30;k++)
	RCALL __SAVELOCR4
;	cod0 -> R17
;	k -> R16
;	cod1 -> R19
	LDI  R17,0
	LDI  R16,LOW(0)
_0x6:
	CPI  R16,30
	BRSH _0x7
;      63       {
;      64        cod1=PINB&0xF8;
	IN   R30,0x16
	ANDI R30,LOW(0xF8)
	MOV  R19,R30
;      65         if (cod0!=cod1)
	CP   R19,R17
	BREQ _0x8
;      66          {
;      67            k=0;
	LDI  R16,LOW(0)
;      68            cod0=cod1;
	MOV  R17,R19
;      69          }
;      70        }
_0x8:
	SUBI R16,-1
	RJMP _0x6
_0x7:
;      71        return cod1;
	MOV  R30,R19
	RCALL __LOADLOCR4
	ADIW R28,4
	RET
;      72    };
;      73 
;      74     void PrepareData( unsigned long int adc_result)      // Ф-ция для разложения числа
;      75 {
_PrepareData:
;      76 unsigned char Num1=0,Num2=0, Num3=0,Num4=0;
;      77 
;      78 
;      79  while (adc_result >= 1000) //тысяча
	RCALL __SAVELOCR4
;	adc_result -> Y+4
;	Num1 -> R17
;	Num2 -> R16
;	Num3 -> R19
;	Num4 -> R18
	LDI  R16,0
	LDI  R17,0
	LDI  R18,0
	LDI  R19,0
_0x9:
	RCALL SUBOPT_0x0
	__CPD2N 0x3E8
	BRLO _0xB
;      80   {
;      81   adc_result -= 1000;
	RCALL SUBOPT_0x1
	__SUBD1N 1000
	RCALL SUBOPT_0x2
;      82   Num1++;
	SUBI R17,-1
;      83   }
	RJMP _0x9
_0xB:
;      84 
;      85   while (adc_result >= 100) //сотня
_0xC:
	RCALL SUBOPT_0x0
	__CPD2N 0x64
	BRLO _0xE
;      86   {
;      87   adc_result -= 100;
	RCALL SUBOPT_0x1
	__SUBD1N 100
	RCALL SUBOPT_0x2
;      88   Num2++;
	SUBI R16,-1
;      89   }
	RJMP _0xC
_0xE:
;      90    while (adc_result >= 10) //десятки
_0xF:
	RCALL SUBOPT_0x0
	__CPD2N 0xA
	BRLO _0x11
;      91   {
;      92   adc_result -= 10;
	RCALL SUBOPT_0x1
	__SUBD1N 10
	RCALL SUBOPT_0x2
;      93   Num3++;
	SUBI R19,-1
;      94   }
	RJMP _0xF
_0x11:
;      95 
;      96   Num4 = adc_result; //остаток
	LDD  R18,Y+4
;      97   Dig[0] = Num1+0x30;
	MOV  R30,R17
	SUBI R30,-LOW(48)
	STS  _Dig,R30
;      98   Dig[1] = Num2+0x30;
	MOV  R30,R16
	SUBI R30,-LOW(48)
	__PUTB1MN _Dig,1
;      99   Dig[3] = Num3+0x30;
	MOV  R30,R19
	SUBI R30,-LOW(48)
	__PUTB1MN _Dig,3
;     100   Dig[4] = Num4+0x30;
	MOV  R30,R18
	SUBI R30,-LOW(48)
	__PUTB1MN _Dig,4
;     101 }
	RCALL __LOADLOCR4
	ADIW R28,8
	RET
;     102 
;     103 void Display(void)   // Ф-ция  отображения
;     104 {
_Display:
;     105   int i;
;     106   for(i=0; i<6; i++)
	RCALL __SAVELOCR2
;	i -> R16,R17
	__GETWRN 16,17,0
_0x13:
	__CPWRN 16,17,6
	BRGE _0x14
;     107   {
;     108     lcd_putchar(Dig[i]);
	LDI  R26,LOW(_Dig)
	LDI  R27,HIGH(_Dig)
	ADD  R26,R16
	ADC  R27,R17
	LD   R30,X
	RCALL SUBOPT_0x3
;     109   }
	__ADDWRN 16,17,1
	RJMP _0x13
_0x14:
;     110 }
	RCALL __LOADLOCR2P
	RET
;     111 
;     112 
;     113 
;     114 #define ADC_VREF_TYPE 0xC0
;     115 
;     116 // Read the AD conversion result
;     117 unsigned long int read_adc(unsigned char adc_input)
;     118 {
_read_adc:
;     119 ADMUX=adc_input | (ADC_VREF_TYPE & 0xff);
;	adc_input -> Y+0
	LD   R30,Y
	ORI  R30,LOW(0xC0)
	OUT  0x7,R30
;     120 // Delay needed for the stabilization of the ADC input voltage
;     121 delay_us(10);
	__DELAY_USB 27
;     122 // Start the AD conversion
;     123 ADCSRA|=0x40;
	SBI  0x6,6
;     124 // Wait for the AD conversion to complete
;     125 while ((ADCSRA & 0x10)==0);
_0x15:
	SBIS 0x6,4
	RJMP _0x15
;     126 ADCSRA|=0x10;
	SBI  0x6,4
;     127 return ADCW;
	IN   R30,0x4
	IN   R31,0x4+1
	CLR  R22
	CLR  R23
	ADIW R28,1
	RET
;     128 }
;     129 
;     130 
;     131 // Timer 0 overflow interrupt service routine  отображение информации
;     132 interrupt [TIM0_OVF] void timer0_ovf_isr(void)
;     133 {
_timer0_ovf_isr:
	ST   -Y,R0
	ST   -Y,R1
	ST   -Y,R15
	ST   -Y,R22
	ST   -Y,R23
	ST   -Y,R24
	ST   -Y,R25
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
;     134   #asm("wdr")
	wdr
;     135   TCNT0=0x7F;
	LDI  R30,LOW(127)
	OUT  0x32,R30
;     136   time_out+=1;
	MOVW R30,R8
	ADIW R30,1
	MOVW R8,R30
;     137 
;     138 if (Counter++ >=count)
	LDS  R26,_Counter
	SUBI R26,-LOW(1)
	STS  _Counter,R26
	SUBI R26,LOW(1)
	LDS  R30,_count
	CP   R26,R30
	BRSH PC+2
	RJMP _0x18
;     139   {
;     140 
;     141     Counter = 0;
	LDI  R30,LOW(0)
	STS  _Counter,R30
;     142     switch (mode_Display)
	LDS  R30,_mode_Display
;     143      {
;     144     case 0:
	CPI  R30,0
	BREQ PC+2
	RJMP _0x1C
;     145            {
;     146 
;     147     lcd_gotoxy(1,0);
	RCALL SUBOPT_0x4
	RCALL SUBOPT_0x5
	RCALL _lcd_gotoxy
;     148     //напряжение
;     149     PrepareData(pwm_val_b);   //
	MOVW R30,R6
	RCALL SUBOPT_0x6
;     150 
;     151      Dig[2] = '.';
;     152      Dig[5] = 'V';
	LDI  R30,LOW(86)
	RCALL SUBOPT_0x7
;     153      Display();
;     154     lcd_putsf(", ");
	__POINTW1FN _0,0
	RCALL SUBOPT_0x8
;     155 
;     156     //ток измеренный
;     157 
;     158     PrepareData(pwm_val_a);   //
	MOVW R30,R4
	RCALL SUBOPT_0x6
;     159      Dig[2] = '.';
;     160      Dig[5] = 'A';
	LDI  R30,LOW(65)
	RCALL SUBOPT_0x7
;     161     Display();
;     162 
;     163     lcd_gotoxy(1,1);
	RCALL SUBOPT_0x4
	RCALL SUBOPT_0x4
	RCALL _lcd_gotoxy
;     164 
;     165     //ток установленный
;     166     lcd_putsf("Set I=  ");
	__POINTW1FN _0,3
	RCALL SUBOPT_0x8
;     167 
;     168     PrepareData(I_ust/count);   //
	LDS  R30,_count
	RCALL SUBOPT_0x9
	CLR  R31
	CLR  R22
	CLR  R23
	RCALL __DIVD21U
	RCALL __PUTPARD1
	RCALL _PrepareData
;     169      Dig[2] = '.';
	LDI  R30,LOW(46)
	__PUTB1MN _Dig,2
;     170      Dig[5] = 'A';
	LDI  R30,LOW(65)
	RCALL SUBOPT_0x7
;     171     Display();
;     172 
;     173     if (I_izm>=I_ust)
	LDS  R30,_I_ust
	LDS  R31,_I_ust+1
	LDS  R22,_I_ust+2
	LDS  R23,_I_ust+3
	RCALL SUBOPT_0xA
	RCALL __CPD21
	BRLO _0x1D
;     174     { PORTB.0=1;
	SBI  0x18,0
;     175     lcd_gotoxy(0xF,1);
	LDI  R30,LOW(15)
	ST   -Y,R30
	RCALL SUBOPT_0x4
	RCALL _lcd_gotoxy
;     176       lcd_putchar(0xDA);
	LDI  R30,LOW(218)
	RCALL SUBOPT_0x3
;     177     }
;     178     else
	RJMP _0x20
_0x1D:
;     179     {
;     180       lcd_putchar(' ');
	RCALL SUBOPT_0xB
;     181       PORTB.0=0;
	CBI  0x18,0
;     182     }
_0x20:
;     183 
;     184     if (set_mode==1)
	LDI  R30,LOW(1)
	CP   R30,R13
	BRNE _0x23
;     185        { lcd_gotoxy(0,0);
	RCALL SUBOPT_0x5
	RCALL SUBOPT_0x5
	RCALL _lcd_gotoxy
;     186         lcd_putchar(0x3E);
	LDI  R30,LOW(62)
	RCALL SUBOPT_0x3
;     187          lcd_gotoxy(0,1);
	RCALL SUBOPT_0x5
	RCALL SUBOPT_0x4
	RCALL SUBOPT_0xC
;     188           lcd_putchar(0x20);
;     189            };
_0x23:
;     190 
;     191            if (set_mode==2)
	LDI  R30,LOW(2)
	CP   R30,R13
	BRNE _0x24
;     192        { lcd_gotoxy(0,1);
	RCALL SUBOPT_0x5
	RCALL SUBOPT_0x4
	RCALL _lcd_gotoxy
;     193         lcd_putchar(0x3E);
	LDI  R30,LOW(62)
	RCALL SUBOPT_0x3
;     194          lcd_gotoxy(0,0);
	RCALL SUBOPT_0x5
	RCALL SUBOPT_0x5
	RCALL SUBOPT_0xC
;     195           lcd_putchar(0x20);
;     196            };
_0x24:
;     197 
;     198              if (set_mode==0)
	TST  R13
	BRNE _0x25
;     199        { lcd_gotoxy(0,1);
	RCALL SUBOPT_0x5
	RCALL SUBOPT_0x4
	RCALL SUBOPT_0xC
;     200         lcd_putchar(0x20);
;     201          lcd_gotoxy(0,0);
	RCALL SUBOPT_0x5
	RCALL SUBOPT_0x5
	RCALL SUBOPT_0xC
;     202           lcd_putchar(0x20);
;     203            };
_0x25:
;     204            break;
	RJMP _0x1B
;     205            }
;     206     case 1:
_0x1C:
	CPI  R30,LOW(0x1)
	BRNE _0x1B
;     207            {
;     208              lcd_gotoxy(0,0);
	RCALL SUBOPT_0x5
	RCALL SUBOPT_0x5
	RCALL _lcd_gotoxy
;     209              lcd_putsf("    saving      ");
	__POINTW1FN _0,12
	RCALL SUBOPT_0x8
;     210              lcd_gotoxy(0,1);
	RCALL SUBOPT_0x5
	RCALL SUBOPT_0x4
	RCALL _lcd_gotoxy
;     211              lcd_putsf("   complete     ");
	__POINTW1FN _0,29
	RCALL SUBOPT_0x8
;     212            break;
;     213            }
;     214     };
_0x1B:
;     215     U = 0;
	LDI  R30,0
	STS  _U,R30
	STS  _U+1,R30
	STS  _U+2,R30
	STS  _U+3,R30
;     216     I_izm = 0;
	LDI  R30,0
	STS  _I_izm,R30
	STS  _I_izm+1,R30
	STS  _I_izm+2,R30
	STS  _I_izm+3,R30
;     217     I_ust = 0;
	LDI  R30,0
	STS  _I_ust,R30
	STS  _I_ust+1,R30
	STS  _I_ust+2,R30
	STS  _I_ust+3,R30
;     218   }
;     219   else
	RJMP _0x27
_0x18:
;     220   {
;     221    U += read_adc(2) * 2;
	LDI  R30,LOW(2)
	ST   -Y,R30
	RCALL _read_adc
	RCALL __LSLD1
	LDS  R26,_U
	LDS  R27,_U+1
	LDS  R24,_U+2
	LDS  R25,_U+3
	RCALL __ADDD12
	STS  _U,R30
	STS  _U+1,R31
	STS  _U+2,R22
	STS  _U+3,R23
;     222     I_izm += read_adc(0);
	RCALL SUBOPT_0x5
	RCALL _read_adc
	RCALL SUBOPT_0xA
	RCALL __ADDD12
	STS  _I_izm,R30
	STS  _I_izm+1,R31
	STS  _I_izm+2,R22
	STS  _I_izm+3,R23
;     223     I_ust += read_adc(1);
	RCALL SUBOPT_0x4
	RCALL _read_adc
	RCALL SUBOPT_0x9
	RCALL __ADDD12
	STS  _I_ust,R30
	STS  _I_ust+1,R31
	STS  _I_ust+2,R22
	STS  _I_ust+3,R23
;     224   }
_0x27:
;     225 
;     226 
;     227 
;     228 
;     229 
;     230 // Place your code here
;     231 
;     232 }
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R25,Y+
	LD   R24,Y+
	LD   R23,Y+
	LD   R22,Y+
	LD   R15,Y+
	LD   R1,Y+
	LD   R0,Y+
	RETI
;     233 
;     234 void EncoderScan(void) // Функция опроса энкодера
;     235 {
_EncoderScan:
;     236 unsigned char New=0;
;     237 
;     238 New = incod();	// Берем текущее значение
	ST   -Y,R17
;	New -> R17
	LDI  R17,0
	RCALL _incod
	MOV  R17,R30
;     239 			// И сравниваем со старым
;     240 
;     241 // Смотря в какую сторону оно поменялось -- увеличиваем
;     242 // Или уменьшаем соответствующий параметр
;     243 
;     244   if (set_mode==1)
	LDI  R30,LOW(1)
	CP   R30,R13
	BRNE _0x28
;     245    {
;     246 
;     247 switch(EncState)
	MOV  R30,R12
;     248 	{
;     249 	case 184:
	CPI  R30,LOW(0xB8)
	BRNE _0x2C
;     250 		{
;     251 		if(New == 248) pwm_val_b++;
	CPI  R17,248
	BRNE _0x2D
	RCALL SUBOPT_0xD
;     252 		if(New == 56) pwm_val_b--;
_0x2D:
	CPI  R17,56
	BRNE _0x2E
	RCALL SUBOPT_0xE
;     253 		break;
_0x2E:
	RJMP _0x2B
;     254 		}
;     255 
;     256 	case 56:
_0x2C:
	CPI  R30,LOW(0x38)
	BRNE _0x2F
;     257 		{
;     258 		if(New == 184) pwm_val_b++;
	CPI  R17,184
	BRNE _0x30
	RCALL SUBOPT_0xD
;     259 		if(New == 120) pwm_val_b--;
_0x30:
	CPI  R17,120
	BRNE _0x31
	RCALL SUBOPT_0xE
;     260 		break;
_0x31:
	RJMP _0x2B
;     261 		}
;     262 	case 120:
_0x2F:
	CPI  R30,LOW(0x78)
	BRNE _0x32
;     263 		{
;     264 		if(New == 56) pwm_val_b++;
	CPI  R17,56
	BRNE _0x33
	RCALL SUBOPT_0xD
;     265 		if(New == 248) pwm_val_b--;
_0x33:
	CPI  R17,248
	BRNE _0x34
	RCALL SUBOPT_0xE
;     266 		break;
_0x34:
	RJMP _0x2B
;     267 		}
;     268 	case 248:
_0x32:
	CPI  R30,LOW(0xF8)
	BRNE _0x2B
;     269 		{
;     270 		if(New == 120) pwm_val_b++;
	CPI  R17,120
	BRNE _0x36
	RCALL SUBOPT_0xD
;     271 		if(New == 184) pwm_val_b--;
_0x36:
	CPI  R17,184
	BRNE _0x37
	RCALL SUBOPT_0xE
;     272 		break;
_0x37:
;     273 		}
;     274 	};
_0x2B:
;     275 	if (pwm_val_b>=1023) {pwm_val_b=1023;  }
	LDI  R30,LOW(1023)
	LDI  R31,HIGH(1023)
	CP   R6,R30
	CPC  R7,R31
	BRLT _0x38
	MOVW R6,R30
;     276 else  {
	RJMP _0x39
_0x38:
;     277        if (pwm_val_b<=0) {pwm_val_b=0;};
	CLR  R0
	CP   R0,R6
	CPC  R0,R7
	BRLT _0x3A
	CLR  R6
	CLR  R7
_0x3A:
;     278 
;     279     };
_0x39:
;     280 	if (New!=EncState)
	CP   R12,R17
	BREQ _0x3B
;     281 	{   OCR1B=pwm_val_b;
	__OUTWR 6,7,40
;     282 	time_out=0;
	RCALL SUBOPT_0xF
;     283 	   };
_0x3B:
;     284 
;     285     }
;     286 else
	RJMP _0x3C
_0x28:
;     287  {
;     288    if (set_mode==2)
	LDI  R30,LOW(2)
	CP   R30,R13
	BRNE _0x3D
;     289    {
;     290 
;     291 switch(EncState)
	MOV  R30,R12
;     292 	{
;     293 	case 184:
	CPI  R30,LOW(0xB8)
	BRNE _0x41
;     294 		{
;     295 		if(New == 248) pwm_val_a++;
	CPI  R17,248
	BRNE _0x42
	RCALL SUBOPT_0x10
;     296 		if(New == 56) pwm_val_a--;
_0x42:
	CPI  R17,56
	BRNE _0x43
	RCALL SUBOPT_0x11
;     297 		break;
_0x43:
	RJMP _0x40
;     298 		}
;     299 
;     300 	case 56:
_0x41:
	CPI  R30,LOW(0x38)
	BRNE _0x44
;     301 		{
;     302 		if(New == 184) pwm_val_a++;
	CPI  R17,184
	BRNE _0x45
	RCALL SUBOPT_0x10
;     303 		if(New == 120) pwm_val_a--;
_0x45:
	CPI  R17,120
	BRNE _0x46
	RCALL SUBOPT_0x11
;     304 		break;
_0x46:
	RJMP _0x40
;     305 		}
;     306 	case 120:
_0x44:
	CPI  R30,LOW(0x78)
	BRNE _0x47
;     307 		{
;     308 		if(New == 56) pwm_val_a++;
	CPI  R17,56
	BRNE _0x48
	RCALL SUBOPT_0x10
;     309 		if(New == 248) pwm_val_a--;
_0x48:
	CPI  R17,248
	BRNE _0x49
	RCALL SUBOPT_0x11
;     310 		break;
_0x49:
	RJMP _0x40
;     311 		}
;     312 	case 248:
_0x47:
	CPI  R30,LOW(0xF8)
	BRNE _0x40
;     313 		{
;     314 		if(New == 120) pwm_val_a++;
	CPI  R17,120
	BRNE _0x4B
	RCALL SUBOPT_0x10
;     315 		if(New == 184) pwm_val_a--;
_0x4B:
	CPI  R17,184
	BRNE _0x4C
	RCALL SUBOPT_0x11
;     316 		break;
_0x4C:
;     317 		}
;     318 	}
_0x40:
;     319 	if (pwm_val_a>=511)
	LDI  R30,LOW(511)
	LDI  R31,HIGH(511)
	CP   R4,R30
	CPC  R5,R31
	BRLT _0x4D
;     320 	 {
;     321 	     pwm_val_a=511;
	MOVW R4,R30
;     322 	   }
;     323 else  {
	RJMP _0x4E
_0x4D:
;     324        if (pwm_val_a<=0) {pwm_val_a=0;};
	CLR  R0
	CP   R0,R4
	CPC  R0,R5
	BRLT _0x4F
	CLR  R4
	CLR  R5
_0x4F:
;     325 
;     326     };
_0x4E:
;     327 
;     328 
;     329 	if (New!=EncState) {   OCR1A=pwm_val_a;
	CP   R12,R17
	BREQ _0x50
	__OUTWR 4,5,42
;     330 	                       time_out=0;   };
	RCALL SUBOPT_0xF
_0x50:
;     331 
;     332 	};
_0x3D:
;     333 	};
_0x3C:
;     334 
;     335 EncState = New;		// Записываем новое значение
	MOV  R12,R17
;     336 				// Предыдущего состояния
;     337 
;     338  };
	LD   R17,Y+
	RET
;     339 // Declare your global variables here
;     340 
;     341 void main(void)
;     342 {
_main:
;     343 // Declare your local variables here
;     344 
;     345 // Input/Output Ports initialization
;     346 // Port B initialization
;     347 // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=Out Func1=Out Func0=Out
;     348 // State7=P State6=P State5=P State4=P State3=P State2=0 State1=0 State0=0
;     349 PORTB=0xF8;
	LDI  R30,LOW(248)
	OUT  0x18,R30
;     350 DDRB=0x07;
	LDI  R30,LOW(7)
	OUT  0x17,R30
;     351 
;     352 // Port C initialization
;     353 // Func6=In Func5=Out Func4=Out Func3=In Func2=In Func1=In Func0=In
;     354 // State6=T State5=0 State4=0 State3=P State2=T State1=T State0=T
;     355 PORTC=0x08;
	LDI  R30,LOW(8)
	OUT  0x15,R30
;     356 DDRC=0x30;
	LDI  R30,LOW(48)
	OUT  0x14,R30
;     357 
;     358 // Port D initialization
;     359 // Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out
;     360 // State7=0 State6=0 State5=0 State4=0 State3=0 State2=0 State1=0 State0=0
;     361 PORTD=0x00;
	LDI  R30,LOW(0)
	OUT  0x12,R30
;     362 DDRD=0xFF;
	LDI  R30,LOW(255)
	OUT  0x11,R30
;     363 
;     364 // Timer/Counter 0 initialization
;     365 // Clock source: System Clock
;     366 // Clock value: 7,813 kHz
;     367 TCCR0=0x05;
	LDI  R30,LOW(5)
	OUT  0x33,R30
;     368 TCNT0=0x7F;
	LDI  R30,LOW(127)
	OUT  0x32,R30
;     369 
;     370 // Timer/Counter 1 initialization
;     371 // Clock source: System Clock
;     372 // Clock value: 8000,000 kHz
;     373 // Mode: Ph. correct PWM top=03FFh
;     374 // OC1A output: Non-Inv.
;     375 // OC1B output: Non-Inv.
;     376 // Noise Canceler: Off
;     377 // Input Capture on Falling Edge
;     378 // Timer 1 Overflow Interrupt: Off
;     379 // Input Capture Interrupt: Off
;     380 // Compare A Match Interrupt: Off
;     381 // Compare B Match Interrupt: Off
;     382 TCCR1A=0xA3;
	LDI  R30,LOW(163)
	OUT  0x2F,R30
;     383 TCCR1B=0x01;
	LDI  R30,LOW(1)
	OUT  0x2E,R30
;     384 TCNT1H=0x00;
	LDI  R30,LOW(0)
	OUT  0x2D,R30
;     385 TCNT1L=0x00;
	OUT  0x2C,R30
;     386 ICR1H=0x00;
	OUT  0x27,R30
;     387 ICR1L=0x00;
	OUT  0x26,R30
;     388 OCR1AH=0x00;
	OUT  0x2B,R30
;     389 OCR1AL=0x00;
	OUT  0x2A,R30
;     390 OCR1BH=0x00;
	OUT  0x29,R30
;     391 OCR1BL=0x00;
	OUT  0x28,R30
;     392 
;     393 // Timer/Counter 2 initialization
;     394 // Clock source: System Clock
;     395 // Clock value: Timer 2 Stopped
;     396 // Mode: Normal top=FFh
;     397 // OC2 output: Disconnected
;     398 ASSR=0x00;
	OUT  0x22,R30
;     399 TCCR2=0x00;
	OUT  0x25,R30
;     400 TCNT2=0x00;
	OUT  0x24,R30
;     401 OCR2=0x00;
	OUT  0x23,R30
;     402 
;     403 // External Interrupt(s) initialization
;     404 // INT0: Off
;     405 // INT1: Off
;     406 MCUCR=0x00;
	OUT  0x35,R30
;     407 
;     408 // Timer(s)/Counter(s) Interrupt(s) initialization
;     409 TIMSK=0x01;
	LDI  R30,LOW(1)
	OUT  0x39,R30
;     410 
;     411 // Analog Comparator initialization
;     412 // Analog Comparator: Off
;     413 // Analog Comparator Input Capture by Timer/Counter 1: Off
;     414 ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
;     415 SFIOR=0x00;
	LDI  R30,LOW(0)
	OUT  0x30,R30
;     416 
;     417 // ADC initialization
;     418 // ADC Clock frequency: 1000,000 kHz
;     419 // ADC Voltage Reference: Int., cap. on AREF
;     420 ADMUX=ADC_VREF_TYPE & 0xff;
	LDI  R30,LOW(192)
	OUT  0x7,R30
;     421 ADCSRA=0x83;
	LDI  R30,LOW(131)
	OUT  0x6,R30
;     422 
;     423 // LCD module initialization
;     424 lcd_init(16);
	LDI  R30,LOW(16)
	ST   -Y,R30
	RCALL _lcd_init
;     425 
;     426 // Watchdog Timer initialization
;     427 // Watchdog Timer Prescaler: OSC/2048k
;     428 #pragma optsize-
;     429 WDTCR=0x1F;
	LDI  R30,LOW(31)
	OUT  0x21,R30
;     430 WDTCR=0x0F;
	LDI  R30,LOW(15)
	OUT  0x21,R30
;     431 #ifdef _OPTIMIZE_SIZE_
;     432 #pragma optsize+
;     433 #endif
;     434  pwm_val_a=set_i;
	LDI  R26,LOW(_set_i)
	LDI  R27,HIGH(_set_i)
	RCALL __EEPROMRDW
	MOVW R4,R30
;     435   pwm_val_b=set_u;
	LDI  R26,LOW(_set_u)
	LDI  R27,HIGH(_set_u)
	RCALL __EEPROMRDW
	MOVW R6,R30
;     436   OCR1A=pwm_val_a;
	__OUTWR 4,5,42
;     437   OCR1B=pwm_val_b;
	__OUTWR 6,7,40
;     438    lcd_clear();
	RCALL _lcd_clear
;     439      i=0;
	CLR  R10
	CLR  R11
;     440  lcd_gotoxy(0,0);
	RCALL SUBOPT_0x5
	RCALL SUBOPT_0x5
	RCALL _lcd_gotoxy
;     441  lcd_putsf("scheme, firmware");
	__POINTW1FN _0,46
	RCALL SUBOPT_0x8
;     442  lcd_gotoxy(4,1);
	LDI  R30,LOW(4)
	ST   -Y,R30
	RCALL SUBOPT_0x4
	RCALL _lcd_gotoxy
;     443  lcd_putsf(" SONATA");
	__POINTW1FN _0,63
	RCALL SUBOPT_0x8
;     444   while (i<200) {i+=1;
_0x51:
	RCALL SUBOPT_0x12
	BRGE _0x53
	RCALL SUBOPT_0x13
;     445   delay_ms(5);};
	RJMP _0x51
_0x53:
;     446  i=0;
	CLR  R10
	CLR  R11
;     447  lcd_clear();
	RCALL _lcd_clear
;     448  lcd_gotoxy(2,0);
	LDI  R30,LOW(2)
	ST   -Y,R30
	RCALL SUBOPT_0x5
	RCALL _lcd_gotoxy
;     449 lcd_putsf("power supply");
	__POINTW1FN _0,71
	RCALL SUBOPT_0x8
;     450  lcd_gotoxy(4,1);
	LDI  R30,LOW(4)
	ST   -Y,R30
	RCALL SUBOPT_0x4
	RCALL _lcd_gotoxy
;     451  lcd_putsf(" ver 2.0");
	__POINTW1FN _0,84
	RCALL SUBOPT_0x8
;     452   while (i<200) {i+=1;
_0x54:
	RCALL SUBOPT_0x12
	BRGE _0x56
	RCALL SUBOPT_0x13
;     453   delay_ms(5);};
	RJMP _0x54
_0x56:
;     454   i=0;
	CLR  R10
	CLR  R11
;     455 
;     456 
;     457 // Global enable interrupts
;     458 #asm("sei")
	sei
;     459 PORTC.4=1;
	SBI  0x15,4
;     460 
;     461 while (1)
_0x59:
;     462       {
;     463        if (PINC.3==0)
	SBIC 0x13,3
	RJMP _0x5C
;     464        {
;     465        k=0;
	LDI  R30,LOW(0)
	STS  _k,R30
;     466        time_out=0;
	RCALL SUBOPT_0xF
;     467         set_mode+=1;
	INC  R13
;     468          if (set_mode>2) {set_mode=0;};
	LDI  R30,LOW(2)
	CP   R30,R13
	BRSH _0x5D
	CLR  R13
_0x5D:
;     469          while (PINC.3==0) {    };
_0x5E:
	SBIS 0x13,3
	RJMP _0x5E
;     470           };
_0x5C:
;     471 
;     472      if (k<1)
	LDS  R26,_k
	CPI  R26,LOW(0x1)
	BRSH _0x61
;     473      { EncoderScan();
	RCALL _EncoderScan
;     474         if (time_out>200)
	LDI  R30,LOW(200)
	LDI  R31,HIGH(200)
	RCALL SUBOPT_0x14
	BRGE _0x62
;     475         { set_mode=0;
	CLR  R13
;     476           k=1;
	LDI  R30,LOW(1)
	STS  _k,R30
;     477         set_i=pwm_val_a;
	MOVW R30,R4
	LDI  R26,LOW(_set_i)
	LDI  R27,HIGH(_set_i)
	RCALL __EEPROMWRW
;     478          set_u=pwm_val_b;
	MOVW R30,R6
	LDI  R26,LOW(_set_u)
	LDI  R27,HIGH(_set_u)
	RCALL __EEPROMWRW
;     479                     };
_0x62:
;     480         };
_0x61:
;     481         if (PINB.3==0||PINB.4==0||PINB.5==0)
	SBIS 0x16,3
	RJMP _0x64
	SBIS 0x16,4
	RJMP _0x64
	SBIC 0x16,5
	RJMP _0x63
_0x64:
;     482         {  cod_button=(incod()&0x38);
	RCALL _incod
	ANDI R30,LOW(0x38)
	STS  _cod_button,R30
;     483            time_out=0;
	RCALL SUBOPT_0xF
;     484                if (cod_button==0x30)
	LDS  R26,_cod_button
	CPI  R26,LOW(0x30)
	BRNE _0x66
;     485                 {
;     486                   while (PINB.3==0)
_0x67:
	SBIC 0x16,3
	RJMP _0x69
;     487                    {if (time_out>100)
	RCALL SUBOPT_0x15
	BRGE _0x6A
;     488                        {set_u1=pwm_val_b;
	MOVW R30,R6
	LDI  R26,LOW(_set_u1)
	LDI  R27,HIGH(_set_u1)
	RCALL __EEPROMWRW
;     489                        mode_Display=1;
	RCALL SUBOPT_0x16
;     490 
;     491                         };
_0x6A:
;     492 
;     493                       };
	RJMP _0x67
_0x69:
;     494                       mode_Display=0;
	RCALL SUBOPT_0x17
;     495                       OCR1B=set_u1;
	LDI  R26,LOW(_set_u1)
	LDI  R27,HIGH(_set_u1)
	RCALL __EEPROMRDW
	OUT  0x28+1,R31
	OUT  0x28,R30
;     496                       pwm_val_b=set_u1;
	LDI  R26,LOW(_set_u1)
	LDI  R27,HIGH(_set_u1)
	RCALL __EEPROMRDW
	MOVW R6,R30
;     497 
;     498                   }
;     499         else  {
	RJMP _0x6B
_0x66:
;     500                  if (cod_button==0x28)
	LDS  R26,_cod_button
	CPI  R26,LOW(0x28)
	BRNE _0x6C
;     501                 {
;     502                   while (PINB.4==0)
_0x6D:
	SBIC 0x16,4
	RJMP _0x6F
;     503                    {if (time_out>100) {set_u2=pwm_val_b;mode_Display=1; };
	RCALL SUBOPT_0x15
	BRGE _0x70
	MOVW R30,R6
	LDI  R26,LOW(_set_u2)
	LDI  R27,HIGH(_set_u2)
	RCALL __EEPROMWRW
	RCALL SUBOPT_0x16
_0x70:
;     504 
;     505                       };
	RJMP _0x6D
_0x6F:
;     506                       mode_Display=0;
	RCALL SUBOPT_0x17
;     507                       OCR1B=set_u2;
	LDI  R26,LOW(_set_u2)
	LDI  R27,HIGH(_set_u2)
	RCALL __EEPROMRDW
	OUT  0x28+1,R31
	OUT  0x28,R30
;     508                       pwm_val_b=set_u2;
	LDI  R26,LOW(_set_u2)
	LDI  R27,HIGH(_set_u2)
	RCALL __EEPROMRDW
	MOVW R6,R30
;     509 
;     510                   }
;     511                else  {
	RJMP _0x71
_0x6C:
;     512                        if (cod_button==0x18)
	LDS  R26,_cod_button
	CPI  R26,LOW(0x18)
	BRNE _0x72
;     513                 {
;     514                   while (PINB.5==0)
_0x73:
	SBIC 0x16,5
	RJMP _0x75
;     515                    {if (time_out>100) {set_u3=pwm_val_b;mode_Display=1; };
	RCALL SUBOPT_0x15
	BRGE _0x76
	MOVW R30,R6
	LDI  R26,LOW(_set_u3)
	LDI  R27,HIGH(_set_u3)
	RCALL __EEPROMWRW
	RCALL SUBOPT_0x16
_0x76:
;     516 
;     517                       };
	RJMP _0x73
_0x75:
;     518                       mode_Display=0;
	RCALL SUBOPT_0x17
;     519                       OCR1B=pwm_val_b=set_u3;
	LDI  R26,LOW(_set_u3)
	LDI  R27,HIGH(_set_u3)
	RCALL __EEPROMRDW
	MOVW R6,R30
	OUT  0x28+1,R31
	OUT  0x28,R30
;     520 
;     521                   }
;     522 
;     523                       };
_0x72:
_0x71:
;     524 
;     525 
;     526 
;     527                };
_0x6B:
;     528 
;     529 
;     530 
;     531 
;     532 
;     533 
;     534 
;     535             };
_0x63:
;     536 
;     537 
;     538       // Place your code here
;     539 
;     540 
;     541 
;     542 
;     543       };
	RJMP _0x59
;     544 
;     545 }
_0x77:
	RJMP _0x77

    .equ __lcd_direction=__lcd_port-1
    .equ __lcd_pin=__lcd_port-2
    .equ __lcd_rs=0
    .equ __lcd_rd=1
    .equ __lcd_enable=2
    .equ __lcd_busy_flag=7

	.DSEG
__base_y_G2:
	.BYTE 0x4
__lcd_x:
	.BYTE 0x1
__lcd_y:
	.BYTE 0x1
__lcd_maxx:
	.BYTE 0x1

	.CSEG
__lcd_delay_G2:
    ldi   r31,15
__lcd_delay0:
    dec   r31
    brne  __lcd_delay0
	RET
__lcd_ready:
    in    r26,__lcd_direction
    andi  r26,0xf                 ;set as input
    out   __lcd_direction,r26
    sbi   __lcd_port,__lcd_rd     ;RD=1
    cbi   __lcd_port,__lcd_rs     ;RS=0
__lcd_busy:
	RCALL __lcd_delay_G2
    sbi   __lcd_port,__lcd_enable ;EN=1
	RCALL __lcd_delay_G2
    in    r26,__lcd_pin
    cbi   __lcd_port,__lcd_enable ;EN=0
	RCALL __lcd_delay_G2
    sbi   __lcd_port,__lcd_enable ;EN=1
	RCALL __lcd_delay_G2
    cbi   __lcd_port,__lcd_enable ;EN=0
    sbrc  r26,__lcd_busy_flag
    rjmp  __lcd_busy
	RET
__lcd_write_nibble_G2:
    andi  r26,0xf0
    or    r26,r27
    out   __lcd_port,r26          ;write
    sbi   __lcd_port,__lcd_enable ;EN=1
	RCALL __lcd_delay_G2
    cbi   __lcd_port,__lcd_enable ;EN=0
	RCALL __lcd_delay_G2
	RET
__lcd_write_data:
    cbi  __lcd_port,__lcd_rd 	  ;RD=0
    in    r26,__lcd_direction
    ori   r26,0xf0 | (1<<__lcd_rs) | (1<<__lcd_rd) | (1<<__lcd_enable) ;set as output    
    out   __lcd_direction,r26
    in    r27,__lcd_port
    andi  r27,0xf
    ld    r26,y
	RCALL __lcd_write_nibble_G2
    ld    r26,y
    swap  r26
	RCALL __lcd_write_nibble_G2
    sbi   __lcd_port,__lcd_rd     ;RD=1
	ADIW R28,1
	RET
__lcd_read_nibble_G2:
    sbi   __lcd_port,__lcd_enable ;EN=1
	RCALL __lcd_delay_G2
    in    r30,__lcd_pin           ;read
    cbi   __lcd_port,__lcd_enable ;EN=0
	RCALL __lcd_delay_G2
    andi  r30,0xf0
	RET
_lcd_read_byte0_G2:
	RCALL __lcd_delay_G2
	RCALL __lcd_read_nibble_G2
    mov   r26,r30
	RCALL __lcd_read_nibble_G2
    cbi   __lcd_port,__lcd_rd     ;RD=0
    swap  r30
    or    r30,r26
	RET
_lcd_gotoxy:
	RCALL __lcd_ready
	LD   R30,Y
	LDI  R31,0
	SUBI R30,LOW(-__base_y_G2)
	SBCI R31,HIGH(-__base_y_G2)
	LD   R30,Z
	LDD  R26,Y+1
	ADD  R30,R26
	RCALL SUBOPT_0x18
	LDD  R30,Y+1
	STS  __lcd_x,R30
	LD   R30,Y
	STS  __lcd_y,R30
	ADIW R28,2
	RET
_lcd_clear:
	RCALL __lcd_ready
	LDI  R30,LOW(2)
	RCALL SUBOPT_0x18
	RCALL __lcd_ready
	LDI  R30,LOW(12)
	RCALL SUBOPT_0x18
	RCALL __lcd_ready
	RCALL SUBOPT_0x4
	RCALL __lcd_write_data
	LDI  R30,LOW(0)
	STS  __lcd_y,R30
	STS  __lcd_x,R30
	RET
_lcd_putchar:
    push r30
    push r31
    ld   r26,y
    set
    cpi  r26,10
    breq __lcd_putchar1
    clt
	LDS  R30,__lcd_x
	SUBI R30,-LOW(1)
	STS  __lcd_x,R30
	LDS  R30,__lcd_maxx
	LDS  R26,__lcd_x
	CP   R30,R26
	BRSH _0x79
	__lcd_putchar1:
	LDS  R30,__lcd_y
	SUBI R30,-LOW(1)
	STS  __lcd_y,R30
	RCALL SUBOPT_0x5
	LDS  R30,__lcd_y
	ST   -Y,R30
	RCALL _lcd_gotoxy
	brts __lcd_putchar0
_0x79:
    rcall __lcd_ready
    sbi  __lcd_port,__lcd_rs ;RS=1
    ld   r26,y
    st   -y,r26
    rcall __lcd_write_data
__lcd_putchar0:
    pop  r31
    pop  r30
	ADIW R28,1
	RET
_lcd_putsf:
	ST   -Y,R17
_0x7D:
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	ADIW R30,1
	STD  Y+1,R30
	STD  Y+1+1,R31
	SBIW R30,1
	LPM  R30,Z
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x7F
	ST   -Y,R17
	RCALL _lcd_putchar
	RJMP _0x7D
_0x7F:
	LDD  R17,Y+0
	ADIW R28,3
	RET
__long_delay_G2:
    clr   r26
    clr   r27
__long_delay0:
    sbiw  r26,1         ;2 cycles
    brne  __long_delay0 ;2 cycles
	RET
__lcd_init_write_G2:
    cbi  __lcd_port,__lcd_rd 	  ;RD=0
    in    r26,__lcd_direction
    ori   r26,0xf7                ;set as output
    out   __lcd_direction,r26
    in    r27,__lcd_port
    andi  r27,0xf
    ld    r26,y
	RCALL __lcd_write_nibble_G2
    sbi   __lcd_port,__lcd_rd     ;RD=1
	ADIW R28,1
	RET
_lcd_init:
    cbi   __lcd_port,__lcd_enable ;EN=0
    cbi   __lcd_port,__lcd_rs     ;RS=0
	LD   R30,Y
	STS  __lcd_maxx,R30
	SUBI R30,-LOW(128)
	__PUTB1MN __base_y_G2,2
	LD   R30,Y
	SUBI R30,-LOW(192)
	__PUTB1MN __base_y_G2,3
	RCALL SUBOPT_0x19
	RCALL SUBOPT_0x19
	RCALL SUBOPT_0x19
	RCALL __long_delay_G2
	LDI  R30,LOW(32)
	ST   -Y,R30
	RCALL __lcd_init_write_G2
	RCALL __long_delay_G2
	LDI  R30,LOW(40)
	RCALL SUBOPT_0x18
	RCALL __long_delay_G2
	LDI  R30,LOW(4)
	RCALL SUBOPT_0x18
	RCALL __long_delay_G2
	LDI  R30,LOW(133)
	RCALL SUBOPT_0x18
	RCALL __long_delay_G2
    in    r26,__lcd_direction
    andi  r26,0xf                 ;set as input
    out   __lcd_direction,r26
    sbi   __lcd_port,__lcd_rd     ;RD=1
	RCALL _lcd_read_byte0_G2
	CPI  R30,LOW(0x5)
	BREQ _0x80
	LDI  R30,LOW(0)
	RJMP _0x81
_0x80:
	RCALL __lcd_ready
	LDI  R30,LOW(6)
	RCALL SUBOPT_0x18
	RCALL _lcd_clear
	LDI  R30,LOW(1)
_0x81:
	ADIW R28,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x0:
	__GETD2S 4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x1:
	__GETD1S 4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x2:
	__PUTD1S 4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x3:
	ST   -Y,R30
	RJMP _lcd_putchar

;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x4:
	LDI  R30,LOW(1)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 18 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x5:
	LDI  R30,LOW(0)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x6:
	RCALL __CWD1
	RCALL __PUTPARD1
	RCALL _PrepareData
	LDI  R30,LOW(46)
	__PUTB1MN _Dig,2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x7:
	__PUTB1MN _Dig,5
	RJMP _Display

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x8:
	ST   -Y,R31
	ST   -Y,R30
	RJMP _lcd_putsf

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x9:
	LDS  R26,_I_ust
	LDS  R27,_I_ust+1
	LDS  R24,_I_ust+2
	LDS  R25,_I_ust+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xA:
	LDS  R26,_I_izm
	LDS  R27,_I_izm+1
	LDS  R24,_I_izm+2
	LDS  R25,_I_izm+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xB:
	LDI  R30,LOW(32)
	RJMP SUBOPT_0x3

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xC:
	RCALL _lcd_gotoxy
	RJMP SUBOPT_0xB

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0xD:
	MOVW R30,R6
	ADIW R30,1
	MOVW R6,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0xE:
	MOVW R30,R6
	SBIW R30,1
	MOVW R6,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xF:
	CLR  R8
	CLR  R9
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x10:
	MOVW R30,R4
	ADIW R30,1
	MOVW R4,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x11:
	MOVW R30,R4
	SBIW R30,1
	MOVW R4,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x12:
	LDI  R30,LOW(200)
	LDI  R31,HIGH(200)
	CP   R10,R30
	CPC  R11,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x13:
	MOVW R30,R10
	ADIW R30,1
	MOVW R10,R30
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	ST   -Y,R31
	ST   -Y,R30
	RJMP _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x14:
	CP   R30,R8
	CPC  R31,R9
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x15:
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	RJMP SUBOPT_0x14

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x16:
	LDI  R30,LOW(1)
	STS  _mode_Display,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x17:
	LDI  R30,LOW(0)
	STS  _mode_Display,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x18:
	ST   -Y,R30
	RJMP __lcd_write_data

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x19:
	RCALL __long_delay_G2
	LDI  R30,LOW(48)
	ST   -Y,R30
	RJMP __lcd_init_write_G2

_delay_ms:
	ld   r30,y+
	ld   r31,y+
	adiw r30,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0x7D0
	wdr
	sbiw r30,1
	brne __delay_ms0
__delay_ms1:
	ret

__ADDD12:
	ADD  R30,R26
	ADC  R31,R27
	ADC  R22,R24
	ADC  R23,R25
	RET

__LSLD1:
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R23
	RET

__CWD1:
	MOV  R22,R31
	ADD  R22,R22
	SBC  R22,R22
	MOV  R23,R22
	RET

__DIVD21U:
	PUSH R19
	PUSH R20
	PUSH R21
	CLR  R0
	CLR  R1
	CLR  R20
	CLR  R21
	LDI  R19,32
__DIVD21U1:
	LSL  R26
	ROL  R27
	ROL  R24
	ROL  R25
	ROL  R0
	ROL  R1
	ROL  R20
	ROL  R21
	SUB  R0,R30
	SBC  R1,R31
	SBC  R20,R22
	SBC  R21,R23
	BRCC __DIVD21U2
	ADD  R0,R30
	ADC  R1,R31
	ADC  R20,R22
	ADC  R21,R23
	RJMP __DIVD21U3
__DIVD21U2:
	SBR  R26,1
__DIVD21U3:
	DEC  R19
	BRNE __DIVD21U1
	MOVW R30,R26
	MOVW R22,R24
	MOVW R26,R0
	MOVW R24,R20
	POP  R21
	POP  R20
	POP  R19
	RET

__PUTPARD1:
	ST   -Y,R23
	ST   -Y,R22
	ST   -Y,R31
	ST   -Y,R30
	RET

__EEPROMRDW:
	ADIW R26,1
	RCALL __EEPROMRDB
	MOV  R31,R30
	SBIW R26,1

__EEPROMRDB:
	SBIC EECR,EEWE
	RJMP __EEPROMRDB
	PUSH R31
	IN   R31,SREG
	CLI
	OUT  EEARL,R26
	OUT  EEARH,R27
	SBI  EECR,EERE
	IN   R30,EEDR
	OUT  SREG,R31
	POP  R31
	RET

__EEPROMWRW:
	RCALL __EEPROMWRB
	ADIW R26,1
	PUSH R30
	MOV  R30,R31
	RCALL __EEPROMWRB
	POP  R30
	SBIW R26,1
	RET

__EEPROMWRB:
	SBIS EECR,EEWE
	RJMP __EEPROMWRB1
	WDR
	RJMP __EEPROMWRB
__EEPROMWRB1:
	IN   R25,SREG
	CLI
	OUT  EEARL,R26
	OUT  EEARH,R27
	SBI  EECR,EERE
	IN   R24,EEDR
	CP   R30,R24
	BREQ __EEPROMWRB0
	OUT  EEDR,R30
	SBI  EECR,EEMWE
	SBI  EECR,EEWE
__EEPROMWRB0:
	OUT  SREG,R25
	RET

__CPD21:
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	CPC  R25,R23
	RET

__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

__LOADLOCR2P:
	LD   R16,Y+
	LD   R17,Y+
	RET

;END OF CODE MARKER
__END_OF_CODE:
