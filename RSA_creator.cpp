/*
author:nikelong
class: EE 73
*/
#include "bign.h"
#include<ctime>
#include<cstdlib>
#define maxn 1000
#define INF 0xfffffff
const int len=100;//�������� 
bign prime[len];//���е����� 
void init()//��ʼ�������ļ��ж�ȡ��Կ 
{
	freopen("prime.txt","r",stdin);
	//������Կ 
	for(int i=0;i<len;i++)
	{
		prime[i].Read();
	}	
}
bign x[maxn],y[maxn],q[maxn];
bign extend_gcd(bign gcd,bign m,bign n){
    x[1] = 1;
    y[1] = q[0];
    y[1].sign=!y[1].sign;
    x[2] = q[1];
    x[2].sign=!x[2].sign;
    y[2] = q[0]*q[1]+1;
    for(int i = 2; i < INF; i++){
        x[i+1] = x[i-1] - q[i]*x[i];
        y[i+1] = y[i-1] - q[i]*y[i];
		bign tmp=m*x[i+1] + n*y[i+1];
        if(gcd == tmp){
			y[i+1].Print();
			return y[i+1];
        }
    }
}
 
bign gcdinit(bign a,bign b){
	bign r,t;
	r=1;
    int i = 0;
    while(!(r==0)){
        r = a%b;
        t = a/b;
        q[i++] = t;
        a = b;
        b = r;
    }
    return a;
}

void RSA_creator()
{
	//ѡȡ������ͬ������p��q 
	srand(time(NULL));
	int id1=rand()%100;
	int id2=rand()%100;
	while(id1==id2)
	{
		id2=rand()%100;
	}
	bign p=prime[id1];
	bign q=prime[id2];
	bign n=p*q;
	bign phin=(p-1)*(q-1);
	int id3=rand()%100;
	while(id3==id1||id3==id2)
	{
		id3=rand()%100;
	}
	//ѡ��һ�����(n)������С�ڦ�(n)����������ȡһ����ͬ������ 
	bign e=prime[id3];	
	bign d;//de+t*��(n)=1
	
	bign gcd = gcdinit(phin,e);
	d=extend_gcd(gcd,phin,e);
	d=d%phin;
	if(d<0)
	{
		d=d+phin;	
	}
	
	// e:��Կ  d:��Կ   n:�㷨���� 
	freopen("RSA_public_key.txt","w",stdout);
	e.Print();
	freopen("RSA_private_key.txt","w",stdout);
	d.Print();
	freopen("RSA_key.txt","w",stdout);
	n.Print();
} 
int main()
{
	init();
	RSA_creator();

	
//	bign a,b;
//	a.Read();
//	b.Read();
////	bign d=exgcd(a,b,x,y);
//	bign gcd = gcdinit(a,b);
//	bign t=extend_gcd(gcd,a,b);
//	t.Print();
	return 0;
}
