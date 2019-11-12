/*
author:nikelong
class: EE 73
*/ 
#include<cstdio>
#include<iostream>
#include<cstring>
#include<cstdlib>
#include<algorithm>
#include<queue>
#include<cmath>
#define LL long long
const LL maxn=100+20;
const LL M=502630;
using namespace std;

struct Mat
{
	LL mat[maxn][maxn];
};
LL n;
Mat operator*(Mat a,Mat b)
{
	Mat c;
	memset(c.mat,0,sizeof(c.mat));
	for(LL k=1;k<=n;k++)
	{
		for(LL i=1;i<=n;i++)
		{
			for(LL j=1;j<=n;j++)
			{
				c.mat[i][j]+=(a.mat[i][k]%M)*(b.mat[k][j]%M);
				c.mat[i][j]%=M;
			}
		}
	}
	return c;
}
Mat operator ^(Mat a,LL k)//a^k
{
	Mat c;
	for(LL i=1;i<=n;i++)
	{
		for(LL j=1;j<=n;j++)
		{
			c.mat[i][j]=(i==j);
		}
	}
	for(;k;k>>=1)
	{
		if(k&1)c=c*a;
		a=a*a;
	}
	return c;
}
int main()
{
	scanf("%lld",&n);
	Mat f;
	for(LL i=1;i<=n;i++)
	{
		for(LL j=1;j<=n;j++)scanf("%lld",&f.mat[i][j]);
	}
	Mat g=f^1000000000;
	printf("%lld\n",g.mat[1][3]);
	return 0;
}
