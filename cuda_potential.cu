#include <stdio.h>
#include <math.h>
#include "stdlib.h"

//Device Code....

__global__ void force(double *deviceq,double *devicex,double *devicey,double *devicez,double *deviceFx,double *deviceFy,double *deviceFz,double *deviceU,int N) 
{	
	 double foxij,foyij,fozij,xij,yij,zij,rij;
	 int i = blockDim.x * blockIdx.x + threadIdx.x;
	 int j;
	 if(i < N-1)
         {       //Anurag Dogra
                 for(j=i;j<N;j++)
                     {
                          if(i!=j)
                          {
                              xij = devicex[i] - devicex[j];
                              yij = devicey[i] - devicey[j];
                              zij = devicez[i] - devicez[j];

                              //Distance calculation
                              rij = sqrt((xij*xij)+(yij*yij)+(zij*zij));

                              foxij = foxij + ((deviceq[i]*deviceq[j]*xij)/(rij*rij*rij));
                              foyij = foyij + ((deviceq[i]*deviceq[j]*yij)/(rij*rij*rij));
                              fozij = fozij + ((deviceq[i]*deviceq[j]*zij)/(rij*rij*rij));

                              deviceFx[i] = deviceFx[i] + foxij;
                              deviceFy[i] = deviceFy[i] + foyij;
                              deviceFz[i] = deviceFz[i] + fozij;
                              deviceU[i] = deviceU[i] + 2*(deviceq[j]/rij);

                           }
                    }
         }
                       
} 
int main(int argc, char** argv)
{	
	int device = 0;
	if(argc > 1)
	{	
		device = atoi(argv[1]);
	}
	
	cudaSetDevice(device);
	int N;
	double *Fx,*Fy,*Fz,*U;
	int i,j,k;
	double *q,*x,*y,*z;
	//device Arrays......
	double *deviceq,*devicex,*devicey,*devicez,*deviceU;
	double *deviceFx,*deviceFy,*deviceFz;
	// INPUT WORK ..
	N = 1000;
	double Ec = 0;
	cudaMallocManaged(&deviceq, N * sizeof(double));
	cudaMallocManaged(&devicex, N * sizeof(double));
	cudaMallocManaged(&devicey, N * sizeof(double));
	cudaMallocManaged(&devicez, N * sizeof(double));
	cudaMallocManaged(&deviceU, N * sizeof(double));
        cudaMallocManaged(&deviceFx, N * sizeof(double));
	cudaMallocManaged(&deviceFy, N * sizeof(double));
	cudaMallocManaged(&deviceFz, N * sizeof(double));

	q=(double*)malloc((N)*sizeof(double));
	x=(double*)malloc((N)*sizeof(double));
	y=(double*)malloc((N)*sizeof(double));
	z=(double*)malloc((N)*sizeof(double));
	//ifstream infile;//INFILE IS THE OBJECT OF ifstream class
	FILE *infileq = fopen("q.dat","r");//OPEN A FILE IN READ MODE ONLY 
        //ERROR CHECK IF THERE IS PROBLEM IN OPENING A FILE 
	for(i=0;i<N;i++)
	{	
		fscanf(infileq,"%lf",&q[i]);
	}
        FILE *infilex = fopen("x.dat","r");//OPEN A FILE IN READ MODE ONLY 
        //ERROR CHECK IF THERE IS PROBLEM IN OPENING A FILE 
        for(i=0;i<N;i++)
        {       
               fscanf(infilex,"%lf",&x[i]);
        }
        //
        FILE *infiley = fopen("y.dat","r");//OPEN A FILE IN READ MODE ONLY 
        //ERROR CHECK IF THERE IS PROBLEM IN OPENING A FILE 
        for(i=0;i<N;i++)
        {        
               fscanf(infiley,"%lf",&y[i]);
        }
        //
        FILE *infilez = fopen("z.dat","r");//OPEN A FILE IN READ MODE ONLY 
        //ERROR CHECK IF THERE IS PROBLEM IN OPENING A FILE 
        for(i=0;i<N;i++)
        {        
            fscanf(infilez,"%lf",&z[i]);
        }
        //_________________________________________________________________________
	/*for(i=0;i<N;i++{	
		printf("%lf\t %lf\t %lf\t %lf\n",q[i],x[i],y[i],z[i]);
	       //cout<<q[i]<<" "<<x[i]<<" "<<y[i]<<" "<<z[i]<<endl;
	}*/

	//Copying from host array to device array
	cudaMemcpy(deviceq, q, N * sizeof(double), cudaMemcpyHostToDevice);
	cudaMemcpy(devicex, x, N * sizeof(double), cudaMemcpyHostToDevice);
	cudaMemcpy(devicey, y, N * sizeof(double), cudaMemcpyHostToDevice);
	cudaMemcpy(devicez, z, N * sizeof(double), cudaMemcpyHostToDevice);        
	
	Fx=(double*)malloc((N)*sizeof(double));
	Fy=(double*)malloc((N)*sizeof(double));
	Fz=(double*)malloc((N)*sizeof(double));
	U=(double*)malloc((N)*sizeof(double));

	for(i = 0;i < N;i++)
	{	
		deviceFx[i]=0;
		deviceFy[i]=0;
		deviceFz[i]=0;
		deviceU[i]=0;
		Fx[i]=0;
		Fy[i]=0;
		Fz[i]=0;
		U[i]=0;
	}
	dim3 blockDim(N/4);
	dim3 gridDim(4);
	// Calling the kernal
        force<<<gridDim,blockDim>>>(deviceq,devicex,devicey,devicez,deviceFx,deviceFy,deviceFz,deviceU,N);
	
	cudaMemcpy(Fx, deviceFx, N * sizeof(double), cudaMemcpyDeviceToHost);
	cudaMemcpy(Fy, deviceFy, N * sizeof(double), cudaMemcpyDeviceToHost);
	cudaMemcpy(Fz, deviceFz, N * sizeof(double), cudaMemcpyDeviceToHost);
	cudaMemcpy(U,  deviceU, N * sizeof(double), cudaMemcpyDeviceToHost);

	for(i=0;i<N;i++)
	{	
		Ec = Ec + q[i]*U[i];
	}
	Ec = Ec/2;
	printf("%lf\n",Ec);
	
	return 0;

}
	
	 
