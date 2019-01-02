* Transmission Gate DFF*
.prot
.inc '32nm_bulk.pm'
.unprot

.param	Lmin=32n
.temp	25
*********************Source Voltages**************
Vdd	1	0  	1
VD	2	0	pulse   0       1       0n      50p	50p     32n   64n
Vc      5	0	pulse	0	1	0n	50p	50p	2n   4n		

*****************INVERTER****************************
.SUBCKT MYinverter IN GND  NODE OUT
M1 	OUT 		IN 		NODE 	NODE 	pmos		w='4*Lmin'	L=Lmin 
M2 	OUT 		IN 		GND 	GND 	nmos		w='2*Lmin'	L=Lmin
CL	OUT		0		5f
.ENDS MYinverter

*****************Transmission Gate DFF ****************

X1	5	0	1	notclk	MYinverter  

M3	3	5	2	1	pmos	w='4*Lmin'	L=Lmin  
M4	2	notclk	3	0	nmos	w='2*Lmin'	L=Lmin 
CL1	3		0		5f

X2	3	0	1	4	MYinverter 

M5	6	notclk	4	1	pmos	w='4*Lmin'	L=Lmin  
M6	4	5	6	0	nmos	w='2*Lmin'	L=Lmin 
CL2	6		0		5f

X3	6	0	1	Q	MYinverter 



********Measurements******

.MEASURE TRAN t_rise
+ trig V(Q) val = '0.1*1'  rise = 1
+ targ V(Q) val = '0.9*1'  rise = 1

.MEASURE TRAN t_fall
+ trig V(Q) val = '0.9*1'  fall = 1
+ targ V(Q) val = '0.1*1'  fall = 1

.MEASURE Tran SetupTime					
+ trig V(2)  val = '0.5*1' fall = 1
+ targ V(5)  val = '0.5*1' rise = 1

.MEASURE Tran HoldTime					
+ trig V(5)  val = '0.5*1' rise = 1
+ targ V(2)  val = '0.5*1' fall = 1

.MEASURE Tran t_clk_Q				
+ trig V(5)  val = '0.5*1' fall = 2
+ targ V(Q)  val = '0.5*1' rise = 1



*************Type of Analysis******** 
.tran	0.1ns     100ns
.op
.end