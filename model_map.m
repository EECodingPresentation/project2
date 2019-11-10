function output=model_map(input,mode) %电平映射
    %% 输入输出规范
    % 输入:
        %1.卷积编码后的01序列input
        %2.电平映射模式mode: 1:1bit/符号   2bit:符号     3bit:符号
    % 输出:映射的电平符号序列output
    
    %% 示例:
    % output=model_map([1,1,0,1,1,1],3);
    
    %% 思路:
    % G代表从0到2^bit-1对应编号的电平值，将输入的序列每mode个bit集合起来，查找对应的G。
    % 电平与编码的对应关系见星座图.png
    
    %% 代码:
    if mode==1
        G=[-1,1];
        output=G(input+1);
    elseif mode==2
        input=[input,zeros(1,mod(length(input),2))];
        len=length(input);
%         if mod(len,2)~=0
%             error('input的长度必须为2的倍数!');
%         end
        angle=pi/2;
        G=[1,exp(1j*angle),exp(1j*angle*3),exp(1j*angle*2)];
        input=input(1:2:len)*2+input(2:2:len);%每2bit集合
        output=G(input+1);
    elseif mode==3
        input=[input,zeros(1,mod(3-mod(length(input),3),3))];
        len=length(input);
%         if mod(len,3)~=0
%             error('input的长度必须为3的倍数!');
%         end
        angle=pi/4;
        G=[1,exp(1j*angle),exp(1j*angle*3),exp(1j*angle*2),exp(1j*angle*7),exp(1j*angle*6),exp(1j*angle*4),exp(1j*angle*5)];
        input=input(1:3:len)*4+input(2:3:len)*2+input(3:3:len);%每3bit集合
        output=G(input+1);
    end
    
end