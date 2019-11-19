/*
author:nikelong
class: EE 73 
*/ 
#include<cstdio>
#include<iostream>
#include<cmath>
#include<cstring>
#include<cstdlib>
#include<ctime>
#include<algorithm>
#define base 10000                 //压4位
#define maxlen 2201
#define get(x) (x-'0')       //ASCII转Num 
using namespace std;
char s[maxlen*4];
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
		zero();
	}
	
	void Read()
	{
//		char s[maxlen*4];
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

		sprintf(s,"%d",a);
		writein(s);
		return *this;
	}
	bool operator >(const bign &b)
	{
		if(sign^b.sign)return !sign;
		if(len!=b.len)return len>b.len;
		for(int i=len;i>=1;i--)
		{
			if(c[i]!=b.c[i])return c[i]>b.c[i];
		}
		return false;
	} 
	bool operator >(const int &b)
	{
		bign r;
		r=b;
		return *this>r;
	}
	bool operator >=(const bign &b)
	{
		if(sign^b.sign)return !sign;
		if(len!=b.len)return len>b.len;
		for(int i=len;i>=1;i--)
		{
			if(c[i]!=b.c[i])return c[i]>b.c[i];
		}
		return true;
	} 
	bool operator <(const bign &b)
	{
		if(sign^b.sign)return sign;
		if(len!=b.len)return len<b.len;
		for(int i=len;i>=1;i--)
		{
			if(c[i]!=b.c[i])return c[i]<b.c[i];
		}
		return false;
	}
	bool operator <(const int &b)
	{
		bign r;
		r=b;
		return *this<r;
	}
	bool operator <=(const bign &b)
	{
		if(sign^b.sign)return sign;
		if(len!=b.len)return len<b.len;
		for(int i=len;i>=1;i--)
		{
			if(c[i]!=b.c[i])return c[i]<b.c[i];
		}
		return true;
	}
	bool operator ==(const bign &b)
	{
		if(len!=b.len||sign!=b.sign)return false;
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
	bign add(const bign &a,const bign &b)
	{
		bign r;r.len=max(a.len,b.len)+1;
		for(int i=1;i<=r.len;i++)
		{
			r.c[i]+=a.c[i]+b.c[i];
			r.c[i+1]+=r.c[i]/base;
			r.c[i]%=base;
		}
		r.zero();
		return r;
	}
	bign minus(const bign &aa,const bign &b)
	{
		bign a,c;
		a=aa;
		c=b;
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
	bign operator +(const bign &bb)
	{
		bign b=bb;
		bign a=*this;
		if(!a.sign&&!b.sign)
		{
			return add(a,b);
		}
		else if(a.sign&&b.sign)
		{
			bign r=add(a,b);
			r.sign=1;
			return r;
		} 
		else if(a.sign&&!b.sign)
		{
			bign r=minus(a,b);
			r.sign=!r.sign;
			return r;
		}
		else if(!a.sign&&b.sign)//a+ b-
		{
			b.sign=0;
			bign r=minus(a,b);
			return r;
		}
	}
	bign operator +(const int a)
	{
		bign b;b=a;
		return *this+b;
	}
	bign operator -(const bign &bb)
	{
		bign b=bb;
		bign a=*this;
		if(!a.sign&&!b.sign)
		{
			return minus(a,b);
		}
		else if(a.sign&&b.sign)
		{
			a.sign=0;
			b.sign=0;
			bign r=minus(a,b);
			r.sign=1;
			return r;
		} 
		else if(!a.sign&&b.sign)//a+ b-
		{
			b.sign=0;
			bign r=add(a,b);
			return r;
		}
		else if(a.sign&&!b.sign)//a- b+
		{
			a.sign=0;
			bign r=add(a,b);
			r.sign=1;
			return r;
		}
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
		r.sign=sign^b.sign;
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
	bign operator /(const bign &bb)
	{
		bign ans,rest;
		bign a,b;
		a=*this;
		b=bb;
		ans.len=a.len;
		ans.sign=a.sign^b.sign;
		b.sign=0;
		a.sign=0;
		for(int i=a.len;i>=1;i--)
		{
			rest=rest*base;
			rest.c[1]=a.c[i];
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
	bign operator %(const bign &bb)
	{
		bign rest;
		bign a,b;
		a=*this;
		b=bb;
		
		b.sign=0;
		a.sign=0;
		for(int i=a.len;i>=1;i--)
		{
			rest=rest*base;
			rest.c[1]=a.c[i];
			while(rest>=b)
			{
				rest=rest-b;
			}
		}
		rest.sign=a.sign^b.sign;
		rest.zero();
		return rest;
	}
	bign operator %(const int &a)
	{
		bign b;b=a;
		return *this%b;
	}
	bign quickchu2()
	{
		bign r=*this;
		for(int i=len;i>=1;i--)
		{
			if(i>1)r.c[i-1]+=r.c[i]%2*base;
			r.c[i]=r.c[i]/2;
		}
		r.zero();
		return r;
	}
};

bign quickpower(bign a,bign b,bign m) // x^y mod m
{
	bign ans,d;
	ans=1;
	d=2;
	while(b.len>1||b.c[1]>0)
	{
		if(b.c[1]&1)
		{
			ans=ans*a%m;
		}
		a=a*a%m;	
		b=b.quickchu2();
	} 
	return ans;
}


