#include <unistd.h>
#include <fcntl.h>
#include <stdio.h>
#include <string.h>
#include <opencv2/imgproc/imgproc_c.h>
#include <opencv2/highgui/highgui_c.h>

// compile against opencv
// gcc image2array.c `pkg-config --libs --cflags opencv`

char string[40]; 
unsigned char temp;
int fd;
int main(int argc, char **argv){
    fd = open("fooimage",O_WRONLY | O_CREAT, S_IRWXU);
    
	CvMat *matA = cvLoadImageM(argv[1],0);
    if(!matA) return -1;
    else printf("%s is %dx%d\n",argv[1],matA->cols,matA->rows);

	int i, j, k=0;
    for (j=0; j<matA->rows; j++){
		if ((j==0) & (i==0)){
			sprintf(string,"dataH[%d:%d] = 4'h0;", k*4+3, k*4);
			write(fd, string, strlen(string));
			sprintf(string," dataL[%d:%d] = 4'hc;\n", k*4+3, k*4);
			write(fd, string, strlen(string));
			k++;
			sprintf(string,"dataH[%d:%d] = 4'h0;", k*4+3, k*4);
			write(fd, string, strlen(string));
			sprintf(string," dataL[%d:%d] = 4'hc;\n", k*4+3, k*4);
			write(fd, string, strlen(string));
			k++;
			}
		else{
			sprintf(string,"dataH[%d:%d] = 4'h0;", k*4+3, k*4);
			write(fd, string, strlen(string));
			sprintf(string," dataL[%d:%d] = 4'hd;\n", k*4+3, k*4);
			write(fd, string, strlen(string));
			k++;
			sprintf(string,"dataH[%d:%d] = 4'h0;", k*4+3, k*4);
			write(fd, string, strlen(string));
			sprintf(string," dataL[%d:%d] = 4'hd;\n", k*4+3, k*4);
			write(fd, string, strlen(string));
			k++;
			}
		for (i=0; i<matA->cols; i++){	
			temp= matA->data.ptr[j*matA->cols+i];
			if ((temp!=0xc) && (temp!=0xd)){
				sprintf(string,"dataH[%d:%d] = 4'h%x;", k*4+3, k*4, ((temp&0xf0)>>4));
				write(fd, string, strlen(string));
				sprintf(string," dataL[%d:%d] = 4'h%x;\n", k*4+3, k*4, temp&0x0f);
				write(fd, string, strlen(string));
				}
			else{
				sprintf(string,"dataH[%d:%d] = 4'h0;\n", k*4+3, k*4);
				write(fd, string, strlen(string));
				sprintf(string,"dataL[%d:%d] = 4'he;\n", k*4+3, k*4);
				write(fd, string, strlen(string));
				}
			k++;
			}	
		}
    }
