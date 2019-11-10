function output=model_map(input,mode) %��ƽӳ��
    %% ��������淶
    % ����:
        %1.���������01����input
        %2.��ƽӳ��ģʽmode: 1:1bit/����   2bit:����     3bit:����
    % ���:ӳ��ĵ�ƽ��������output
    
    %% ʾ��:
    % output=model_map([1,1,0,1,1,1],3);
    
    %% ˼·:
    % G�����0��2^bit-1��Ӧ��ŵĵ�ƽֵ�������������ÿmode��bit�������������Ҷ�Ӧ��G��
    % ��ƽ�����Ķ�Ӧ��ϵ������ͼ.png
    
    %% ����:
    if mode==1
        G=[-1,1];
        output=G(input+1);
    elseif mode==2
        input=[input,zeros(1,mod(length(input),2))];
        len=length(input);
%         if mod(len,2)~=0
%             error('input�ĳ��ȱ���Ϊ2�ı���!');
%         end
        angle=pi/2;
        G=[1,exp(1j*angle),exp(1j*angle*3),exp(1j*angle*2)];
        input=input(1:2:len)*2+input(2:2:len);%ÿ2bit����
        output=G(input+1);
    elseif mode==3
        input=[input,zeros(1,mod(3-mod(length(input),3),3))];
        len=length(input);
%         if mod(len,3)~=0
%             error('input�ĳ��ȱ���Ϊ3�ı���!');
%         end
        angle=pi/4;
        G=[1,exp(1j*angle),exp(1j*angle*3),exp(1j*angle*2),exp(1j*angle*7),exp(1j*angle*6),exp(1j*angle*4),exp(1j*angle*5)];
        input=input(1:3:len)*4+input(2:3:len)*2+input(3:3:len);%ÿ3bit����
        output=G(input+1);
    end
    
end