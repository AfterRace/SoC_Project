/*
* Simple app to receive audio stream from the network and pass it to the AXI to audio device
* Set the path for the compiler: export PATH=$PATH:/cad/x_15/SDK/2015.1/gnu/arm/lin/bin
* To compile for arm: make ARCH=arm CROSS_COMPILE=arm-xilinx-linux-gnueabi-
* For communicating with the Board: picocom -b 115200 /dev/ttyACM0
* Author: Massimo, Eyyupt, Martin
*/
  
//C
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/mman.h>
#include <fcntl.h>
#include <stdint.h>
#include <pthread.h>

#include "lib/udpclient.h"
  
#define DST_L   *((unsigned *)(ptr_dst + 0))
#define DST_R   *((unsigned *)(ptr_dst + 4))

#define BROADCAST_ADR "10.255.255.255"
#define PORT 7891
#define BUFFER_SIZE 256

int pipe_fd[2];
  
void* receive_thread () {
	printf("thread start\n");

	/* Open the AXI to Audio device via /dev/mem mapping */
        int fd_dst = open ("/dev/mem", O_RDWR);
        if (fd_dst < 1) { perror("Error open /dev/mem/");} 
  
        unsigned pageSize = sysconf(_SC_PAGESIZE);
        void *ptr_dst;
  	ptr_dst = mmap(NULL, pageSize, PROT_READ|PROT_WRITE, MAP_SHARED, fd_dst, 0x43C10000);
		
	unsigned *sample;	
	while(1) {	

		int ret_val = read(pipe_fd[0], sample, 4);	// Read sample (4 byte) from fifo
		// Write data to AXI to audio device (mono)
		DST_L = *sample;
		DST_R = *sample;
	}   

        //unmap
        munmap(ptr_dst, pageSize);
}


int main(int argc, char *argv[])
{	
	printf("main start\n");
 	
	/* Sets up UDP broadcast client. */   
	int udp = udp_client_setup(BROADCAST_ADR, PORT);
    	if (udp) { perror("Error setup udp client"); return -1; } 
	
	/* Create a FIFO for communication */
	int ret_val = pipe(pipe_fd);
	if (ret_val < 0) { perror("Error opening pipe"); return -1; } 	

	/* Create POSIX Thread */
	pthread_t thread;
    	int thread_ret = pthread_create( &thread, NULL, &receive_thread, NULL);
	if (thread_ret){ perror("Error - pthread_create()"); return -1; }	

	/* Run receive loop for ever */
	printf("Beginn receiving and writing to fifo\n");
	unsigned buffer[BUFFER_SIZE/4];
	while (1){		
		int recv_ret = udp_client_recv(buffer, BUFFER_SIZE );
		if (recv_ret) { 
			printf("Error receiving udp data\n");
		}
		else {
			write(pipe_fd[1], (char *) buffer, BUFFER_SIZE);
		}
	}

	pthread_join(thread, NULL); /* wait for thread to end */
        //close
        fclose(stdout);
    return 0;
}


