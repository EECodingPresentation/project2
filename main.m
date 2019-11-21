%% 该文件用于级联所有模块
clear all;
close all;
clc;

%% 参数设定
ifconv=1;%是否进行卷积编码
datalen=1024*8;%随机生成01序列的长度
eff=2;%卷积编码效率，取值{2,3},2代表1/2编码，3代表1/3编码
tail=1;%卷积编码发端是否收尾，取值{0,1}，0代表不收尾，1代表收尾
bitmode=1;%电平映射模式，取值{1,2,3}，1代表1bit/符号，2代表2bit/符号，3代表3bit/符号
sigma=0.5; %即σ
codemode=1;%选择第多少对秘钥


holegap = 0;
%% 连接所有的模块，构成整个通信系统
data1=sourcedata(datalen);  %随机生成数据流
disp("正在加密!");
data2=coding_control(data1,codemode);%加密
disp("加密完成!");

convres=data2;
%data=CRCCoding(data1,25,4);
 if ifconv
    convres=model_conv(data2,eff,tail);  %卷积编码
 else
     eff=1;
 end

%convres = DiggingHole(convres, holegap, eff);

mapres=model_map(convres,bitmode);  %电平映射
channelres=channel2(mapres,sigma);  %信道传输

hard_bitcode = hard_judge(channelres, bitmode, eff);

if ifconv
    %硬判决部分
    decode_bit = hard_viterbi(hard_bitcode, eff, tail, holegap);
    disp("正在解密!");
    decode_bit = decoding_control(decode_bit,codemode);%解密
    disp("解密完成!");
    Res = decode_bit(1:length([data1, zeros(1,3*(tail==1))])) ~= [data1, zeros(1,3*(tail==1))];
    sum(abs(Res))

    % 软判决部分
    bitProb = soft_judge(channelres, bitmode, eff);
    decode_bit = soft_viterbi(bitProb, eff, tail, holegap);
    disp("正在解密!");
    decode_bit = decoding_control(decode_bit,codemode);%解密
    disp("解密完成!");
    Res = decode_bit(1:length([data1, zeros(1,3*(tail==1))])) ~= [data1, zeros(1,3*(tail==1))];
    sum(abs(Res))
else
    disp("正在解密!");
    hard_bitcode = decoding_control(hard_bitcode,codemode);%解密
    disp("解密完成!");
    Res=hard_bitcode~=data1;
    sum(abs(Res))
end

