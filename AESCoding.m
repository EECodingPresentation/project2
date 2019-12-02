function ctext0=AESCoding(ptext0,k)
%输入要求：ptext0:待加密的数据比特比特串，行向量
%          k:128位密钥,行列向量都行
ctext0=[];
global s_box_i;
AESpre;
%生成密钥
if exist('k')~=1
    k=zeros(1,128);
end
k = reshape(k, [8,16]);
k = char(k'+'0');
k = bin2dec(k);
k = reshape(k,[4,4]);
%密钥扩展
W=keyextend(k);
%明文
l=length(ptext0);
N=ceil(l/128);
if N*128>l
    ptext0=[ptext0,zeros(1,N*128-l)];
end
for m=1:N
    ptext = ptext0(128*(m-1)+1:128*m);
    ptext = reshape(ptext, [8,16]);
    ptext = char(ptext'+'0');
    ptext = bin2dec(ptext);
    ptext = reshape(ptext,[4,4]);
    %加密过程
    ctext = bitxor(ptext,W(:,1:4));
    for i=1:10
        ctext = s_box_i(ctext+1);   %字节代换
        ctext(2,:) = [ctext(2 , 2:4),ctext(2,1)];                            %行移位
        ctext(3,:) = [ctext(3 , 3:4),ctext(3 , 1:2)];
        ctext(4,:) = [ctext(4,4),ctext(4,1:3)];
        if(i~=10)
            ctext=cmix(ctext);                    %列混合
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


function output = keyextend(k)
%KEYEXTEND 此处显示有关此函数的摘要
%   此处显示详细说明
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

