/*
author:nikelong
class: EE 73 
*/ 
#include<cstdio>
#include<iostream>
#include<cmath>
#include<cstring>
#include<cstdlib>
#include<algorithm>
#define base 10000                 //压4位
#define maxlen 101
#define get(x) (x-'0')       //ASCII转Num 
using namespace std;

struct bign
{
	int c[maxlen],len,sign;
	bign()
	{
		memset(c,0,sizeof(c));
		len=1;
		sign=0;
	}
	void zero()//去前缀0 
	{
		while(!c[len]&&len-1)len--;
	}
	void writein(char *s)
	{
		int ll=strlen(s),k=1,lim=0;//记录正负号 
		if(s[0]=='-'){
			sign=1;
			lim=1;
		} 
		for(int i=ll-1;i>=lim;i--)
		{
			c[len]+=get(s[i])*k;k*=10;
			if(k==base)
			{
				k=1;
				len++;
			}
		}
	}
	
	void Read()
	{
		char s[maxlen*base];
		scanf("%s",s);
		writein(s);
	}
    void Print()
	{
		if(sign)printf("-");
		printf("%d",c[len]);
		for(int i=len-1;i>=1;i--)printf("%04d",c[i]);
		printf("\n");
	} 
	bign operator = (const int &a)
	{
		char s[maxlen*base];
		sprintf(s,"%d",a);
		writein(s);
		return *this;
	}
	bool operator >(const bign &b)
	{
		if(len!=b.len)return len>b.len;
		for(int i=len;i>=1;i--)
		{
			if(c[i]!=b.c[i])return c[i]>b.c[i];
		}
		return false;
	} 
	bool operator >=(const bign &b)
	{
		if(len!=b.len)return len>b.len;
		for(int i=len;i>=1;i--)
		{
			if(c[i]!=b.c[i])return c[i]>b.c[i];
		}
		return true;
	} 
	bool operator <(const bign &b)
	{
		if(len!=b.len)return len<b.len;
		for(int i=len;i>=1;i--)
		{
			if(c[i]!=b.c[i])return c[i]<b.c[i];
		}
		return false;
	}
	bool operator <=(const bign &b)
	{
		if(len!=b.len)return len<b.len;
		for(int i=len;i>=1;i--)
		{
			if(c[i]!=b.c[i])return c[i]<b.c[i];
		}
		return true;
	}
	bool operator ==(const bign &b)
	{
		if(len!=b.len)return false;
		for(int i=len;i>=1;i--)
		{
			if(c[i]!=b.c[i])return false;
		}
		return true;
	}
	bool operator ==(const int &a)
	{
		bign b;
		b=a;
		return *this==b;
	}
	bign operator +(const bign &b)
	{
		bign r;r.len=max(len,b.len)+1;
		for(int i=1;i<=r.len;i++)
		{
			r.c[i]=c[i]+b.c[i];
			r.c[i+1]+=r.c[i]/base;
			r.c[i]%=base;
		}
		r.zero();
		return r;
	}
	bign operator +(const int a)
	{
		bign b;b=a;
		return *this+b;
	}
	bign operator -(const bign &b)
	{
		bign a,c;
		a=*this,c=b;
		if(a<c)
		{
			swap(a,c);
			a.sign=1;
		}
		for(int i=1;i<=len;i++)
		{
			a.c[i]-=c.c[i];
			if(a.c[i]<0)
			{
				a.c[i]+=base;
				a.c[i+1]--;
			}
		}
		a.zero();
		return a;
	}
	bign operator -(const int &a)
	{
		bign b;b=a;
		return *this-b;
	}
	bign operator *(const bign &b)
	{
		bign r;
		r.len=len+b.len+2;
		for(int i=1;i<=len;i++)
		{
			for(int j=1;j<=b.len;j++)
			{
			  r.c[i+j-1]+=c[i]*b.c[j];
			  r.c[i+j]+=r.c[i+j-1]/base;
			  r.c[i+j-1]%=base;
			}			
		}
		r.zero();
		return r;
	}
	bign operator *(const int &a)
	{
		bign b;
		b=a;
		return *this*b;
	} 
	bign operator /(const bign &b)
	{
		bign ans,rest;
		ans.len=len;
		for(int i=len;i>=1;i--)
		{
			rest=rest*base;
			rest.c[1]=c[i];
			while(rest>=b)
			{
				rest=rest-b;
				++ans.c[i];
			}
		}
		ans.zero();
		return ans;
	}
	bign operator /(const int &a)
	{
		bign b;b=a;
		return *this/b;
	}
	bign operator %(const bign &b)
	{
		return *this-*this/b*b;
	}
	bign operator %(const int &a)
	{
		bign b;b=a;
		return *this%b;
	}
};

int main()
{
	freopen("bign.in","r",stdin);
	freopen("bign.out","w",stdout); 
	bign a,b;
	a.Read();
	b.Read();
	bign ans;
	ans=a*b;
	ans.Print();
	return 0;
}
