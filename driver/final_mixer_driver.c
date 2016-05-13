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
#include <string.h>

#include "lib/udpclient.h"
#include "final_mixer_driver.h"

#define BROADCAST_ADR "10.255.255.255"
#define PORT 7891
#define BUFFER_SIZE 256

int pipe_fd[2];

int check_filter_error(char *filter_setting){
	int i;
	//printf("Debug string passed: %s\n",filter_setting);
	if (strlen(filter_setting) != 3){
		printf("The string has to be long 3 char\n");
		return 1;
	}
	for (i=0; i<3; i++){
		if ( filter_setting[i] != '0' && filter_setting[i] != '1' ){
			printf("The string has to contain only 0 or 1\n");
			return 1;
		}
	}
	return 0;
} 
  
void* fifo_read_thread () {
	printf("fifo read thread started\n");

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

void* fifo_write_thread () {
	printf("fifo write thread started\n");

	/* Sets up UDP broadcast client. */   
	int udp = udp_client_setup(BROADCAST_ADR, PORT);
    	if (udp) { perror("Error setup udp client"); } 

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
	printf("Welcome to the Audio MIXER driver.\n");
	printf("Initialization started...\n");

        /* For Volume and Filter control use the /dev/mem interface */
        int fd = open ("/dev/mem", O_RDWR);    //open /dev/mem file
        if (fd < 1) { perror("Error open /dev/mem/");} 

	/* Perform the memory mappings */
        unsigned pageSize = sysconf(_SC_PAGESIZE);         //get architecture specific page size  
        void *ptr_filter0;
  	ptr_filter0 = mmap(NULL, pageSize, PROT_READ|PROT_WRITE, MAP_SHARED, fd, FILTER0_ADR);
        void *ptr_filter1;
  	ptr_filter1 = mmap(NULL, pageSize, PROT_READ|PROT_WRITE, MAP_SHARED, fd, FILTER1_ADR);
        void *ptr_volume0;
  	ptr_volume0 = mmap(NULL, pageSize, PROT_READ|PROT_WRITE, MAP_SHARED, fd, VOLUME0_ADR);
        void *ptr_volume1;
  	ptr_volume1 = mmap(NULL, pageSize, PROT_READ|PROT_WRITE, MAP_SHARED, fd, VOLUME1_ADR);


	/* Filer coefficients */
	unsigned LP_Coef_b0 = 0x00002CB6;
	unsigned LP_Coef_b1 = 0x0000596C;
	unsigned LP_Coef_b2 = 0x00002CB6;
	unsigned LP_Coef_a1 = 0x8097A63A;
	unsigned LP_Coef_a2 = 0x3F690C9D;

	unsigned BP_Coef_b0 = 0x074D9236;
	unsigned BP_Coef_b1 = 0x00000000;
	unsigned BP_Coef_b2 = 0xF8B26DCA;
	unsigned BP_Coef_a1 = 0x9464B81B;
	unsigned BP_Coef_a2 = 0x3164DB93;

	unsigned HP_Coef_b0 = 0x12BEC333;
	unsigned HP_Coef_b1 = 0xDA82799A;
	unsigned HP_Coef_b2 = 0x12BEC333;
	unsigned HP_Coef_a1 = 0x00000000;
	unsigned HP_Coef_a2 = 0x0AFB0CCC;

        /* Write FILTER0 coefficients */
        FILTER0_REG_0 = LP_Coef_b0;
        FILTER0_REG_1 = LP_Coef_b1;   
        FILTER0_REG_2 = LP_Coef_b2;
        FILTER0_REG_3 = LP_Coef_a1;
        FILTER0_REG_4 = LP_Coef_a2;    

        FILTER0_REG_5 = BP_Coef_b0;
        FILTER0_REG_6 = BP_Coef_b1;   
        FILTER0_REG_7 = BP_Coef_b2;
        FILTER0_REG_8 = BP_Coef_a1;
        FILTER0_REG_9 = BP_Coef_a2; 

        FILTER0_REG_10 = HP_Coef_b0;
        FILTER0_REG_11 = HP_Coef_b1;   
        FILTER0_REG_12 = HP_Coef_b2;
        FILTER0_REG_13 = HP_Coef_a1;
        FILTER0_REG_14 = HP_Coef_a2; 

	/* Reset FILTER0 */
	FILTER0_REG_15 = 1;
	FILTER0_REG_15 = 0;

	/* Enter sample mode */
	FILTER0_REG_16 = 1;

        /* Write FILTER1 coefficients */
        FILTER1_REG_0 = LP_Coef_b0;
        FILTER1_REG_1 = LP_Coef_b1;   
        FILTER1_REG_2 = LP_Coef_b2;
        FILTER1_REG_3 = LP_Coef_a1;
        FILTER1_REG_4 = LP_Coef_a2; 

        FILTER1_REG_5 = BP_Coef_b0;
        FILTER1_REG_6 = BP_Coef_b1;   
        FILTER1_REG_7 = BP_Coef_b2;
        FILTER1_REG_8 = BP_Coef_a1;
        FILTER1_REG_9 = BP_Coef_a2; 

        FILTER1_REG_10 = HP_Coef_b0;
        FILTER1_REG_11 = HP_Coef_b1;   
        FILTER1_REG_12 = HP_Coef_b2;
        FILTER1_REG_13 = HP_Coef_a1;
        FILTER1_REG_14 = HP_Coef_a2; 

	/* Reset FILTER1 */
	FILTER1_REG_15 = 1;
	FILTER1_REG_15 = 0;

	/* Enter sample mode */
	FILTER1_REG_16 = 1;

	/* Setting Volume */
	VOLUME0_REG_0 = 256;
	VOLUME0_REG_1 = 256;
	VOLUME1_REG_0 = 256;
	VOLUME1_REG_1 = 256;

	/* Create a FIFO for communication */
	int ret_val = pipe(pipe_fd);
	if (ret_val < 0) { perror("Error opening pipe"); return -1; } 	

	/* Create POSIX Threads */
	pthread_t r_thread;
    	int thread_ret = pthread_create( &r_thread, NULL, &fifo_read_thread, NULL);
	if (thread_ret){ perror("Error - pthread_create() fifo_read_thread"); return -1; } 
	pthread_t w_thread;
    	thread_ret = pthread_create( &w_thread, NULL, &fifo_write_thread, NULL);
	if (thread_ret){ perror("Error - pthread_create() fifo_write_thread"); return -1; } 	
	pthread_t c_thread;
    	thread_ret = pthread_create( &c_thread, NULL, &copy_thread, NULL);
	if (thread_ret){ perror("Error - pthread_create() copy_thread"); return -1; }	

	printf("Initialization finished...\n");

	/* Run receive loop for ever */
	while (1){	
		printf("Select the channel to change:\n");
		printf("0 : for network channel\n");
		printf("1 : for line in channel\n"); 
		char channel = getchar();
		getchar();
		if (channel != '0' && channel != '1') {
			printf("Unknown channel\n");
		}			
		printf("Select the setting to change:\n");
		printf("V : for volume control\n");
		printf("F : for FILTER0 control\n"); 
		printf("L : for list of settings\n");
		int setting = getchar();
		getchar();
		if (setting=='V') {
			int volume;
			printf("Enter the value for the volume [0 - 4096]> ");
			scanf("%d",&volume);
			getchar();
			if ( volume >= 0 && volume <= 4096){
			
				if (channel == '0'){
					VOLUME0_REG_0 = volume;
					VOLUME0_REG_1 = volume;
				}
				else {
					VOLUME1_REG_0 = volume;
					VOLUME1_REG_1 = volume;
				}
			} else
				printf("Volume out of range!\n");			
		}
		else if (setting=='F') {
			char filter_setting[1024];
			printf("Enter the filter value [LBH]> ");
			scanf("%s",&filter_setting);
			getchar();
			if (check_filter_error(filter_setting) == 0){
				if (channel == '0'){
						FILTER0_REG_17 = !(filter_setting[2] - '0'); //Highpass
						FILTER0_REG_18 = !(filter_setting[1] - '0'); //Bandpass
						FILTER0_REG_19 = !(filter_setting[0] - '0'); //Lowpass
					}
					else {
						FILTER1_REG_17 = !(filter_setting[2] - '0');
						FILTER1_REG_18 = !(filter_setting[1] - '0');
						FILTER1_REG_19 = !(filter_setting[0] - '0');
					}
			} else
				printf("Error in filter setting\n");
			
		}
		else if (setting == 'L'){
			if (channel == '0'){
				printf("List of setting of network channel:\n");
				printf("Volume LEFT: %d\n",VOLUME0_REG_0);
				printf("Volume RIGHT: %d\n",VOLUME0_REG_1);
				printf("Low Pass Filter: ");
				if(FILTER0_REG_19 == 0)
					printf("ON\n");
				else
					printf("OFF\n");
				printf("Band Pass Filter: ");
				if(FILTER0_REG_18 == 0)
					printf("ON\n");
				else
					printf("OFF\n");
				printf("High Pass Filter: ");
				if(FILTER0_REG_17 == 0)
					printf("ON\n");
				else
					printf("OFF\n");
			}
			else {
				printf("List of setting of line in channel:\n");
				printf("Volume LEFT: %d\n",VOLUME1_REG_0);
				printf("Volume RIGHT: %d\n",VOLUME1_REG_1);
				printf("Low Pass Filter: ");
				if(FILTER1_REG_19 == 0)
					printf("ON\n");
				else
					printf("OFF\n");
				printf("Band Pass Filter: ");
				if(FILTER1_REG_18 == 0)
					printf("ON\n");
				else
					printf("OFF\n");
				printf("High Pass Filter: ");
				if(FILTER1_REG_17 == 0)
					printf("ON\n");
				else
					printf("OFF\n");	
			}

		}
		else {
			printf("Unknown command\n");
		}
	
	} 
	/* Wait for threads to end */
	pthread_join(r_thread, NULL); 
	pthread_join(w_thread, NULL); 
	pthread_join(c_thread, NULL); 
	/* Close */
        fclose(stdout);
    return 0;
}


