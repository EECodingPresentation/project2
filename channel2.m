%�ŵ�ģ�飬���뷢�͵ĽǶ�phi_input(2bit/symbol��
%������յĽǶ�phi_output��-�е���)
function phi_output=channel2(phi_input)
   % phi_input=2*pi*rand(1,4096)-pi; %��������
    L=length(phi_input); %4096(2bit/symbol)
    A=1;%����
    sigma=0;%�����źŵ�sigma
    delay=5;%��ʱ��ʵ�����
    rate=5;%������
    fs=L*rate/5;%�������� 8192  %
    w=fs*3/4/rate;%����3072
    wc=2;%�ز���Ƶ�ʣ����ȡֵ��������
    phi_I=A*cos(phi_input);%I·cos
    phi_Q=A*sin(phi_input);%Q·sin
    phi_pulse_I=reshape([phi_I;zeros(rate-1,L)],1,L*rate);%���ɳ����
    phi_pulse_I=[phi_pulse_I,zeros(1,2*rate*delay)];%��0��ʱ�ĳ���
    phi_trans_I=filter(rcosfir(0.5,delay,rate,1/fs,'sqrt'),1,phi_pulse_I);%�����˲�
    phi_pulse_Q=reshape([phi_Q;zeros(rate-1,L)],1,L*rate);%���ɳ����
    phi_pulse_Q=[phi_pulse_Q,zeros(1,2*rate*delay)];%��0��ʱ�ĳ���
     t=1:length(phi_trans_I);
    phi_trans_Q=filter(rcosfir(0.5,delay,rate,1/fs,'sqrt'),1,phi_pulse_Q);%�����˲�   
    phi_trans=phi_trans_I.*cos(wc*t)+phi_trans_Q.*sin(wc*t);%��·�����ز������
    %figure;
    %tff=1:length(phi_trans);
    %plot(tff/length(phi_trans)*fs,abs(fft((phi_trans_I))));
    %figure;
   % tff=1:length(phi_trans);
    %plot(tff/length(phi_trans)*fs,abs(fft((phi_trans))));
    n=normrnd(0,sigma,1,length(phi_trans));
    phi_trans_noisy= phi_trans;
    phi_received_I=2*phi_trans_noisy.*cos(wc*t);%I·���
    phi_matched_I=filter(rcosfir(0.5,delay,rate,1/fs,'sqrt'),1,phi_received_I);%I·ƥ���˲�
    cosphi=phi_matched_I(2*rate*delay+1:rate:length(phi_matched_I));%�����õ�cos��
    %figure;
    %tff=1:length(cosphi);
    %plot(tff/length(cosphi)*fs,abs(fft((cosphi))));
    phi_received_Q=2*phi_trans_noisy.*sin(wc*t);%Q·���
    phi_matched_Q=filter(rcosfir(0.5,delay,rate,1/fs,'sqrt'),1,phi_received_Q);%Q·ƥ���˲�
    sinphi=phi_matched_Q(2*rate*delay+1:rate:length(phi_matched_Q));%�����õ�sin��
    signal=1/A*(cosphi+1j*sinphi);%��ԭ����
    phi_output=angle(signal);%������ǲ����
    loss=(mean(abs(phi_output-phi_input)))%ƽ�����
    
end