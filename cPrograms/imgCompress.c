#include<stdio.h>
#include<stdlib.h>
#include<assert.h>
#include<math.h>

void readImage(char* fileIn, char* fileOut, int* mappArray);
void compress(int RGB, FILE* RGBComp, int* mappArray);

int main(int argc, char* argv[])
{
	assert(argc == 3);

	int mappArray[32] = {};

	readImage(argv[1], argv[2], mappArray);

	return 0;
}

void readImage(char* fileIn , char* fileOut, int* mappArray)
{
	FILE* RGBFull = fopen(fileName, "r");
	FILE* RGBComp = fopen(fileOut, "w");
	int c;

	while(fscanf(RGBFull, "%x", c) != EOF)
	{
		compress(c, RGBComp);
	}
}

void compress(int RGB, FILE* RGBComp, int* mappArray)
{
	int mappedTemp, distance, mappedVal;

	distance = 0xFFFF;
	int i = 0;

	while( i <  32)
	{
		if(math.abs(RGB - mappArray[i]) < distance)
		{
			distance = math.abs(RGB - mappArray[i]);
			mappedTemp = mappArray[i];
		}
		i++;
	}


	switch (mappedTemp)
	{
		case 0x000000: mappedVal = 0;
		case 0x :	mappedVal = 1;
		case 0x :	mappedVal = 2;
		case 0x :	mappedVal = 3;
		case 0x :	mappedVal = 4;
		case 0x :	mappedVal = 5;
		case 0x :	mappedVal = 6;
		case 0x :	mappedVal = 7;
		case 0x :	mappedVal = 8;
		case 0x :	mappedVal = 9;
		case 0x :	mappedVal = 10;
		case 0x :	mappedVal = 11;
		case 0x :	mappedVal = 12;
		case 0x :	mappedVal = 13;
		case 0x :	mappedVal = 14;
		case 0x :	mappedVal = 15;
		case 0x :	mappedVal = 16;
		case 0x :	mappedVal = 17;
		case 0x :	mappedVal = 18;
		case 0x :	mappedVal = 19;
		case 0x :	mappedVal = 20;
		case 0x :	mappedVal = 21;
		case 0x :	mappedVal = 22;
		case 0x :	mappedVal = 23;
		case 0x :	mappedVal = 24;
		case 0x :	mappedVal = 25;
		case 0x :	mappedVal = 26;
		case 0x :	mappedVal = 27;
		case 0x :	mappedVal = 28;
		case 0x :	mappedVal = 29;
		case 0x :	mappedVal = 30;
		case 0x :	mappedVal = 31;
		case 0x :	mappedVal = 32;
	}

		fprintf(RGBComp, "%s\n", mappedVal);
}
