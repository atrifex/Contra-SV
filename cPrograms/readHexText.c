#include<stdio.h>
#include<unistd.h>

int main()
{
	FILE* f = fopen("exampleHex.txt", "r");

	int c;
			
	while(fscanf(f, "%x", &c) != EOF)
	{
		printf("Value = %x\n",c);
	}

	fclose(f);

	return 0;
}
