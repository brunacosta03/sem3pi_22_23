#include <stdio.h>
#include <stdint.h>

extern uint64_t state;
extern uint64_t inc;


void generate_seed(){
	uint64_t buffer [2];
    FILE *f;
    int result;
    int i;
    
	f = fopen("/dev/urandom", "r"); 
    
	if (f == NULL) {
        printf("Error: open() failed to open /dev/random for reading\n"); 
    }
    
	result = fread(buffer , sizeof(uint64_t), 2,f);
    
	if (result < 1) {
        printf("error , failed to read and words\n"); 
    }
    
	printf("Read %d words from /dev/urandom\n", result); 
    
	for(i=0; i < result; i++) 
        printf("%08lx\n", buffer[i]); 
        
    printf("\n");    
        
    //Intialize state and inc by /dev/random
	state = buffer[0];
	inc = buffer[1];
	
	fclose(f);
}
