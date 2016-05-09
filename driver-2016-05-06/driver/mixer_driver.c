/*
* Simple app to receive audio stream from the network and pass it to the AXI to audio device
* and copy another audio stream from one AXI peripheral to another one
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
 
#define SRC_L   *((unsigned *)(ptr_src + 0))
#define SRC_R   *((unsigned *)(ptr_src + 4))

#define DST0_ADR 0x43C10000
#define DST1_ADR 0x43C20000 
#define DST0_L   *((unsigned *)(ptr_dst0 + 0))
#define DST0_R   *((unsigned *)(ptr_dst0 + 4))
#define DST1_L   *((unsigned *)(ptr_dst1 + 0))
#define DST1_R   *((unsigned *)(ptr_dst1 + 4))

#define BROADCAST_ADR "10.255.255.255"
#define PORT 7891
#define BUFFER_SIZE 256

int pipe_fd[2];
  
void* receive_thread () {
	printf("receive thread started\n");

	/* Open the AXI to Audio device via /dev/mem mapping */
        int fd_dst0 = open ("/dev/mem", O_RDWR);
        if (fd_dst0 < 1) { perror("Error open /dev/mem/");} 
  
        unsigned pageSize = sysconf(_SC_PAGESIZE);
        void *ptr_dst0;
  	ptr_dst0 = mmap(NULL, pageSize, PROT_READ|PROT_WRITE, MAP_SHARED, fd_dst0, DST0_ADR);
		
	unsigned sample;	
	while(1) {	

		int ret_val = read(pipe_fd[0], &sample, 4);	// Read sample (4 byte) from fifo
		// Write data to AXI to audio device (mono)
		DST0_L = sample;
		DST0_R = sample;
	}   

        //unmap
        munmap(ptr_dst0, pageSize);
}

void* copy_thread () {
	printf("copy thread started\n");

	/* Open the devices */
        /* For Audio to AXI use the uio_prdv_genirq driver (load kernel module before) */
        int fd_src = open ("/dev/uio0", O_RDWR);	// open dev/uio0
        if (fd_src < 1) { perror("Error open /dev/uio0/");}

        /* For AXI to Audio use the /dev/mem interface */
        int fd_dst1 = open ("/dev/mem", O_RDWR);    //open /dev/mem file
        if (fd_dst1 < 1) { perror("Error open /dev/mem/");} 
  
	
	/* Perform the memory mappings */
        unsigned pageSize = sysconf(_SC_PAGESIZE);         //get architecture specific page size  
        void *ptr_src;
        ptr_src = mmap(NULL, pageSize, PROT_READ|PROT_WRITE, MAP_SHARED, fd_src, 0);  
        void *ptr_dst1;
  	ptr_dst1 = mmap(NULL, pageSize, PROT_READ|PROT_WRITE, MAP_SHARED, fd_dst1, DST1_ADR);
           
        int IRQEnable = 1; // Enable Interrupts
 	write(fd_src, &IRQEnable, sizeof(IRQEnable));
         
 
  	/* Copy data in infinity loop */ 
	while(1) {	
 		read(fd_src, &IRQEnable, sizeof(IRQEnable));
		DST1_L = SRC_L;		// COPY left channel
		DST1_R = SRC_R;		// COPY right channel
		int IRQEnable = 1; 	// Enable interrupt again
	 	write(fd_src, &IRQEnable, sizeof(IRQEnable));
	} 
    
        //unmap
        munmap(ptr_src, pageSize);
        munmap(ptr_dst1, pageSize);
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

	/* Create POSIX Threads */
	pthread_t r_thread;
    	int thread_ret = pthread_create( &r_thread, NULL, &receive_thread, NULL);
	if (thread_ret){ perror("Error - pthread_create() receive_thread"); return -1; } 	
	pthread_t c_thread;
    	thread_ret = pthread_create( &c_thread, NULL, &copy_thread, NULL);
	if (thread_ret){ perror("Error - pthread_create() copy_thread"); return -1; }	

	/* Run receive loop for ever */
	printf("Beginn receiving network data and writing to fifo\n");
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
	/* Wait for threads to end */
	pthread_join(r_thread, NULL); 
	//pthread_join(c_thread, NULL); 
        //close
        fclose(stdout);
    return 0;
}


