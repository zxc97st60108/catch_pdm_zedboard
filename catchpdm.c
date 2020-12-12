#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <fcntl.h>
#include <unistd.h>
#include <sys/mman.h>
#include <assert.h>

#define ZYNQ_BASE 0x80000000	 //base address for 64 sequence of integer
#define CTRL_OFFSET 0x00180004	 //for ctrl signal c
#define STATUS_OFFSET 0x00180008 //for status signal

#define DEPTH 49152
#define optPath "/mnt/pdm.txt"
// #include <sys/mman.h>

int main()
{
	int i, j;
	// int A[DEPTH];
	uint32_t result[DEPTH];
	// char *s_result;
	// uint8_t s_result2;

	volatile int fd = open("/dev/mem", O_RDWR); //volatile是一個變數聲明限定詞,可能會在任何時刻被意外的更新
	volatile int map_len = 0x00180104;
	volatile unsigned int *io = (volatile unsigned int *)mmap(NULL, map_len, PROT_READ | PROT_WRITE, MAP_SHARED, fd, ZYNQ_BASE);

	/*
	NULL :指向欲映射的核心起始位址,NULL代表讓系統自動選定位址
	map_len :代表映射的大小。將文件的多大長度映射到記憶體
	參數prot :映射區域的保護方式。可以為以下幾種方式的組合：
		PROT_EXEC 映射區域可被執行
		PROT_READ 映射區域可被讀取
		PROT_WRITE 映射區域可被寫入
		PROT_NONE 映射區域不能存取
	參數flags :影響映射區域的各種特性。在調用mmap()時必須要指定MAP_SHARED 或MAP_PRIVATE。
		MAP_SHARED 允許其他映射該文件的行程共享，對映射區域的寫入數據會複製回文件。
		MAP_PRIVATE 不允許其他映射該文件的行程共享，對映射區域的寫入操作會產生一個映射的複製(copy-on-write)，對此區域所做的修改不會寫回原文件。
	fd :要映射到核心中的文件
	ZYNQ_BASE :從文件映射開始處的偏移量
	*/

	if (io == MAP_FAILED)
	{
		perror("Mapping memory for absolute memory access failed.\n");
		exit(1);
	}
	printf("Zynq_BASE mapping successful :\n0x%x to %p, size = %d\n", ZYNQ_BASE, io, map_len);

	//assign input values to accelerator
	*(io + (CTRL_OFFSET >> 2)) = 0x2;
	*(io + (CTRL_OFFSET >> 2)) = 0x0;

	printf("start run\n");

	*(io + (CTRL_OFFSET >> 2)) = 0x1;
	printf("give 1\n");
	// printf("addr : %p \n", (io + (CTRL_OFFSET >> 2)));
	// printf("value : 0x%d \n", *(io + (CTRL_OFFSET >> 2)));
	*(io + (CTRL_OFFSET >> 2)) = 0x0;

	printf("give 0\n");
	// printf("addr2 : %p \n", (io + (CTRL_OFFSET >> 2)));
	// printf("value2 : 0x%d \n", *(io + (CTRL_OFFSET >> 2)));

	printf("polling busy\n");

	while (*(io + (STATUS_OFFSET >> 2)) != (volatile unsigned int)0)
	{
		printf("0x%x_ ", *(io + (STATUS_OFFSET >> 2)));
	}
	printf("operation finish\n");

	// FILE *fp = fopen(optPath, "w");
	// assert(fp != NULL);
	printf("start transfer\n");
	for (i = 0; i < DEPTH; i++)
	{
		result[i] = *(io + i);
		// s_result2 = *(io + i);
		// itoa(*(io + i), s_result, 2);
		// printf("accelerator result = %d , addr = %p \n ", *(io + i), (io + i));
		// printf("accelerator result = %x  \n ", *(io + i));
		// printf("%d \n ", s_result2);
		// fwrite((void *)(io + i), sizeof(unsigned int), 1, fp);
		// while (res)
		// {
		// 	if (res & 1)
		// 		printf("1");
		// 	else
		// 		printf("0");

		// 	res >>= 1;
		// }
		// printf("\n");
	}

	printf("end transfer\n");
	// x & 0x1 = bit[0]
	// x >>= 1
	printf("write file start\n");
	FILE *fp = fopen(optPath, "wb");
	assert(fp != NULL);
	int bit[32];
	for (int i = 0; i < DEPTH; i++)
	{
		// for (int j = 0; j < 32; j++)
		// {
		// 	bit[j] = result[i] & 0x1;
		// 	result[i] >>= 1; // 除2
		// }
		for (int k = 31; k >= 0; k--)
		{
			// bit[k] = ;

			if ((result[i] >> k) & 1)
				fprintf(fp, "%d\n", 1);
			else
				fprintf(fp, "%d\n", 0);
		}
		// for i = 31 to 0. if ((data>>i) &1) print 1 else print 0
	}
	// while (result[i] != 0)
	// {
	// 	if (result[i] % 2)
	// 		printf("1");
	// 	else
	// 		printf("0");
	// }

	// for (int i = 0; i < DEPTH; i++)
	// {
	// 	fprintf(fp, "%08x\n", result[i]);
	// }

	fclose(fp);

	printf("write file end \n");

	munmap((void *)io, map_len); //釋放指標io指向的記憶體空間，並設釋放的記憶體大小
	close(fd);

	return 0;
}
