#include <avr/io.h>

void delai(unsigned long int delai) {
	volatile long int i=0;
	for(i=0;i<delai;i+=1);
} 

int main(void) {
	
	USICR = 0b00010100;
	USISR = 0b00000100;
	USIDR = 0xA5;
	
	delai(3);

	
		
	while (1) {	
		unsigned char tmp = USIDR;
		USIDR = tmp + 1;
		delai(1);

	}
	return 0;
}

