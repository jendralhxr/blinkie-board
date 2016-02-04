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
			sprintf(string,"data[%d:%d] = 8'h0c;\n", k*8+7, k*8);
			write(fd, string, strlen(string));
			k++;
			sprintf(string,"data[%d:%d] = 8'h0c;\n", k*8+7, k*8);
			write(fd, string, strlen(string));
			k++;
			}
		else{
			sprintf(string,"data[%d:%d] = 8'h0d;\n", k*8+7, k*8);
			write(fd, string, strlen(string));
			k++;
			sprintf(string,"data[%d:%d] = 8'h0dh;\n", k*8+7, k*8);
			write(fd, string, strlen(string));
			k++;
			}
		for (i=0; i<matA->cols; i++){	
			temp= matA->data.ptr[j*matA->cols+i];
			if ((temp!=0xc) && (temp!=0xd)) sprintf(string,"data[%d:%d] = 8'h%x;\n", k*8+7, k*8, temp);
			else sprintf(string,"data[%d:%d] = 8'h0e;\n", k*8+7, k*8);
			write(fd, string, strlen(string));
			k++;
			}	
		}
    i++;
    }
