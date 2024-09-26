#include<stdio.h>


int main()
{
     int a, i;
     int count=0;
     scanf("%d", &a);
     for (i=0; i<a; i++){
         if(i==3) count*=3;
         else if(i%4==0) count+=4;
         else if (i%5==0) count-=8;
         else count++;
     }
     printf("%d\n", count);
}