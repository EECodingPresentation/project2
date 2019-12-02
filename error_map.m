%% ���ļ����ڼ�������ģ��
clear all;
close all;
clc;

%% �����趨
ifconv=1;%�Ƿ���о������
datalen=128*3;%�������01���еĳ���
eff=3;%�������Ч�ʣ�ȡֵ{2,3},2����1/2���룬3����1/3����
tail=1;%������뷢���Ƿ���β��ȡֵ{0,1}��0������β��1������β
bitmode=1;%��ƽӳ��ģʽ��ȡֵ{1,2,3}��1����1bit/���ţ�2����2bit/���ţ�3����3bit/����
sigma=0.5; %����
codemode=31;%ѡ��ڶ��ٶ���Կ

for ifconv = [0, 1]
	if ifconv
		strConv = '������룺';
	else
		strConv = '��������룺';
	end
	for sigma = [0.2, 0.4]
		figure('NumberTitle', 'off', 'Name', [strConv,';��=',num2str(sigma)]);
		cnt = 0;
		for codemode = [31, 71]
        % for codemode = [31, 71]  % Ŀǰ�޷�����RSA
			for bitmode = [1, 2, 3]
				for eff = [2, 3]
					if bitmode == 2 && eff == 3
                        break;
                    end
                    if codemode <= 30
						strEncrypt = 'RSA���ܣ�';
                    elseif codemode <= 70
						strEncrypt = 'DES���ܣ�';
					else
						strEncrypt = 'AES���ܣ�';
					end
					holegap = 0;
					%% �������е�ģ�飬��������ͨ��ϵͳ
					data1=sourcedata(datalen);  %�������������
					disp("���ڼ���!");
					data2=coding_control(data1,codemode);%����
					disp("�������!");

					convres=data2;
					%data=CRCCoding(data1,25,4);
					 if ifconv
						convres=model_conv(data2,eff,tail);  %�������
					 else
						 eff=1;
					 end

					%convres = DiggingHole(convres, holegap, eff);

					mapres=model_map(convres,bitmode);  %��ƽӳ��
					channelres=channel2(mapres,sigma);  %�ŵ�����

					hard_bitcode = hard_judge(channelres, bitmode, eff);

					if ifconv
						%Ӳ�о�����
						decode_bit = hard_viterbi(hard_bitcode, eff, tail, holegap);
						disp("���ڽ���!");
						decode_bit = decoding_control(decode_bit,codemode);%����
						disp("�������!");
						Res = decode_bit(1:length([data1, zeros(1,3*(tail==1))])) ~= [data1, zeros(1,3*(tail==1))];
						sum(abs(Res))

						% ���о�����
						bitProb = soft_judge(channelres, bitmode, eff);
						decode_bit = soft_viterbi(bitProb, eff, tail, holegap);
						disp("���ڽ���!");
						decode_bit = decoding_control(decode_bit,codemode);%����
						disp("�������!");
						Res = decode_bit(1:length([data1, zeros(1,3*(tail==1))])) ~= [data1, zeros(1,3*(tail==1))];
						sum(abs(Res))
					else
						disp("���ڽ���!");
						decode_bit = decoding_control(hard_bitcode,codemode);%����
						disp("�������!");
						Res=decode_bit~=data1;
						sum(abs(Res))
					end
					cnt = cnt + 1;
					subplot(3, 5, cnt);
					stem(Res,'MarkerSize',1);
					title([num2str(bitmode),'bit/����;�������Ч��1/',...
						num2str(eff)]) 
				end
			end
		end
	end
end
