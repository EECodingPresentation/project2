#include "bign.h"
#include<ctime>
const int M=10;

bign bitToHex(char *databit,int len)//ÿ4bit��һ�� 
{
	bign r;
	char *s=new char[len];
	int cnt=0;
	for(int i=0;i<len;i+=4)
	{
		if(i+3<len)s[cnt]=databit[i]+(databit[i+1]-'0')*2+(databit[i+2]-'0')*4+(databit[i+3]-'0')*8;
		else if(i+2<len)s[cnt]=databit[i]+(databit[i+1]-'0')*2+(databit[i+2]-'0')*4;
		else if(i+1<len)s[cnt]=databit[i]+(databit[i+1]-'0')*2;
		else s[cnt]=databit[i];
		cnt++;
	}
	s[cnt]='\0';
	strrev(s);
	r.writein(s);
	delete s;
	return r;
}
char *OctTobit(bign data)
{
	char *s=new char[10000];
	int cnt=0;
	for(int i=1;i<=data.len;i++)//ȡ��ÿһ����ѹ����4λ 
	{	
		for(int j=0;j<4;j++)
		{
			int x=data.c[i]%10;//ȡ����ѹ��4λ�ĵ�jλ
			for(int k=0;k<3;k++)//�Ե�jλ���л�Ϊ2������ 
			{
				s[cnt++]=x%2+'0';
				x/=2;
			} 
			data.c[i]/=10;
		}
		
	}
	s[cnt]='\0';
	return s;
}
void RSA_decode(bign data,bign private_key,bign key)
{
	data.Print();
	printf("\n\n");
	int cnt=0;
	char ss[10000];
	for(int i=1;i<=data.len;i+=2*M)
	{
		//�з�һ������ΪM���� 
		bign r;
		int j;
		for(j=1;j<=2*M&&i+j-1<=data.len;j++)//����2M���ȵ��� 
		{
			r.c[j]=data.c[i+j-1];
		}
		r.len=j-1;
		bign plaintext=quickpower(r,private_key,key);//����֮����Ķ�
		char *s=OctTobit(plaintext); 
		for(int i=0;i<strlen(s);i++)
		{
			ss[cnt++]=s[i];
		}
		delete []s;
	}
	//�޳��߽�����

	ss[cnt]='\0';
	strrev(ss);
	freopen("plaintext.txt","w",stdout);
	printf("%s",ss);
}
void init()//��ʼ�� 
{
	//��ȡ˽Կ��ģ��n 
	bign private_key,key;
	freopen("RSA_key.txt","r",stdin);
	key.Read();
	freopen("RSA_private_key.txt","r",stdin);
	private_key.Read();
	
	//��ȡ��������:01bit���� 
	char databit[100000];
	freopen("ciphertext.txt","r",stdin);
	scanf("%s",databit);
	
	
	bign data=bitToHex(databit,strlen(databit)); //bitת16������()

	RSA_decode(data,private_key,key);//�õ�����
	
	
}
int main()
{
	init();
	
	return 0;
}
