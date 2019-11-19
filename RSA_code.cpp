/*
8192bit,ÿ3bit�۳�һ��2731λ8��������
����10��������
��Կ���ȴ��10λ(2^32,2^32,2^64)
ѹ4λ�����
length:
data: 683
publick_key:3
*/
#include "bign.h"
#include<ctime>
const int M=4;//������ܳ��� 

bign bitToOct(char *databit,int len)//ÿ3bit��һ�� 
{
	bign r;
	char *s=new char[len];
	int cnt=0;
	for(int i=0;i<len;i+=3)
	{
		if(i+2<len)s[cnt]='0'+(databit[i]-'0')*4+(databit[i+1]-'0')*2+(databit[i+2]-'0');
		else if(i+1<len)s[cnt]='0'+(databit[i]-'0')*4+(databit[i+1]-'0')*2;
		else s[cnt]='0'+(databit[i]-'0')*4;
		cnt++;
	}
	s[cnt]='\0';
	r.writein(s);
	delete s;
	return r;
}
void HexTobit(bign data)
{
	char s[2*M*16+20];//�ַ������� 
	int cnt=0;
	for(int i=1;i<=2*M;i++)//ȡ��ÿһ����ѹ����4λ 
	{	
		for(int j=0;j<4;j++)
		{
			int x=data.c[i]%10;//ȡ����ѹ��4λ�ĵ�jλ
			for(int k=0;k<4;k++)//�Ե�jλ���л�Ϊ2������ 
			{
				s[cnt++]=x%2+'0';
				x/=2;
			} 
			data.c[i]/=10;
		}
		
	}
	s[cnt]='\0';
	printf("%s",s);
}
void RSA_code(bign data,bign public_key,bign key)//����Ϊ����,��Կ,ģ��n 
{
	freopen("ciphertext.txt","w",stdout);
	for(int i=1;i<=data.len;i+=M)
	{
		//�з�һ������ΪM���� 
		bign r;
		int j;
		for(j=1;j<=M&&i-1+j<=data.len;j++)//����M���ȵ��� 
		{
			r.c[j]=data.c[i+j-1];
		}
		r.len=j-1;

		bign ciphertext=quickpower(r,public_key,key);//����֮����Ķ�

		HexTobit(ciphertext);  
	}
}
void init()//��ʼ�� 
{
	//��ȡ��Կ��ģ��n 
	bign public_key,key;
	freopen("RSA_key.txt","r",stdin);
	key.Read();
	freopen("RSA_public_key.txt","r",stdin);
	public_key.Read();
	
	//��ȡ��������:01bit���� 
	char databit[10000];
	freopen("data.txt","r",stdin);
	scanf("%s",databit);
	
	//����
	int len=strlen(databit); 
	int maxl=ceil(1.0*len/12)*12;
	for(int i=len;i<maxl;i++)databit[i]='0';
	databit[maxl]='\0';
	
	bign data=bitToOct(databit,maxl); //bitת8������

	RSA_code(data,public_key,key);//�õ�����
	
	
}
int main()
{
	init();
	
	

	return 0;
} 
