//      port.c
//      
//      Copyright 2014 Michel Doussot <michel@mustafar>
//      
//      This program is free software; you can redistribute it and/or modify
//      it under the terms of the GNU General Public License as published by
//      the Free Software Foundation; either version 2 of the License, or
//      (at your option) any later version.
//      
//      This program is distributed in the hope that it will be useful,
//      but WITHOUT ANY WARRANTY; without even the implied warranty of
//      MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//      GNU General Public License for more details.
//      
//      You should have received a copy of the GNU General Public License
//      along with this program; if not, write to the Free Software
//      Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
//      MA 02110-1301, USA.

#include <avr/io.h>



void delai(unsigned long int delai) {
	volatile long int i=0;
	for(i=0;i<delai;i+=1);
}

int main(void) {
	TCCR1B = 0x40;
	TCCR1B = 0x22;
	OCR1A = 0x80;
	 
	TCCR1A = 0x42; //0100 0010
	int temp;
	int i = 0;
	while (1) {	
		temp = TCCR1A;
		delai(3);
		i++;
		if (i>2)
		{
			i=0;
			TCCR1B = 0x40;
			TCCR1B = 0x22;

		}
	}
	return 0;
}

