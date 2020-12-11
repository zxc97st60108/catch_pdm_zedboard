/*
 * C Program to Convert Hexadecimal to Binary
 */
#include <stdio.h>
#include <stdint.h>
#define MAX 1000
#define intPath "./pdm.txt"
#define optPath "./pdm_opt.txt"
#define DEPTH 46874
 
int main()
{
    char binarynum[MAX], hexa[MAX];
    long int i = 0;
	uint32_t i32temp_t;

	char result[32];
    printf("Enter the value for hexadecimal ");
    // scanf("%s", hexa);
    FILE *fp = fopen(intPath, "rb");
    assert(fp != NULL);
	 for (i = 0; i < DEPTH; i++)
    {
        fread(&i32temp_t, sizeof(char), 1, fp);
        // first normalization
        result[i] = i32temp_t;
    }
    printf("\n Equivalent binary value: ");
	FILE *fp = fopen(optPath, "wb");
	assert(fp != NULL);
    while (result[i])
    {
        switch (result[i])
        {
        case '0':
            fprintf(fp,"0\n0\n0\n0\n"); break;
        case '1':
            fprintf(fp,"0\n0\n0\n1\n"); break;
        case '2':
            fprintf(fp,"0\n0\n1\n0\n"); break;
        case '3':
            fprintf(fp,"0\n0\n1\n1\n"); break;
        case '4':
            fprintf(fp,"0\n1\n0\n0\n"); break;
        case '5':
            fprintf(fp,"0\n1\n0\n1\n"); break;
        case '6':
            fprintf(fp,"0\n1\n1\n0\n"); break;
        case '7':
            fprintf(fp,"0\n1\n1\n1\n"); break;
        case '8':
            fprintf(fp,"0\n1\n0\n0\n"); break;
        case '9':
            fprintf(fp,"1\n0\n0\n1\n"); break;
        case 'A':
            fprintf(fp,"1\n0\n1\n0\n"); break;
        case 'B':
            fprintf(fp,"1\n0\n1\n1\n"); break;
        case 'C':
            fprintf(fp,"1\n1\n0\n0\n"); break;
        case 'D':
            fprintf(fp,"1\n1\n0\n1\n"); break;
        case 'E':
            fprintf(fp,"1\n1\n1\n0\n"); break;
        case 'F':
            fprintf(fp,"1\n1\n1\n1\n"); break;
        case 'a':
            fprintf(fp,"1\n0\n1\n0\n"); break;
        case 'b':
            fprintf(fp,"1\n0\n1\n1\n"); break;
        case 'c':
            fprintf(fp,"1\n1\n0\n0\n"); break;
        case 'd':
            fprintf(fp,"1\n1\n0\n1\n"); break;
        case 'e':
            fprintf(fp,"1\n1\n1\n0\n"); break;
        case 'f':
            fprintf(fp,"1\n1\n1\n1\n"); break;
        default:
            fprintf("\n Invalid hexa digit %c ", hexa[i]);
            return 0;
        }
        i++;
    }
    return 0;
}