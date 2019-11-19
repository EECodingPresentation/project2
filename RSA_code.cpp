/*
8192bit,每3bit聚成一个2731位8进制数。
看成10进制数。
秘钥长度大概10位(2^32,2^32,2^64)
压4位处理后
length:
data: 683
publick_key:3
*/
#include "bign.h"
#include<ctime>
const int M=4;//分组加密长度 

bign bitToOct(char *databit,int len)//每3bit合一下 
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
	char s[2*M*16+20];//字符串长度 
	int cnt=0;
	for(int i=1;i<=2*M;i++)//取出每一个被压缩的4位 
	{	
		for(int j=0;j<4;j++)
		{
			int x=data.c[i]%10;//取出被压缩4位的第j位
			for(int k=0;k<4;k++)//对第j位进行化为2进制数 
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
void RSA_code(bign data,bign public_key,bign key)//输入为明文,公钥,模数n 
{
	freopen("ciphertext.txt","w",stdout);
	for(int i=1;i<=data.len;i+=M)
	{
		//切分一个长度为M的数 
		bign r;
		int j;
		for(j=1;j<=M&&i-1+j<=data.len;j++)//拷贝M长度的数 
		{
			r.c[j]=data.c[i+j-1];
		}
		r.len=j-1;

		bign ciphertext=quickpower(r,public_key,key);//加密之后的文段

		HexTobit(ciphertext);  
	}
}
void init()//初始化 
{
	//读取公钥和模数n 
	bign public_key,key;
	freopen("RSA_key.txt","r",stdin);
	key.Read();
	freopen("RSA_public_key.txt","r",stdin);
	public_key.Read();
	
	//读取明文数据:01bit序列 
	char databit[10000];
	freopen("data.txt","r",stdin);
	scanf("%s",databit);
	
	//补零
	int len=strlen(databit); 
	int maxl=ceil(1.0*len/12)*12;
	for(int i=len;i<maxl;i++)databit[i]='0';
	databit[maxl]='\0';
	
	bign data=bitToOct(databit,maxl); //bit转8进制数

	RSA_code(data,public_key,key);//得到密文
	
	
}
int main()
{
	init();
	
	

	return 0;
} 
