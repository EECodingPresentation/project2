function output=model_map(input,mode) %电平映射
    %% 输入输出规范
    % 输入:
        %1.卷积编码后的01序列input
        %2.电平映射模式mode: 1:1bit/符号   2bit:符号     3bit:符号
    % 输出:映射的电平符号序列output，其中output是相位
    
    %% 示例:
    % output=model_map([1,1,0,1,1,1],3);
    
    %% 思路:
    % G代表从0到2^bit-1对应编号的相位，将输入的序列每mode个bit集合起来，查找对应的G。
    % 电平与编码的对应关系见星座图.png
    
    %% 代码:
    if mode==1
        G=[pi,0];
        output=G(input+1);
    elseif mode==2
        input=[input,zeros(1,mod(length(input),2))];
        len=length(input);
        angle=pi/2;
        G=[0,angle,3*angle,angle*2];
        input=input(1:2:len)*2+input(2:2:len);%每2bit集合
        output=G(input+1);
    elseif mode==3
        input=[input,zeros(1,mod(3-mod(length(input),3),3))];
        len=length(input);
        angle=pi/4;
        G=[0,angle,angle*3,angle*2,angle*7,angle*6,angle*4,angle*5];
        input=input(1:3:len)*4+input(2:3:len)*2+input(3:3:len);%每3bit集合
        output=G(input+1);
    end
    
end