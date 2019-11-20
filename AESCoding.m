function ctext0=AESCoding(ptext0,k)
%����Ҫ��ptext0:�����ܵ����ݱ��ر��ش���������
%          k:128λ��Կ,������������
ctext0=[];
global s_box_i;
AESpre;
%������Կ
if exist('k')~=1
    k=zeros(1,128);
end
k = reshape(k, [8,16]);
k = char(k'+'0');
k = bin2dec(k);
k = reshape(k,[4,4]);
%��Կ��չ
W=keyextend(k);
%����
if exist('ptext0')~=1
    info = 'Im too vegetable';
    ptext = double(info);
    ptext = (dec2bin(ptext,8));
    ptext = reshape(ptext', [1,128]);
    ptext0 = ptext - '0';
end
l=length(ptext0);
N=floor(l/128);
if N*128>l
    ptext0=[ptext0,zeros(1,N*128-l)];
end
for m=1:N
    ptext = ptext0(128*(m-1)+1:128*m);
    ptext = reshape(ptext, [8,16]);
    ptext = char(ptext'+'0');
    ptext = bin2dec(ptext);
    ptext = reshape(ptext,[4,4]);
    %���ܹ���
    ctext = bitxor(ptext,W(:,1:4));
    for i=1:10
        ctext = s_box_i(ctext+1);   %�ֽڴ���
        ctext(2,:) = [ctext(2 , 2:4),ctext(2,1)];                            %����λ
        ctext(3,:) = [ctext(3 , 3:4),ctext(3 , 1:2)];
        ctext(4,:) = [ctext(4,4),ctext(4,1:3)];
        if(i~=10)
            ctext=cmix(ctext);                    %�л��
        end
        ctext=bitxor(ctext,W(:,i*4+1:i*4+4));
    end
    ctext=dec2bin(ctext,8);
    ctext = reshape(ctext', [1,128]);
    ctext = ctext - '0';
  %  AESDecoding(ctext,k)
    ctext0=[ctext0,ctext];
end
end




function a = cmix(input)
    a=zeros(4,4);
    a(1,:)=bitxor(bitxor(AESlistmulti(input(1,:),2),AESlistmulti(input(2,:),3)),bitxor(input(3,:),input(4,:)));
    a(2,:)=bitxor(bitxor(input(1,:),AESlistmulti(input(2,:),2)),bitxor(AESlistmulti(input(3,:),3),input(4,:)));
    a(3,:)=bitxor(bitxor(input(1,:),input(2,:)),bitxor(AESlistmulti(input(3,:),2),AESlistmulti(input(4,:),3)));
    a(4,:)=bitxor(bitxor(AESlistmulti(input(1,:),3),input(2,:)),bitxor(input(3,:),AESlistmulti(input(4,:),2)));
end