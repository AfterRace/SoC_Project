#include<udpclient.h>
#include<stdlib.h>
#include<stdio.h>

#define BRDCST_ADDR "10.255.255.255"
#define PORT 7891
#define BUFFER_SIZE 256

int main(void){
	if(!udp_client_setup(BRDCST_ADDR, PORT)){
		printf("Error!");
		exit(1);
	}
	
	int buffer[BUFFER_SIZE];
	while (1){
		udp_client_recv(&buffer, BUFFER_SIZE );
	}

	return 0;
}		
		
