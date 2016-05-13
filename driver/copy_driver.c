/*
* Simple app to read to read audio from AXI bus an write it back to the AXI to audio device
* To compile for arm: make ARCH=arm CROSS_COMPILE=arm-xilinx-linux-gnueabi-
* Author: Massimo, Eyyupt, Martin
*/
  
//C
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/mman.h>
#include <fcntl.h>
#include <stdint.h>
  
#define SRC_L   *((unsigned *)(ptr_src + 0))
#define SRC_R   *((unsigned *)(ptr_src + 4))

#define DST_L   *((unsigned *)(ptr_dst + 0))
#define DST_R   *((unsigned *)(ptr_dst + 4))
  
  
int main(int argc, char *argv[])
{  	
	/* Open the devices */
        /* For Audio to AXI use the uio_prdv_genirq driver (load kernel module before) */
        int fd_src = open ("/dev/uio0", O_RDWR);	// open dev/uio0
        if (fd_src < 1) { perror("Error open /dev/uio0/"); return -1; }

        /* For AXI to Audio use the /dev/mem interface */
        int fd_dst = open ("/dev/mem", O_RDWR);    //open /dev/mem file
        if (fd_dst < 1) { perror("Error open /dev/mem/"); return -1; } 
  
	
	/* Perform the memory mappings */
        unsigned pageSize = sysconf(_SC_PAGESIZE);         //get architecture specific page size  
        void *ptr_src;
        ptr_src = mmap(NULL, pageSize, PROT_READ|PROT_WRITE, MAP_SHARED, fd_src, 0);  
        void *ptr_dst;
  	ptr_dst = mmap(NULL, pageSize, PROT_READ|PROT_WRITE, MAP_SHARED, fd_dst, 0x43C20000);
           
        int IRQEnable = 1; // Enable Interrupts
 	write(fd_src, &IRQEnable, sizeof(IRQEnable));
         
 
  	/* Copy data in infinity loop */ 
	while(1) {	
 		read(fd_src, &IRQEnable, sizeof(IRQEnable));
		// COPY left channel
		DST_L = SRC_L;
		// COPY right channel
		DST_R = SRC_R;
		// Enable interrupt again
		int IRQEnable = 1; 
	 	write(fd_src, &IRQEnable, sizeof(IRQEnable));
	} 
    
        //unmap
        munmap(ptr_src, pageSize);
        munmap(ptr_dst, pageSize);
  
        //close
        fclose(stdout);

    return 0;
}
