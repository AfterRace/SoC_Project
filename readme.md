# SoC Project

Authors: Grabmann Martin, Eyyup Direk, Mezzogori Massimo

## Introduction

## Step 1: Audio Loop-Back Through Linux

In this step We  wrote two IPs in VHDL : Audio To Axi and Axi To Audio components that we used in our design. Also, we wrote the Audio Copy Driver.
The audio analog signal is taken by the board through the [Audio IP][1] given by the lecturer. This IP is an interface for connecting the ADAU1761 audio codecs

### Audio To Axi
By creating this Ip we intended to convert  audio into information on AXI bus.
### Axi To Audio
After audio driver copied data from input to data ,This Ip takes the process in Audio to Axi backward and information is converted to audio which we can listen by our headphones.
### Audio Copy Driver
This Linux driver's task is just to copy data from input to output.

## Step 2: Receive Audio Over Network in Linux and Play it Back
In this step of the project ,we wrote  a new audio driver which will have capable of getting audio over network.When we are creating this driver and component design , because of audio broadcast is using UDP protocol we created our driver accordingly.For networking
to work properly there was a script supplied by lab assistants.
The script help change the MAC and IP address.

## Step 3: Mixing the Two Streams, Multi-Threading

## Step 4: Resource Sharing, Adding Filters and Volume Control

## Conclusion

## References

[1]: https://github.com/ems-kl/zedboard_audio "Audio IP"
