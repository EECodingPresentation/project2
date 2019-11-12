%信道模块，输入发送的角度phi_input(2bit/symbol）
%输出接收的角度phi_output（-π到π)
function phi_output=channel2(phi_input)
   % phi_input=2*pi*rand(1,4096)-pi; %输入样例
    L=length(phi_input); %4096(2bit/symbol)
    A=1;%幅度
    sigma=0;%噪声信号的sigma
    delay=5;%延时以实现因果
    rate=5;%冲击间隔
    fs=L*rate/5;%传输速率 8192  %
    w=fs*3/4/rate;%带宽3072
    wc=2;%载波角频率，这个取值问题待解决
    phi_I=A*cos(phi_input);%I路cos
    phi_Q=A*sin(phi_input);%Q路sin
    phi_pulse_I=reshape([phi_I;zeros(rate-1,L)],1,L*rate);%生成冲击串
    phi_pulse_I=[phi_pulse_I,zeros(1,2*rate*delay)];%补0延时的长度
    phi_trans_I=filter(rcosfir(0.5,delay,rate,1/fs,'sqrt'),1,phi_pulse_I);%成型滤波
    phi_pulse_Q=reshape([phi_Q;zeros(rate-1,L)],1,L*rate);%生成冲击串
    phi_pulse_Q=[phi_pulse_Q,zeros(1,2*rate*delay)];%补0延时的长度
     t=1:length(phi_trans_I);
    phi_trans_Q=filter(rcosfir(0.5,delay,rate,1/fs,'sqrt'),1,phi_pulse_Q);%成型滤波   
    phi_trans=phi_trans_I.*cos(wc*t)+phi_trans_Q.*sin(wc*t);%两路加载载波并相加
    %figure;
    %tff=1:length(phi_trans);
    %plot(tff/length(phi_trans)*fs,abs(fft((phi_trans_I))));
    %figure;
   % tff=1:length(phi_trans);
    %plot(tff/length(phi_trans)*fs,abs(fft((phi_trans))));
    n=normrnd(0,sigma,1,length(phi_trans));
    phi_trans_noisy= phi_trans;
    phi_received_I=2*phi_trans_noisy.*cos(wc*t);%I路解调
    phi_matched_I=filter(rcosfir(0.5,delay,rate,1/fs,'sqrt'),1,phi_received_I);%I路匹配滤波
    cosphi=phi_matched_I(2*rate*delay+1:rate:length(phi_matched_I));%抽样得到cosφ
    %figure;
    %tff=1:length(cosphi);
    %plot(tff/length(cosphi)*fs,abs(fft((cosphi))));
    phi_received_Q=2*phi_trans_noisy.*sin(wc*t);%Q路解调
    phi_matched_Q=filter(rcosfir(0.5,delay,rate,1/fs,'sqrt'),1,phi_received_Q);%Q路匹配滤波
    sinphi=phi_matched_Q(2*rate*delay+1:rate:length(phi_matched_Q));%抽样得到sinφ
    signal=1/A*(cosphi+1j*sinphi);%还原符号
    phi_output=angle(signal);%计算幅角并输出
    loss=(mean(abs(phi_output-phi_input)))%平均误差
    
end