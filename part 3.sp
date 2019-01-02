*FF*
.prot
.inc '32nm_bulk.pm'
.unprot

.param	Lmin=32n
.temp	25
*********************Source Voltages**************
Vdd	1	0  	1
VD	2	0	pulse   0       1       0n      50p	50p     32n   64n
Vc      3	0	pulse	0	1	0n	50p	50p	2n   4n		

*****************NAND GATE****************
.SUBCKT MYnand IN1 IN2 GND  NODE OUT
M1  OUT 	IN2 	NODE 	NODE 	pmos		w='4*Lmin'	L=Lmin 
M2  OUT 	IN1 	NODE 	NODE	pmos		w='4*Lmin'	L=Lmin
M3  OUT 	IN1 	point 	GND 	nmos		w='4*Lmin'	L=Lmin
M4  point 	IN2 	GND 	GND 	nmos		w='4*Lmin'	L=Lmin 
CL  OUT		0	5f
.ENDS MYnand

*****************NAND GATE 3****************
.SUBCKT MYnand3 IN1 IN2 IN3 GND  NODE OUT
M5  OUT 	IN2 	NODE 	NODE 	pmos		w='4*Lmin'	L=Lmin 
M6  OUT 	IN1 	NODE 	NODE	pmos		w='4*Lmin'	L=Lmin
M7  OUT 	IN3	NODE 	NODE	pmos		w='4*Lmin'	L=Lmin
M8  OUT 	IN1 	point 	GND 	nmos		w='4*Lmin'	L=Lmin
M9  point 	IN2 	point2 	GND 	nmos		w='4*Lmin'	L=Lmin 
M10 point2 	IN3	GND 	GND 	nmos		w='4*Lmin'	L=Lmin 
CL  OUT		0	5f
.ENDS MYnand3


*****************FF ****************

X1 5 7 0 1 6 MYnand
X2 3 6 0 1 7 MYnand


X3 5 7 3 0 1 4 MYnand3
X4 2 4 0 1 5 MYnand


X5 4 Q 0 1 notQ MYnand
X6 notQ 7 0 1 Q MYnand

********Measurements******

.MEASURE TRAN t_rise
+ trig V(Q) val = '0.1*1'  rise = 1
+ targ V(Q) val = '0.9*1'  rise = 1

.MEASURE TRAN t_fall
+ trig V(Q) val = '0.9*1'  fall = 1
+ targ V(Q) val = '0.1*1'  fall = 1

.MEASURE Tran SetupTime					
+ trig V(2)  val = '0.5*1' fall = 1
+ targ V(3)  val = '0.5*1' rise = 1

.MEASURE Tran HoldTime					
+ trig V(3)  val = '0.5*1' rise = 1
+ targ V(2)  val = '0.5*1' fall = 1

.MEASURE Tran t_clk_Q				
+ trig V(3)  val = '0.5*1' fall = 2
+ targ V(Q)  val = '0.5*1' rise = 1



*************Type of Analysis******** 
.tran	0.1ns     100ns
.op
.end