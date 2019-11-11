%�ŵ�ģ�飬���뷢�͵ĽǶ�phi_input(2bit/symbol��
%������յĽǶ�phi_output��-�е���)
function phi_output=channel2(phi_input)
    phi_input=zeros(1,4096); %��������
    L=length(phi_input); %4096(2bit/symbol)
    A=100;%����
    sigma=0.5;%�����źŵ�sigma
    delay=50;%��ʱ��ʵ�����
    rate=5;%������
    rs=L*rate/5;%�������� 8192  %
    w=rs*3/4;%����3072
    fc=314/rs;%�ز�Ƶ��314Hz
    f0=2000;
    phi_I=A*cos(phi_input);%I·cos
    phi_Q=A*sin(phi_input);%Q·sin
    phi_pulse_I=reshape([phi_I;zeros(rate-1,L)],1,L*rate);%���ɳ����
    phi_pulse_I=[phi_pulse_I,zeros(1,2*rate*delay)];%��0��ʱ�ĳ���
    phi_trans_I=filter(rcosfir(0.5,delay,rate,1/rs,'sqrt'),1,phi_pulse_I);%�����˲�
    phi_pulse_Q=reshape([phi_Q;zeros(rate-1,L)],1,L*rate);%���ɳ����
    phi_pulse_Q=[phi_pulse_Q,zeros(1,2*rate*delay)];%��0��ʱ�ĳ���
    phi_trans_Q=filter(rcosfir(0.5,delay,rate,1/rs,'sqrt'),1,phi_pulse_Q);%�����˲�
    t=1:length(phi_trans_I);
    t=t/rate/rs;
    phi_trans=phi_trans_I.*cos(2*pi*f0*t)-phi_trans_Q.*sin(2*pi*f0*t);%��·�����ز������
    yyy=fft(phi_trans);
    plot(abs(yyy))
    n=normrnd(0,sigma,1,length(phi_trans));
    phi_trans_noisy= phi_trans+n;
    phi_received_I=phi_trans_noisy.*cos(2*pi*f0*t);%I·���
    phi_matched_I=filter(rcosfir(0.5,delay,rate,1/rs,'sqrt'),1,phi_received_I);%I·ƥ���˲�
    cosphi=phi_matched_I(2*rate*delay+1:rate:length(phi_matched_I));%�����õ�cos��
    phi_received_Q=-phi_trans_noisy.*sin(2*pi*f0*t);%Q·���
    phi_matched_Q=filter(rcosfir(0.5,delay,rate,1/rs,'sqrt'),1,phi_received_Q);%Q·ƥ���˲�
    sinphi=phi_matched_Q(2*rate*delay+1:rate:length(phi_matched_Q));%�����õ�sin��
    signal=1/A*(cosphi+1j*sinphi);%��ԭ����
    phi_output=angle(signal);%������ǲ����
    
end