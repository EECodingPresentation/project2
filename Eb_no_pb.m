%����Eb/n0�������ʹ�ϵ����
clear;
clc;
rng default;
N=5;
sigma=0.01:0.01:1;
pb=zeros(N,length(sigma));
pb0=zeros(N,length(sigma));
pb_soft=zeros(N,length(sigma));
datalen=1024*8;
eff=2;%�������Ч�ʣ�ȡֵ{2,3},2����1/2���룬3����1/3����
tail=1;%������뷢���Ƿ���β��ȡֵ{0,1}��0������β��1������β
bitmode=2;%��ƽӳ��ģʽ��ȡֵ{1,2,3}��1����1bit/���ţ�2����2bit/���ţ�3����3bit/����
for j=1:N
data1=sourcedata(datalen); 
convres=model_conv(data1,eff,tail);
mapres=model_map(convres,bitmode);
mapres0=model_map(data1,bitmode);
ifconv=1;
for i=1:length(sigma)
    s=sqrt(sigma(i));
    channelres=channel2(mapres,s);
    hard_bitcode = hard_judge(channelres, bitmode, eff);
    decode_bit = hard_viterbi(hard_bitcode, eff, tail, 0);
    bitProb = soft_judge(channelres, bitmode, eff);
    decode_bit_soft = soft_viterbi(bitProb, eff, tail, 0);
    Res = decode_bit(1:length([data1, zeros(1,3*(tail==1))])) ~= [data1, zeros(1,3*(tail==1))];
    rate=sum(abs(Res))/datalen+exp(-100);
    Res_soft = decode_bit_soft(1:length([data1, zeros(1,3*(tail==1))])) ~= [data1, zeros(1,3*(tail==1))];
    rate_soft=sum(abs(Res_soft))/datalen+exp(-100);
    pb(j,i)=log(rate);
    pb_soft(j,i)=log(rate_soft);
    
       channelres0=channel2(mapres0,s);
    hard_bitcode0 = hard_judge(channelres0, 2, 1);
    a=hard_bitcode0~=data1;
    rate0=sum(a)/datalen+exp(-100);
    pb0(j,i)=log(rate0);
end
end
pbm=mean(pb);
pbm_soft=mean(pb_soft);
pbm0=mean(pb0);
SN=10*log(1./(sigma));
figure;

plot(SN,pbm);
hold on;
plot(SN,pbm_soft);
plot(SN,pbm0);