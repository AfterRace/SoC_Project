
L
Command: %s
53*	vivadotcl2

opt_design2default:defaultZ4-113h px
�
@Attempting to get a license for feature '%s' and/or device '%s'
308*common2"
Implementation2default:default2
xc7z0202default:defaultZ17-347h px
�
0Got license for feature '%s' and/or device '%s'
310*common2"
Implementation2default:default2
xc7z0202default:defaultZ17-349h px
�
�The version limit for your license is '%s' and will expire in %s days. A version limit expiration means that, although you may be able to continue to use the current version of tools or IP with this license, you will not be eligible for any updates or new releases.
519*common2
2015.122default:default2
-1332default:defaultZ17-1223h px
k
,Running DRC as a precondition to command %s
22*	vivadotcl2

opt_design2default:defaultZ4-22h px
O

Starting %s Task
103*constraints2
DRC2default:defaultZ18-103h px
M
Running DRC with %s threads
24*drc2
42default:defaultZ23-27h px
R
DRC finished with %s
272*project2
0 Errors2default:defaultZ1-461h px
a
BPlease refer to the DRC report (report_drc) for more information.
274*projectZ1-462h px
�

%s
*constraints2�
�Time (s): cpu = 00:00:00.30 ; elapsed = 00:00:00.32 . Memory (MB): peak = 1213.824 ; gain = 6.012 ; free physical = 10230 ; free virtual = 148352default:defaulth px
B
%Done setting XDC timing constraints.
35*timingZ38-35h px
5
Deriving generated clocks
2*timingZ38-2h px
^

Starting %s Task
103*constraints2&
Logic Optimization2default:defaultZ18-103h px
f

Phase %s%s
101*constraints2
1 2default:default2
Retarget2default:defaultZ18-101h px
r
)Pushed %s inverter(s) to %s load pin(s).
98*opt2
02default:default2
02default:defaultZ31-138h px
H
Retargeted %s cell(s).
49*opt2
02default:defaultZ31-49h px
9
'Phase 1 Retarget | Checksum: 1eff6e865
*commonh px
�

%s
*constraints2�
�Time (s): cpu = 00:00:00.93 ; elapsed = 00:00:00.91 . Memory (MB): peak = 1680.332 ; gain = 0.000 ; free physical = 9857 ; free virtual = 144652default:defaulth px
r

Phase %s%s
101*constraints2
2 2default:default2(
Constant Propagation2default:defaultZ18-101h px
r
)Pushed %s inverter(s) to %s load pin(s).
98*opt2
02default:default2
02default:defaultZ31-138h px
G
Eliminated %s cells.
10*opt2
162default:defaultZ31-10h px
E
3Phase 2 Constant Propagation | Checksum: 1541b55ea
*commonh px
�

%s
*constraints2�
�Time (s): cpu = 00:00:03 ; elapsed = 00:00:03 . Memory (MB): peak = 1680.332 ; gain = 0.000 ; free physical = 9856 ; free virtual = 144642default:defaulth px
c

Phase %s%s
101*constraints2
3 2default:default2
Sweep2default:defaultZ18-101h px
T
 Eliminated %s unconnected nets.
12*opt2
20322default:defaultZ31-12h px
T
!Eliminated %s unconnected cells.
11*opt2
2692default:defaultZ31-11h px
5
#Phase 3 Sweep | Checksum: a45f7165
*commonh px
�

%s
*constraints2�
�Time (s): cpu = 00:00:04 ; elapsed = 00:00:04 . Memory (MB): peak = 1680.332 ; gain = 0.000 ; free physical = 9857 ; free virtual = 144642default:defaulth px
^

Starting %s Task
103*constraints2&
Connectivity Check2default:defaultZ18-103h px
�

%s
*constraints2�
�Time (s): cpu = 00:00:00.05 ; elapsed = 00:00:00.04 . Memory (MB): peak = 1680.332 ; gain = 0.000 ; free physical = 9857 ; free virtual = 144642default:defaulth px
F
4Ending Logic Optimization Task | Checksum: a45f7165
*commonh px
�

%s
*constraints2�
�Time (s): cpu = 00:00:04 ; elapsed = 00:00:04 . Memory (MB): peak = 1680.332 ; gain = 0.000 ; free physical = 9857 ; free virtual = 144642default:defaulth px
>
,Implement Debug Cores | Checksum: 15cf9da31
*commonh px
;
)Logic Optimization | Checksum: 15cf9da31
*commonh px
^

Starting %s Task
103*constraints2&
Power Optimization2default:defaultZ18-103h px
p
7Will skip clock gating for clocks with period < %s ns.
114*pwropt2
3.122default:defaultZ34-132h px
:
Applying IDT optimizations ...
9*pwroptZ34-9h px
<
Applying ODC optimizations ...
10*pwroptZ34-10h px


*pwropth px
b

Starting %s Task
103*constraints2*
PowerOpt Patch Enables2default:defaultZ18-103h px
�
�WRITE_MODE attribute of %s BRAM(s) out of a total of %s has been updated to save power.
    Run report_power_opt to get a complete listing of the BRAMs updated.
129*pwropt2
02default:default2
12default:defaultZ34-162h px
a
+Structural ODC has moved %s WE to EN ports
155*pwropt2
02default:defaultZ34-201h px
�
CNumber of BRAM Ports augmented: %s newly gated: %s Total Ports: %s
65*pwropt2
02default:default2
12default:default2
22default:defaultZ34-65h px
e
1Number of Flops added for Enable Generation: %s

23*pwropt2
22default:defaultZ34-23h px
J
8Ending PowerOpt Patch Enables Task | Checksum: 7a883822
*commonh px
�

%s
*constraints2�
�Time (s): cpu = 00:00:00.02 ; elapsed = 00:00:00.01 . Memory (MB): peak = 1686.332 ; gain = 0.000 ; free physical = 9849 ; free virtual = 144572default:defaulth px
F
4Ending Power Optimization Task | Checksum: 7a883822
*commonh px
�

%s
*constraints2�
�Time (s): cpu = 00:00:01 ; elapsed = 00:00:01 . Memory (MB): peak = 1686.332 ; gain = 6.000 ; free physical = 9849 ; free virtual = 144572default:defaulth px
W
Releasing license: %s
83*common2"
Implementation2default:defaultZ17-83h px
�
G%s Infos, %s Warnings, %s Critical Warnings and %s Errors encountered.
28*	vivadotcl2
262default:default2
02default:default2
02default:default2
02default:defaultZ4-41h px
Y
%s completed successfully
29*	vivadotcl2

opt_design2default:defaultZ4-42h px
�
r%sTime (s): cpu = %s ; elapsed = %s . Memory (MB): peak = %s ; gain = %s ; free physical = %s ; free virtual = %s
480*common2 
opt_design: 2default:default2
00:00:192default:default2
00:00:172default:default2
1686.3322default:default2
481.5202default:default2
98492default:default2
144572default:defaultZ17-722h px
A
Writing placer database...
1603*designutilsZ20-1893h px
:
Writing XDEF routing.
211*designutilsZ20-211h px
G
#Writing XDEF routing logical nets.
209*designutilsZ20-209h px
G
#Writing XDEF routing special nets.
210*designutilsZ20-210h px
�
r%sTime (s): cpu = %s ; elapsed = %s . Memory (MB): peak = %s ; gain = %s ; free physical = %s ; free virtual = %s
480*common2)
Write XDEF Complete: 2default:default2
00:00:00.112default:default2
00:00:00.042default:default2
1718.3482default:default2
0.0002default:default2
98482default:default2
144582default:defaultZ17-722h px
M
Running DRC with %s threads
24*drc2
42default:defaultZ23-27h px
�
#The results of DRC are in file %s.
168*coretcl2�
^/home/INTRA/eydire/workspace/project/week2vivado/week2.runs/impl_1/week1_wrapper_drc_opted.rpt^/home/INTRA/eydire/workspace/project/week2vivado/week2.runs/impl_1/week1_wrapper_drc_opted.rpt2default:default8Z2-168h px


End Record