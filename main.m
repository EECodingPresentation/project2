%% ���ļ����ڼ�������ģ��
clear all;
close all;
clc;

%% �����趨
ifconv=1;%�Ƿ���о������
datalen=1024*8;%�������01���еĳ���
eff=2;%�������Ч�ʣ�ȡֵ{2,3},2����1/2���룬3����1/3����
tail=1;%������뷢���Ƿ���β��ȡֵ{0,1}��0������β��1������β
bitmode=1;%��ƽӳ��ģʽ��ȡֵ{1,2,3}��1����1bit/���ţ�2����2bit/���ţ�3����3bit/����
sigma=0.5; %����
codemode=1;%ѡ��ڶ��ٶ���Կ


holegap = 0;
%% �������е�ģ�飬��������ͨ��ϵͳ
data1=sourcedata(datalen);  %�������������
disp("���ڼ���!");
data2=coding_control(data1,codemode);%����
disp("�������!");

convres=data2;
%data=CRCCoding(data1,25,4);
 if ifconv
    convres=model_conv(data2,eff,tail);  %�������
 else
     eff=1;
 end

%convres = DiggingHole(convres, holegap, eff);

mapres=model_map(convres,bitmode);  %��ƽӳ��
channelres=channel2(mapres,sigma);  %�ŵ�����

hard_bitcode = hard_judge(channelres, bitmode, eff);

if ifconv
    %Ӳ�о�����
    decode_bit = hard_viterbi(hard_bitcode, eff, tail, holegap);
    disp("���ڽ���!");
    decode_bit = decoding_control(decode_bit,codemode);%����
    disp("�������!");
    Res = decode_bit(1:length([data1, zeros(1,3*(tail==1))])) ~= [data1, zeros(1,3*(tail==1))];
    sum(abs(Res))

    % ���о�����
    bitProb = soft_judge(channelres, bitmode, eff);
    decode_bit = soft_viterbi(bitProb, eff, tail, holegap);
    disp("���ڽ���!");
    decode_bit = decoding_control(decode_bit,codemode);%����
    disp("�������!");
    Res = decode_bit(1:length([data1, zeros(1,3*(tail==1))])) ~= [data1, zeros(1,3*(tail==1))];
    sum(abs(Res))
else
    disp("���ڽ���!");
    hard_bitcode = decoding_control(hard_bitcode,codemode);%����
    disp("�������!");
    Res=hard_bitcode~=data1;
    sum(abs(Res))
end

