//#include <cstring>
//#include <iostream>
#include <stdio.h>
#include <math.h>
#include "stdlib.h"
/*#include <sstream-h>
#include <fstream.h>

#include <ctime.h>
#include <cstdlib.h>
#include <iomanip.h>*/

//using namespace std;
//DEFINING CLASS  
int main()
{	
	int N;
	double *Fx,*Fy,*Fz,*U;
	int i,j,k;
	double *q,*x,*y,*z;
// INPUT WORK ..
	double xij,yij,zij,rij;
	double foxij= 0,foyij= 0,fozij = 0;
	N = 1000;
	double Ec = 0;
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
	/*while (i<N && fscanf(infile," %1f %1f %1f %1f",&q[i],&x[i]==2,&y[i]==3,&z[i]==4))
	{
	  i++;
	}*/
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
	/*for(i=0;i<N;i++)
	{	
		printf("%lf\t %lf\t %lf\t %lf\n",q[i],x[i],y[i],z[i]);
	       //cout<<q[i]<<" "<<x[i]<<" "<<y[i]<<" "<<z[i]<<endl;
	}*/
	Fx=(double*)malloc((N)*sizeof(double));
	Fy=(double*)malloc((N)*sizeof(double));
	Fz=(double*)malloc((N)*sizeof(double));
	U=(double*)malloc((N)*sizeof(double));
	for(i = 0;i < N;i++)
	{	
		Fx[i]=0;
		Fy[i]=0;
		Fz[i]=0;
		U[i]=0;
	}
	for(i = 0;i < N-1;i++)
			{	//Anurag Dogra
				for(j=i;j<N;j++)
				{	 	
					if(i!=j)   
					{	
						xij = x[i] - x[j];
						yij = y[i] - y[j];
						zij = z[i] - z[j];
						
						//Distance calculation
						rij = sqrt((xij*xij)+(yij*yij)+(zij*zij));

						foxij = foxij + ((q[i]*q[j]*xij)/(rij*rij*rij));
						foyij = foyij + ((q[i]*q[j]*yij)/(rij*rij*rij));
						fozij = fozij + ((q[i]*q[j]*zij)/(rij*rij*rij));
						
						Fx[i] = Fx[i] + foxij;
						Fy[i] = Fy[i] + foyij;
						Fz[i] = Fz[i] + fozij;
						
						/*Fx[j] = Fx[j] - foxij;
						Fy[j] = Fy[j] - foyij;
						Fz[j] = Fz[j] - fozij;*/
						
						U[i] = U[i] + 2*(q[j]/rij);
	
					}
				}
			}	
	
	for(i=0;i<N;i++)
	{	
		Ec = Ec + q[i]*U[i];
	}
	Ec = Ec/2;
	printf("%lf\n",Ec);
	
	return 0;

}
	
	 
