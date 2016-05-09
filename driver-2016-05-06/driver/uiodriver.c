/*
* Simple app to read/write into custom IP in PL via /dev/uoi0 interface
* To compile for arm: make ARCH=arm CROSS_COMPILE=arm-xilinx-linux-gnueabi-
* Author: Tsotnep, Kjans
*/
  
//C
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/mman.h>
#include <fcntl.h>
#include <stdint.h>
  
#define SLV_REG_0   *((unsigned *)(ptr + 0))
#define SLV_REG_1   *((unsigned *)(ptr + 4))
#define SLV_REG_2   *((unsigned *)(ptr + 8))
#define SLV_REG_3   *((unsigned *)(ptr + 12))
  
  
int main(int argc, char *argv[])
{
        //take inputs from user
      //  unsigned multiplierInput1 = atoi(argv[1]);
      //  unsigned multiplierInput2 = atoi(argv[2]);
  	
	printf("OPEN Device\n");
        //open dev/uio0
        int fd = open ("/dev/uio0", O_RDWR);
        if (fd < 1) { perror(argv[0]); return -1; }
 
  
        //Redirect stdout/printf into /dev/kmsg file (so it will be printed using printk)
       // freopen ("/dev/kmsg","w",stdout);
  
        //get architecture specific page size
        unsigned pageSize = sysconf(_SC_PAGESIZE);
  
        /*************************************************************************************************
         * TASK 1: Map the physical address to virtual address.                                          *
         *************************************************************************************************
         * HINT 0: You can look at how you did this in the /dev/mem task.                                *
         * HINT 1: When mapping in UIO, there are some differences from doing it in /dev/mem.            *
         *         check the "Mapping usage in UIO" section in Lab 3 additional materials for details.   *
         *************************************************************************************************/
        printf("Map Memory\n"); 
	unsigned offset = pageSize * (1-1); //only one page
        void *ptr;
        ptr = mmap(NULL, pageSize, PROT_READ|PROT_WRITE, MAP_SHARED, fd, offset);  
  
         
        /************************************************************************************************
         * TASK 2: Enable interrupts                                                                    *
         ************************************************************************************************
         * HINT 0: You need to write the value of IRQEnable into a specific file.                       *
         * HINT 1: You can find more information from the "Userspace I/O (UIO)" section in the          *
         *         LAB 3 additional material                                                            *
         ************************************************************************************************/
         
        int IRQEnable = 1; 
 	write(fd, &IRQEnable, sizeof(IRQEnable));
         
 
  
        /************************************************************************************************
         * TASK 3: Wait for interrupts (block program execution until the interrupt is received         *
         ************************************************************************************************
         * HINT 0: You need to read a specific file                                                     *
         * HINT 1: You can find more information from the "Userspace I/O (UIO)" section in the          *
         *         LAB 3 additional material                                                            *
         * HINT 2: Use the IRQEnable variable for storing the output of the function                    *
         ************************************************************************************************/
 	printf("WAIT for Interrupt\n");
	while(1) {	
 		read(fd, &IRQEnable, sizeof(IRQEnable));
		printf("READ: left channel: %d \n",SLV_REG_0);
		printf("READ: right channel: %d \n",SLV_REG_1);
		int IRQEnable = 1; 
	 	write(fd, &IRQEnable, sizeof(IRQEnable));
	} 
  
        //if you direct stdio into correct file, this printf will be written into printk, and will get time-stamp on message
        printf("DEBUG_USERSPACE : IRQ\n");
  
        //when you read from file into this buffer, it will give you total number of interrupts, 
        printf("Interrupt count: = %d \n", IRQEnable);
  
        //Read and print result of IP calculation
        //unsigned ans = SLV_REG_3;
        //printf("READ: from offset of %d, a value of %d \n", 12, ans);
  
        //unmap
        munmap(ptr, pageSize);
  
        //close
        fclose(stdout);

    return 0;
}
