function output=model_conv(input,eff,tail)
   %% 输入输出规范:
    % 输入:
    %      1.有限长01序列input
    %      2.卷积编码效率eff: 2代表1/2,3代表1/3
    %      3.收尾tail  1代表收尾，0代表不收尾:
    % 输出:有限长01序列output
    
   %% 示例:
    % output=model_conv([1,1,1,1],2,0);
    
   %% 思路:
    % input=[1,1,0];
    % G=[1,0,1;1,1,1];
    % 将input写成[1,1,0;0,1,1;0,0,1;]的形式
    % G*input=[1,1,1;1,0,0];
    % 按列向量组合得到结果
    
   %% 代码:
    
    input=[input,zeros(1,3*(tail==1))];
  
    len=length(input);
    if eff==2
        G=[1,1,0,1;1,1,1,1;];%1/2效率
    elseif eff==3
        G=[1,0,1,1;1,1,0,1;1,1,1,1;];%1/3效率
    end
    input_s=zeros(4,len);%拓展长度
    for k=1:4 %移位拓展
        input_s(k,1:len)=[zeros(1,k-1),input(1:len-k+1)];
    end
    output=mod(G*input_s,2);%mod2和
    output=reshape(output,1,len*eff);
end