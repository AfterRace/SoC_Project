# SoC Project: Audio Mixer

This repository stores our solution of the audio mixer project, that was part of the IAY0550 System-on-Chip Design course at Tallinn University of Technology in spring 2016.

Authors: Grabmann Martin, Eyyup Direk, Mezzogori Massimo

## Table of Contents
 - [Introduction](#introduction)
 - [Getting Started](#getting-started)
 - [Documentation](#documentation)
	 - [Step 1: Audio Loop-Back Through Linux](#step-1-audio-loop-back-through-linux)
	 - [Step 2: Receive Audio Over Network in Linux and Play it Back](#step-2-receive-audio-over-network-in-linux-and-play-it-back)
	 - [Step 3: Mixing the Two Streams, Multi-Threading](#step-3-mixing-the-two-streams-multi-threading)
	 - [Step 4: Adding Filters and Volume Control](#step-4-adding-filters-and-volume-control)
 - [Conclusion](#conclusion)
 - [References](#references)

## Introduction
The purpose of this project is to build a audio mixer on the Zedboard running Linux. The Zedboard is built up on the Xilinx Zynq platform that combines an ARM CPU with a FPGA on one Chip. Therefore we had to develop a custom hardware design for the FPGA and write the software to control it from Linux. As shown in the following picture, one input stream is received from the network and one from the local line-in port. The signal path of each channel contains a volume control and a filter IP core. Their settings can be controlled from a linux command line interface to modifiy the contribution of each input to the mixed stream. The output stream is available at the headphone jack of the zedboard.
![alt tag](https://raw.githubusercontent.com/AfterRace/SoC_Project/master/pictures/introduction.png)

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
In previous labs , we have implemented something similar to this step but  we didnt use the linux driver in those implementation.
In this step We  wrote two IPs in VHDL : Audio To Axi and Axi To Audio components that we used in our design. Also, we implemented the Audio Copy Driver in such a way which will take the input from Audio to Axi component and will return output to Axi to Audio component.
The audio analog signal is taken by the board through the [Audio IP][1] given by the lecturer. This IP is an interface for connecting the ADAU1761 audio codecs.
Overall We connected this components with each other to be able to obtain a simple auido loop-back through linux.

#### Audio To Axi
We created this custom intellectual property our own selves.After creation process in vivado environment ,We created vhdl file for this specific IP then edited the code such a way which will take audio as an input then provide output to on AXI bus.Basically  by creating this Ip ,we intended to convert audio which comes from Audio IP into information on AXI bus.
#### Axi To Audio
Same as in Audio to Axi we created this custom ip our own selves.We created vhdl description and defined inputs and outputs of our entity which will be completely compatible with the Audio copy driver output.After audio driver copied data from input to output ,This Ip takes the process in Audio to Axi backward and information is converted to audio which we can listen by our headphones.
#### Audio Copy Driver
This Linux driver's task is just to copy data from the input to output. The first thing that we did it was to access the devices that we created before.
To do this we used '/dev/uio0' for the Audio to AXI device because it needs to handle interrupt, and we used '/dev/mem' for the AXI to Audio because in this case , interrupt is not required. After mapping the device, we repeated in a loop these instructions: we enabled the interrupt for the Audio To AXI, we waited the interrupt then  we copied the content of the Audio To Axi registers to the AXI to Audio registers. In this way we transferred  the audio from the line in to the headphone out ports of the ZedBoard.

### Step 2: Receive Audio Over Network in Linux and Play it Back
In this step of the project, we wrote a new audio driver which is capable of receiving audio packages from the local network and forward them to the AXI bus. 

The audio network stream is specified as followed:
* **Network protocol:** UDP
* **Sender address:** Broadcast (10.255.255.255)
* **Port:** 7891
* **Packet size:** 256 bytes
* **Size of one sample:** 4 bytes
* **Audio channels:** 1, Mono (copy one stream to both left and right channels)
* **Audio sample format:** PCM, 4 byte samples, can be directly written to the audio IP-s input

To simplify this task a [library file][3] with two helper functions was provided by the lectures. We configured the client zu receive the broadcasted UDP packages using the function _int udp_client_setup(char *broadcast_address, int broadcast_port)_ contained in the library _udpclient.h_ 

Due to the fact that the network stream is received in 256 byte packages and one audio sample is only 4 byte big, we had to buffer the received data. We followed the provided hints and used a FIFO that is accessed from different threads to solve this problem.
We created a FIFO with the unnamed pipes Linux implementation. Named pipes would have the advantage that they can be accessed from different processes, but thats not needed here, because the threads are sharing the same memory.
In the main loop we received the packets from the server using the function _int udp_client_recv(unsigned *buffer,int buffer_size )_  and wrote them in the FIFO. 

At the same time a POSIX thread. This accessed to the AXI to Audio devices using _/dev/mem_ and in a loop the thread copy one sample at time (4 byte) from the FIFO to the AXI to Audio registers. Since the audio is mono we copied the same sample in both channel.

#### Test
To test it, since it is not present a DHCP client in the ZedBoard, we need to configure the network properly, to simplify it in the laboratory we used the *change_ip_and_mac.sh* script, it is present in the same repository of the *updclient.h* library. Finally we can run the driver.

### Step 3: Mixing the Two Streams, Multi-Threading
In this step of the project , we added a new IP which has task mixing two different streams and transfer it to the Audio Ip out which is the final Ip before the audio released to headphone.
In previous steps ,we have already achieved to get streams over line in and network channels seperately.For the first step we had copy driver works with the thread , named copy thread and for the second step we have defined receive thread which is supposed to handle stream coming over the network.
Basically we merged our previous two drivers copy driver and receive driver and modified the code and created our audio mixer driver.
For the design part on vivado environment , we already have been supplied the Audio Mixer IP.Before adding Audio Mixer Ip into the design first we doubled up the Axi to Audio Ip so we could  manage to get both streams over audio driver.
After completing that part , we added the audio mixer driver into the design then connected the Axi to Audio Ips outputs as input to the audio mixer driver.The rest of the design has been kept same as the previous step and audio mixer output connected to the Audio Ip output.

### Step 4: Adding Filters and Volume Control
The final step of the project was to add a volume control and a filter bank in the signal path of both input channels. We reused the provided IP cores from the former [lab exercises 4][5]. On the software side we had to create a user interface that allows the user to control the settings of both IPs from the linux command line.

#### How to use it

First we need to connect an audio source to the line in, the Ethernet cable to the Ethernet port and the headphones to the headphones out.

Load the kernel module *uio_pdrv_genirq.ko*

`zynq> insmod uio_pdrv_genirq.ko`

Run the driver

```lang-none
zynq> ./final_mixer_driver

Welcome to the Audio MIXER driver
Initialization started...
Initialization finished...

Select the channel to change
0 : for network channel
1 : for line in channel 
> _  		
```

Now we can heard both sources in the headphone, if we want to listen only the line in source we need to disable, the network channel. We can do it in two ways: set 0 the volume of the channel or turn off the all the filters. 
For example we disable the volume of the network channel. First we have to select the channel 0

```lang-none
Select the channel to change
0 : for network channel
1 : for line in channel 
> 0

Select the setting to change:
V : for volume control
F : for filter control 
L : for list of current settings
> _ 		
```

We choose the `V` option and set `0` the volume value 

```lang-none
Select the setting to change:
V : for volume control
F : for filter control 
L : for list of current settings
> V

Enter the value for the volume [0 - 4096]> 0
```

Now we can hear only the line in channel. If we want to play with the sound we can enable or disable the low, band, high pass filters of the channel. If for example we want to listen only the low frequencies of the audio, we need to select the `1` channel and select the `F` setting

```lang-none
Select the channel to change
0 : for network channel
1 : for line in channel 
> 1

Select the setting to change:
V : for volume control
F : for filter control 
L : for list of current settings
> F

Enter the filter value [LBH]> _ 	
```

Now we have to insert a sequence of three 1 or 0. 1 is for enable the filter, 0 for disable it. The first digit is relative to the low pass filter, the second one is relative to the band pass filter, the third one is relative to the high pass filter. So if we want to enable only the low pass filter we need to pass the `100` to the prompt.

```lang-none
Enter the filter value [LBH]> 100 	
```

If we want to list the configuration of the channel `0` we need to use the `L` setting

```lang-none
Select the channel to change
0 : for network channel
1 : for line in channel 
> 0

Select the setting to change:
V : for volume control
F : for filter control 
L : for list of current settings
> L

List of setting of network channel:
Volume LEFT: 0
Volume RIGHT: 0
Low Pass Filter: ON
Band Pass Filter: ON
High Pass Filter: OFF"

Select the channel to change
0 : for network channel
1 : for line in channel 
> 0
```

#### How to enable the Debug mode 


## Conclusion

## References

[1]: https://github.com/ems-kl/zedboard_audio "Audio IP"
[2]: https://github.com/karljans/SoC_Design "Mixer IP and UDP Library"
[3]: http://man7.org/linux/man-pages/man2/pipe.2.html "Unnamed Pipes"
[4]: http://man7.org/linux/man-pages/man7/pthreads.7.html "POSIX Threads"
[5]: https://github.com/tsotnep/ip_repo_vivado "Filter IP and Volume Control IP"


