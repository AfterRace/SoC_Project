# SoC Project: Audio Mixer

This repository stores our solution of the audio mixer project, that was part of the IAY0550 System-on-Chip Design course at Tallinn University of Technology in spring 2016.

Authors: Grabmann Martin, Eyyup Direk, Mezzogori Massimo

## Table of Contents

 - Introduction
 - Getting Started
 - Documentation
	 - Step 1: Audio Loop-Back Through Linux
	 - Step 2: Receive Audio Over Network in Linux and Play it Back
	 - Step 3: Mixing the Two Streams, Multi-Threading
	 - Step 4: Adding Filters and Volume Control
 - Conclusion
 - References

## Introduction
The purpose of this project is to build a audio mixer on the Zedboard running Linux. The Zedboard is built up on the Xilinx Zynq platform that combines an ARM CPU with a FPGA on one Chip. Therefore we had to develop a custom hardware design for the FPGA and write the software to control it from Linux. 


## Getting Started

### Hardware project
We used Xilinx Vivado 2015.1 for the hardware design. 
 - vivado/
	 - project/         
		 - Vivado project containing the block design
	 - ip_repo/        
		 - Used IP Cores
 - sd-image/
	 - Linux system
	 - Bootloader including the bitstream for the FPGA 
	 
Copy all files of the sd-image/ folder to the SD card.
	
### Linux driver

 - bin/
	 - Contains the binaries
	 - final_mixer_driver 
		 - Userspace driver
	 - uio_pdrv_genirq.ko
		 - Kernel module for Userspace I/O
 - drivers/
	 - Contains the sources

Copy all files of the bin/ folder to the SD card. To start the driver on the Zedboard type:

    mount /dev/mmcblk0p1 /mnt
    cd /mnt
    insmod uio_pdrv_genirq.ko
    ./final_mixer_driver


## Documentation
### Step 1: Audio Loop-Back Through Linux

In this step We  wrote two IPs in VHDL : Audio To Axi and Axi To Audio components that we used in our design. Also, we wrote the Audio Copy Driver.
The audio analog signal is taken by the board through the [Audio IP][1] given by the lecturer. This IP is an interface for connecting the ADAU1761 audio codecs

#### Audio To Axi
By creating this Ip we intended to convert  audio into information on AXI bus.
#### Axi To Audio
After audio driver copied data from input to data ,This Ip takes the process in Audio to Axi backward and information is converted to audio which we can listen by our headphones.
#### Audio Copy Driver
This Linux driver's task is just to copy data from the input to output. The first thing that we did it was access to the devices that we created before.
To do this we used '/dev/uio0' for the Audio to AXI device because it need to handle interrupt, and we used '/dev/mem' for the AXI to Audio because in this case we did not need to use interrupt. After mapping the device, we repeated in a loop these instructions: we enabled the interrupt for the Audio To AXI, we waited the interrupt and we copied the content of the Audio To Axi registers to the AXI to Audio registers. In this way we transferred  the audio from the line in to the headphone out ports of the ZedBoard.

### Step 2: Receive Audio Over Network in Linux and Play it Back
In this step of the project ,we wrote  a new audio driver which will have capable of getting audio over network.When we are creating this driver and component design , because of audio broadcast is using UDP protocol we created our driver accordingly.For networking
to work properly there was a script supplied by lab assistants.
The script help change the MAC and IP address.

### Step 3: Mixing the Two Streams, Multi-Threading

### Step 4: Adding Filters and Volume Control

## Conclusion

## References

[1]: https://github.com/ems-kl/zedboard_audio "Audio IP"


