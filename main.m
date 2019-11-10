%% ���ļ����ڼ�������ģ��
clear all;
close all;
clc;

%% �����趨
datalen=1024*8;%�������01���еĳ���
%eff=3;%�������Ч�ʣ�ȡֵ{2,3},2����1/2���룬3����1/3����
%tail=1;%������뷢���Ƿ���β��ȡֵ{0,1}��0������β��1������β
bitmode=2;%��ƽӳ��ģʽ��ȡֵ{1,2,3}��1����1bit/���ţ�2����2bit/���ţ�3����3bit/����
%channelmode=2;%�ŵ�����ģʽ��ȡֵ{1,2}��1��ʾ����1:������ͨ�Ź����Цղ��䣬ÿ��ͨ���ж����Ħ� 2��ʾ����2:����һ��ͨ�Ź����У�ÿ���ŵ�ʹ�æվ������仯
%theta=pi/6; %����
%sigma=0.45; %����

knownPhi = 0;  % ����ʱ�Ƿ�֪��Phi��
holegap = 7;
%% �������е�ģ�飬��������ͨ��ϵͳ
data1=sourcedata(datalen);  %�������������
%data=CRCCoding(data1,25,4);
%convres=model_conv(data,eff,tail);  %�������

%convres = DiggingHole(convres, holegap, eff);

mapres=model_map(convres,bitmode);  %��ƽӳ��
[channelres, phi]=channel(mapres,channelmode,theta,sigma);  %�ŵ�����

%����̶����ǲ���֪phi�ǣ��ȼ��������ܵ�phi
if (~knownPhi) && (channelmode)
    phi=calculatefai(channelres,bitmode,theta);
    knownPhi=1;
end

% Ӳ�о�����
hard_bitcode = hard_judge(channelres, bitmode, eff, knownPhi, phi);
decode_bit = hard_viterbi(hard_bitcode, eff, tail, holegap);
Res = decode_bit(1:length([data, zeros(1,3*(tail==1))])) ~= [data, zeros(1,3*(tail==1))];
sum(abs(Res))

% ���о�����
bitProb = soft_judge(channelres, bitmode, eff, knownPhi, phi, theta);
decode_bit = soft_viterbi(bitProb, eff, tail, holegap);
Res = decode_bit(1:length([data, zeros(1,3*(tail==1))])) ~= [data, zeros(1,3*(tail==1))];
sum(abs(Res))