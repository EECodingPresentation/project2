%信道模块，输入发送的角度phi_input(2bit/symbol）
%输出接收的角度phi_output（-π到π)
function phi_output=channel2(phi_input)
    phi_input=zeros(1,4096); %输入样例
    L=length(phi_input); %4096(2bit/symbol)
    A=100;%幅度
    sigma=0.5;%噪声信号的sigma
    delay=50;%延时以实现因果
    rate=5;%冲击间隔
    rs=L*rate/5;%传输速率 8192  %
    w=rs*3/4;%带宽3072
    fc=314/rs;%载波频率314Hz
    f0=2000;
    phi_I=A*cos(phi_input);%I路cos
    phi_Q=A*sin(phi_input);%Q路sin
    phi_pulse_I=reshape([phi_I;zeros(rate-1,L)],1,L*rate);%生成冲击串
    phi_pulse_I=[phi_pulse_I,zeros(1,2*rate*delay)];%补0延时的长度
    phi_trans_I=filter(rcosfir(0.5,delay,rate,1/rs,'sqrt'),1,phi_pulse_I);%成型滤波
    phi_pulse_Q=reshape([phi_Q;zeros(rate-1,L)],1,L*rate);%生成冲击串
    phi_pulse_Q=[phi_pulse_Q,zeros(1,2*rate*delay)];%补0延时的长度
    phi_trans_Q=filter(rcosfir(0.5,delay,rate,1/rs,'sqrt'),1,phi_pulse_Q);%成型滤波
    t=1:length(phi_trans_I);
    t=t/rate/rs;
    phi_trans=phi_trans_I.*cos(2*pi*f0*t)-phi_trans_Q.*sin(2*pi*f0*t);%两路加载载波并相加
    yyy=fft(phi_trans);
    plot(abs(yyy))
    n=normrnd(0,sigma,1,length(phi_trans));
    phi_trans_noisy= phi_trans+n;
    phi_received_I=phi_trans_noisy.*cos(2*pi*f0*t);%I路解调
    phi_matched_I=filter(rcosfir(0.5,delay,rate,1/rs,'sqrt'),1,phi_received_I);%I路匹配滤波
    cosphi=phi_matched_I(2*rate*delay+1:rate:length(phi_matched_I));%抽样得到cosφ
    phi_received_Q=-phi_trans_noisy.*sin(2*pi*f0*t);%Q路解调
    phi_matched_Q=filter(rcosfir(0.5,delay,rate,1/rs,'sqrt'),1,phi_received_Q);%Q路匹配滤波
    sinphi=phi_matched_Q(2*rate*delay+1:rate:length(phi_matched_Q));%抽样得到sinφ
    signal=1/A*(cosphi+1j*sinphi);%还原符号
    phi_output=angle(signal);%计算幅角并输出
    
end