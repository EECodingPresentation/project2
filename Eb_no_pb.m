%绘制Eb/n0与误码率关系曲线
clear;
clc;
rng default;
N=5;
sigma=0.01:0.01:1;
pb=zeros(N,length(sigma));
pb0=zeros(N,length(sigma));
pb_soft=zeros(N,length(sigma));
Eb_n0=zeros(N,length(sigma));
Eb_n0_=zeros(N,length(sigma));
datalen=1024*8;
eff=2;%卷积编码效率，取值{2,3},2代表1/2编码，3代表1/3编码
tail=1;%卷积编码发端是否收尾，取值{0,1}，0代表不收尾，1代表收尾
bitmode=2;%电平映射模式，取值{1,2,3}，1代表1bit/符号，2代表2bit/符号，3代表3bit/符号
for j=1:N
data1=sourcedata(datalen); 
convres=model_conv(data1,eff,tail);
mapres=model_map(convres,bitmode);
mapres0=model_map(data1,bitmode);
ifconv=1;
for i=1:length(sigma)
    s=sqrt(sigma(i));
    [channelres,Eb_n0(j,i)]=channel3(mapres,s);
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
    
       [channelres0,Eb_n0_(j,i)]=channel3(mapres0,s);
    hard_bitcode0 = hard_judge(channelres0, 2, 1);
    a=hard_bitcode0~=data1;
    rate0=sum(a)/datalen+exp(-100);
    pb0(j,i)=log(rate0);
end
end
pbm=mean(pb);
pbm_soft=mean(pb_soft);
pbm0=mean(pb0);
% pb=reshape(pb,1,N*length(sigma));
% pb_soft=reshape(pb_soft,1,N*length(sigma));
% pb0=reshape(pb0,1,N*length(sigma));
% Eb_n0=reshape(Eb_n0,1,N*length(sigma));
% Eb_n0_=reshape(Eb_n0_,1,N*length(sigma));
%SN=10*log(1./(sigma));
Eb_n0m=mean(Eb_n0);
Eb_n0m_=mean(Eb_n0_);
figure;

plot(10*log10(Eb_n0m+exp(-100)),pbm);
hold on;
plot(10*log10(Eb_n0m+exp(-100)),pbm_soft);
plot(10*log10(Eb_n0m_+exp(-100)),pbm0);
title("Eb/n0与误比特率Pb曲线");
xlabel("Eb/n0（dB)");
ylabel("ln(pb)");