%绘制Eb/n0和误码率关系特供版信道，多输出一个Eb/n0
%信道模块，输入发送的角度phi_input(2bit/symbol）
%输出接收的角度phi_output（-π到π)
function [output,Eb_n0]=channel3(phi_input,sigma)
close all;
    if exist("phi_input")~=1
        phi_input=2*pi*rand(1,4096)-pi; %输入样例
    end
    L=length(phi_input); %4096(2bit/symbol)
    A=1;%幅度
    if exist("sigma")~=1
        sigma=0;%噪声信号的sigma
    end
    delay=5;%延时以实现因果
    rate=10;%冲击间隔
    rs=2000;
    Ts=1/rs;
    ttrans=L/rs;%传输时间2.048s
    fs=rs*rate;%采样频率 20000Hz  
    w=rs*3/4;%带宽1500Hz
    %wc=2;%载波角频率，这个取值问题待解决
    f0=1850;%(300+3400)/2
    phi_I=A*cos(phi_input);%I路cos
    phi_Q=A*sin(phi_input);%Q路sin
    phi_pulse_I=reshape([phi_I;zeros(rate-1,L)],1,L*rate);%插0中间生成冲击串
    phi_pulse_I_delay=[zeros(1,2*rate*delay),phi_pulse_I];
    phi_pulse_I=[phi_pulse_I,zeros(1,2*rate*delay)];%补0使得和滤波器长度一致
    phi_trans_I=filter(rcosfir(0.5,delay,rate,1/fs,'sqrt'),1,phi_pulse_I);%成型滤波
    phi_pulse_Q=reshape([phi_Q;zeros(rate-1,L)],1,L*rate);%生成冲击串
    phi_pulse_Q=[phi_pulse_Q,zeros(1,2*rate*delay)];%补0延时的长度
     t=1:length(phi_trans_I);
     t=t/fs;
    phi_trans_Q=filter(rcosfir(0.5,delay,rate,1/fs,'sqrt'),1,phi_pulse_Q);%成型滤波   
   % phi_trans=phi_trans_I.*cos(wc*t)+phi_trans_Q.*sin(wc*t);%两路加载载波并相加
   phi_trans=phi_trans_I.*cos(2*pi*f0*t)+phi_trans_Q.*sin(2*pi*f0*t);%两路加载载波并相加
  %%
%   figure;
%   plot(phi_trans(1:200));
%   title("发射波形");
%     figure;%绘制发射功率谱
%     tff=1:length(phi_trans);
%     p1=abs(fft((phi_trans))).^2;
%     p1=5*log(p1);
%     mn=50;
%     for i=1+mn:length(phi_trans)/4
%         p1(i)=sum(p1(i-mn:i+mn))/(2*mn+1);
%     end
%     plot(tff(1:length(phi_trans)/4)/length(phi_trans)*fs,p1(1:length(phi_trans)/4));
%     title("发射功率谱");
%     xlabel("Hz");
%     ylabel("dB");
    %%
    n=normrnd(0,sigma,1,length(phi_trans));
    phi_trans_noisy=phi_trans+n;
    Eb_n0=phi_trans*phi_trans.'/(n*n.')/4;
    %%
%     figure;%绘制接收功率谱
%   plot(phi_trans_noisy(1:200));
%   title("接收波形");
%     figure;%绘制发射功率谱
%     tff=1:length(phi_trans_noisy);
%     p2=abs(fft((phi_trans_noisy))).^2;
%     p2=5*log(p2);
%     mn=50;
%     for i=1+mn:length(phi_trans)/4
%         p2(i)=sum(p2(i-mn:i+mn))/(2*mn+1);
%     end
%     plot(tff(1:length(phi_trans)/4)/length(phi_trans)*fs,p2(1:length(phi_trans)/4));
%     title("接收功率谱");
%     xlabel("Hz");
%     ylabel("dB");
    %%
    phi_received_I=2*phi_trans_noisy.*cos(2*pi*f0*t);%I路解调
    phi_matched_I=filter(rcosfir(0.5,delay,rate,1/fs,'sqrt'),1,phi_received_I);%I路匹配滤波
    %%
%     figure;
%    plot(phi_matched_I(1:500));
%    hold on;
%    stem(phi_pulse_I_delay(1:500));
%    title("I路 σ="+sigma);
%    hold off;
%%
    cosphi=phi_matched_I(2*rate*delay+1:rate:length(phi_matched_I));%抽样得到cosφ
  
    phi_received_Q=2*phi_trans_noisy.*sin(2*pi*f0*t);%Q路解调
    phi_matched_Q=filter(rcosfir(0.5,delay,rate,1/fs,'sqrt'),1,phi_received_Q);%Q路匹配滤波
    sinphi=phi_matched_Q(2*rate*delay+1:rate:length(phi_matched_Q));%抽样得到sinφ
    output=1/A*(cosphi+1j*sinphi);%还原符号
    phi_output=angle(output);%计算幅角并输出
   % loss=(mean(abs(phi_output-phi_input)))%平均误差
    
end