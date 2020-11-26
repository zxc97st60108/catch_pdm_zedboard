#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <fcntl.h>
#include <unistd.h>
#include <sys/mman.h>

#define ZYNQ_BASE		    0x80000000  //base address for 64 sequence of integer
#define CTRL_OFFSET 	    0x0016E3A0  //for ctrl signal c
#define STATUS_OFFSET       0x0016E3A4  //for status signal

#define DEPTH 5
 
#include <sys/mman.h>

int main()
{
    int i, j;
    // int A[DEPTH];
    // int result[DEPTH];

    volatile int fd = open( "/dev/mem", O_RDWR);//volatile是一個變數聲明限定詞,可能會在任何時刻被意外的更新
    volatile int map_len = 0x0016EA00;
    volatile unsigned int* io = (volatile unsigned int *)mmap(NULL, map_len, PROT_READ | PROT_WRITE, MAP_SHARED, fd, ZYNQ_BASE);
	
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

	if(io == MAP_FAILED)
    {
		perror("Mapping memory for absolute memory access failed.\n");
		exit(1);
	}
	printf("Zynq_BASE mapping successful :\n0x%x to 0x%p, size = %d\n", ZYNQ_BASE, (void *)(int)io, map_len);
	
	printf("start run\n");
	
	*(io+(CTRL_OFFSET>>2)) = 0x0;
    *(io+(CTRL_OFFSET>>2)) = 0x1;
	printf("give 1\n");
	printf("addr : 0x%p \n" , (void *)(int)(io+(CTRL_OFFSET>>2)));
	printf("value : 0x%d \n" , *(io+(CTRL_OFFSET>>2)));
	*(io+(CTRL_OFFSET>>2)) = 0x0;
	
	printf("give 0\n");
	printf("addr2 : 0x%p \n" , (void *)(int)(io+(CTRL_OFFSET>>2)));
	printf("value2 : 0x%d \n" , *(io+(CTRL_OFFSET>>2)));
	
    // printf("polling busy\n");
	 
    while ( *(io+(STATUS_OFFSET >> 2)) != (volatile unsigned int)0 )
    {
    	printf("busy : 0x%x\n",*(io+(STATUS_OFFSET >> 2)));
	}
	
    printf("operation finish\n");
	
	for(i = 1 ; i < DEPTH ; i++){
		// result[i-1] = *(io+i);
		printf("accelerator result = %d , addr = %p \n", *(io + i) , (io + i));
	}
	
	munmap((void *)io, map_len);//釋放指標io指向的記憶體空間，並設釋放的記憶體大小  
	close(fd);


	// for(i=0;i<DEPTH-1;i++){
	// 	printf("accelerator result[%02d] = %d\n", i,hw_result[i]);
	// }
    
    return 0;
}
