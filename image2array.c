#include <unistd.h>
#include <fcntl.h>
#include <stdio.h>
#include <string.h>
#include <opencv2/imgproc/imgproc_c.h>
#include <opencv2/highgui/highgui_c.h>

// compile against opencv
// gcc image2array.c `pkg-config --libs --cflags opencv`

char string[40]; 
int fd;
int main(int argc, char **argv){
    fd = open("fooimage",O_WRONLY | O_CREAT, S_IRWXU);
    
	CvMat *matA = cvLoadImageM(argv[1],0);
    if(!matA) return -1;
    else printf("%s is %dx%d\n",argv[1],matA->cols,matA->rows);

	int loopY, loopX;
        for( loopY = 50;loopY <100;++loopY)
        {
                for( loopX = 100;loopX < 150;++loopX)
                {
                        matA->data.ptr[matA->step*loopY+loopX] = 255;
                }
        }

	int i, j, k;
    for (j=0; j<matA->rows; j++){
		sprintf(string,"data[%d:%d] = 8'h0d;\n", k*8+7, k*8);
		write(fd, string, strlen(string));
		k++;
		sprintf(string,"data[%d:%d] = 8'h0dh;\n", k*8+7, k*8);
		write(fd, string, strlen(string));
		k++;
		for (i=0; i<matA->cols; i++){	
			sprintf(string,"data[%d:%d] = 8'h%x;\n", k*8+7, k*8, matA->data.ptr[j*matA->cols+i]);
			write(fd, string, strlen(string));
			k++;
			}	
		}
    i++;
    //sprintf(string,"data[%d:%d] = 8'0dh;\n", i*8+7, i*8);
	//write(fd, string, strlen(string));
    }
