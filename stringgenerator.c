#include <unistd.h>
#include <fcntl.h>
#include <stdio.h>
#include <string.h>

char string[40];
char source[200]; 

int fd;
int main(){
    fd = open("foo",O_WRONLY | O_CREAT, S_IRWXU);
    strcpy(source,"Lorem ipsum dolor sit amet, consectetur adipiscing elit. Cras a iaculis velit, eget dapibus nullam.\n");
    int i;
    for (i=0; i<strlen(source); i++){	
	sprintf(string,"data[%d:%d] = 8'h%x%xh;\n", i*8+7, i*8, (source[i]/0x10), (source[i]%0x10));
	write(fd, string, strlen(string));
    	}
    i++;
    sprintf(string,"data[%d:%d] = 8'0dh;\n", i*8+7, i*8);
	write(fd, string, strlen(string));
    printf("done");
    }
