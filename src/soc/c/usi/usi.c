#include <avr/io.h>

void delai(unsigned long int delai) {
	volatile long int i=0;
	for(i=0;i<delai;i+=1);
} 

int main(void) {
	
	USICR = 0b00010100;
	USISR = 0b00000100;
	unsigned char val = 0xA5;
	delai(1);
		
	while (1) {	
		
		USIDR = val;
		val++;
		delai(1);

	}
	return 0;
}

