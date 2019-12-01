function ptext0 = AESDecoding(ctext0, k)
%����Ҫ��ctext0:�����ܵ����ݱ��ر��ش���������
%          k:128λ��Կ,������������
ptext0=[];
k = reshape(k, [8,16]);
k = char(k'+'0');
k = bin2dec(k);
k = reshape(k,[4,4]);
global inv_s_box_i;
AESpre;
%��Կ��չ
W=keyextend(k);
%����ģ��
l=length(ctext0);
N=ceil(l/128);
if N*128>l
    ctext0=[ctext0,zeros(1,N*128-l)];
end
for m=1:N
    ctext = ctext0(128*(m-1)+1:128*m);
    ctext = reshape(ctext, [8,16]);
    ctext = char(ctext'+'0');
    ctext = bin2dec(ctext);
    ctext = reshape(ctext,[4,4]);
    ptext = bitxor(ctext,W(:,41:44));
    for i=9:-1:0
        ptext(4,:) = [ptext(4 , 2:4),ptext(4,1)];                            %������λ
        ptext(3,:) = [ptext(3 , 3:4),ptext(3 , 1:2)];
        ptext(2,:) = [ptext(2,4),ptext(2,1:3)];
        ptext = inv_s_box_i(ptext+1);   %���ֽڴ���
        ptext=bitxor(ptext,W(:,i*4+1:i*4+4));
        if i~=0
            ptext=invcmix(ptext);       %���л��
        end
    end
    ptext=dec2bin(ptext,8);
    ptext = reshape(ptext', [1,128]);
    ptext = ptext - '0';
    ptext0=[ptext0,ptext];
end
end

function output = invcmix(input)
%CMIX �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
a=zeros(4,4);
a(1,:)=bitxor(bitxor(AESlistmulti(input(1,:),14),AESlistmulti(input(2,:),11)),bitxor(AESlistmulti(input(3,:),13),AESlistmulti(input(4,:),9)));
a(2,:)=bitxor(bitxor(AESlistmulti(input(1,:),9),AESlistmulti(input(2,:),14)),bitxor(AESlistmulti(input(3,:),11),AESlistmulti(input(4,:),13)));
a(3,:)=bitxor(bitxor(AESlistmulti(input(1,:),13),AESlistmulti(input(2,:),9)),bitxor(AESlistmulti(input(3,:),14),AESlistmulti(input(4,:),11)));
a(4,:)=bitxor(bitxor(AESlistmulti(input(1,:),11),AESlistmulti(input(2,:),13)),bitxor(AESlistmulti(input(3,:),9),AESlistmulti(input(4,:),14)));
output=a;
end

function output = keyextend(k)
%KEYEXTEND �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
global s_box_i;
%k=uint8(reshape((0:15),[4,4])');
% k=["3C A1 0B 21 57 F0 19 16 90 2E 13 80 AC C1 07 BD"];
% k=hex2dec(strsplit(k));
% k=reshape(k,[4,4]);
%Rcon = ["01000000","02000000","04000000","08000000","10000000","20000000","40000000","80000000","1b000000","36000000"];
Rcon = ["01","02","04","08","10","20","40","80","1b","36"];
Rcon = hex2dec(Rcon);
W=zeros(4,44);
W(:,1:4)=k;
for i=5:44
    if mod(i,4)~=1;
        W(:,i)=bitxor(W(:,i-4),W(:,i-1));
    else
        T=W(:,i-1);
        T=[T(2:4);T(1)];
        T=s_box_i(T+1);
        T(1)=bitxor(T(1),Rcon((i-1)/4));
        W(:,i)=bitxor(W(:,i-4),T);
    end
end
output=W;
end
