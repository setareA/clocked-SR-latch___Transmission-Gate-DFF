* clocked SR Latch*
.prot
.inc '32nm_bulk.pm'
.unprot

.param	Lmin=32n
.temp	25
*********************Source Voltages**************
Vdd	1	0  	1
VS	3	0	pulse   0       1       0n      50p	50p     32n   64n
VR	2	0	pulse   0       1       0n      50p	50p     16n   32n
Vc      4	0	pulse	0	1	0n	50p	50p	2n   4n		

*****************INVERTER****************************
.SUBCKT MYinverter IN GND  NODE OUT
M5 	OUT 		IN 		NODE 	NODE 	pmos		w='4*Lmin'	L=Lmin 
M6 	OUT 		IN 		GND 	GND 	nmos		w='2*Lmin'	L=Lmin
CL	OUT		0		5f
.ENDS MYinverter
*****************NAND GATE****************
.SUBCKT MYnand IN1 IN2 GND  NODE OUT
M1  OUT 	IN2 	NODE 	NODE 	pmos		w='4*Lmin'	L=Lmin 
M2  OUT 	IN1 	NODE 	NODE	pmos		w='4*Lmin'	L=Lmin
M3  OUT 	IN1 	point 	GND 	nmos		w='4*Lmin'	L=Lmin
M4  point 	IN2 	GND 	GND 	nmos		w='4*Lmin'	L=Lmin 
CL  OUT		0	10f
.ENDS MYnand

*****************NOR GATE****************
.SUBCKT MYnor IN1 IN2 GND  NODE OUT
M1  point 	IN2 	NODE 	NODE 	pmos		w='4*Lmin'	L=Lmin 
M2  OUT 	IN1 	point 	NODE	pmos		w='4*Lmin'	L=Lmin
M3  OUT 	IN1 	GND	GND 	nmos		w='4*Lmin'	L=Lmin
M4  OUT 	IN2 	GND 	GND 	nmos		w='4*Lmin'	L=Lmin 
CL  OUT		0	10f
.ENDS MYnor
*****************clocked SR Latch****************

X1 3 4 0 1 5 MYnand
X2 5 0 1 7 MYinverter 

X3 2 4 0 1 6 MYnand
X4 6 0 1 8 MYinverter 

X5 7 Q 0 1 notQ MYnor
X6 8 notQ 0 1 Q MYnor

********Measurements******

.MEASURE TRAN t_rise
+ trig V(Q) val = '0.1*1'  rise = 1
+ targ V(Q) val = '0.9*1'  rise = 1

.MEASURE TRAN t_fall
+ trig V(Q) val = '0.9*1'  fall = 1
+ targ V(Q) val = '0.1*1'  fall = 1

.MEASURE Tran SetupTime					
+ trig V(3)  val = '0.5*1' fall = 1
+ targ V(4)  val = '0.5*1' rise = 1

.MEASURE Tran HoldTime					
+ trig V(4)  val = '0.5*1' rise = 1
+ targ V(3)  val = '0.5*1' fall = 1


*************Type of Analysis******** 
.tran	0.1ns     100ns
.op
.end