.title HW3_two_stage
.option scale=1

.lib 'C:\sky130\models\sky130.lib.spice' TT

**************	Supply *************
VsupplyD VDD 0 1.8
VsupplyS VSS 0 0
IBias VB 0 2.2u
	  
*************** CIRCUIT ***************
* Stage 1 - Differential amplifier &  Current Mirror
M4 VB VB VDD VDD sky130_fd_pr__pfet_01v8__model W=15u L=1u m=1
M5 N5 VB VDD VDD sky130_fd_pr__pfet_01v8__model W=15u L=1u m=1
M0 N0 VIN N5 VDD sky130_fd_pr__pfet_01v8__model W=7.79u L=1u m=1
M1 N1 VIP N5 VDD sky130_fd_pr__pfet_01v8__model W=7.79u L=1u m=1
M2 N0 N0 VSS VSS sky130_fd_pr__nfet_01v8__model W=3u L=1u m=1 
M3 N1 N0 VSS VSS sky130_fd_pr__nfet_01v8__model W=3u L=1u m=1 
* Stage 2 - PMOS Common Source Amplifier
M6 VOP VB VDD VDD sky130_fd_pr__pfet_01v8__model W=7u L=1u m=10
M7 VOP N1 VSS VSS sky130_fd_pr__nfet_01v8__model W=3.5u L=1u m=10 
 
***Capacitor & Resistors
CL VOP 0 2p
CC N1 NX 0.88p
RZ NX VOP 15k

********* TEST BENCH **************
********測試.op .ac 和 output swing 時的訊號源
*V1  VIN  0    DC 0.3
*V2  VIP  VIN  DC 0    AC 1

********測試 slew rate 時的訊號源
R1  VIN     VPULSE  10MEG
R2  VIN     VOP    10MEG
V3  VPULSE  0       PULSE(0.2 0.8 1n 1n 1n 10u 20u)
V4  VIP     0       DC  0.5




 
.control

********選擇自己想要看的參數存下來以便觀察
*save all @M0[gm] @M0[id] @M0[gds] @M0[vth] @M0[vgs] @M0[vgd]  @M1[gm] @M1[id] @M1[gds] @M1[vth] @M1[vgs] @M1[vgd]  @M2[gm] @M2[id] @M2[gds] @M2[vth] @M2[vgs] @M2[vgd]  @M3[gm] @M3[id] @M3[gds] @M3[vth] @M3[vgs] @M3[vgd]  @M4[gm] @M4[id] @M4[gds] @M4[vth] @M4[vgs] @M4[vgd]  @M5[gm] @M5[id] @M5[gds] @M5[vth] @M5[vgs] @M5[vgd]  @M6[gm] @M6[id] @M6[gds] @M6[vth] @M6[vgs] @M6[vgd]  @M7[gm] @M7[id] @M7[gds] @M7[vth] @M7[vgs] @M7[vgd]


********利用.op確認每一個元件的 DC電壓是否正確 注意:要上面有存的才會顯示在raw檔
op 
show m : id vgs vth vds vdsat gm gds cgs

********利用.ac去掃整體電路的ac gain對於頻率的關係
AC dec 0.1 0.01 1G
********用來測試output swing的tb
*dc  v2  -0.2  0.2  0.0001 
*let derout = abs(deriv(v(vop)))
*let vout = v(vop)

********用來測試slew rate的tb
*tran 1n 40us
*let derout = deriv(v(vop))

write two_stage.raw


.endc
.end
