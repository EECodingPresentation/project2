function ptext0 = AESDecoding(ctext0, k)
%输入要求：ctext0:待解密的数据比特比特串，行向量
%          k:128位密钥,行列向量都行
ptext0=[];
k = reshape(k, [8,16]);
k = char(k'+'0');
k = bin2dec(k);
k = reshape(k,[4,4]);
global inv_s_box_i;
AESpre;
%密钥扩展
W=keyextend(k);
%解密模块
l=length(ctext0);
N=floor(l/128);
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
        ptext(4,:) = [ptext(4 , 2:4),ptext(4,1)];                            %逆行移位
        ptext(3,:) = [ptext(3 , 3:4),ptext(3 , 1:2)];
        ptext(2,:) = [ptext(2,4),ptext(2,1:3)];
        ptext = inv_s_box_i(ptext+1);   %逆字节代换
        ptext=bitxor(ptext,W(:,i*4+1:i*4+4));
        if i~=0
            ptext=invcmix(ptext);       %逆列混合
        end
    end
    ptext=dec2bin(ptext,8);
    ptext = reshape(ptext', [1,128]);
    ptext = ptext - '0';
    ptext0=[ptext0,ptext];
end
end

function output = invcmix(input)
%CMIX 此处显示有关此函数的摘要
%   此处显示详细说明
a=zeros(4,4);
a(1,:)=bitxor(bitxor(AESlistmulti(input(1,:),14),AESlistmulti(input(2,:),11)),bitxor(AESlistmulti(input(3,:),13),AESlistmulti(input(4,:),9)));
a(2,:)=bitxor(bitxor(AESlistmulti(input(1,:),9),AESlistmulti(input(2,:),14)),bitxor(AESlistmulti(input(3,:),11),AESlistmulti(input(4,:),13)));
a(3,:)=bitxor(bitxor(AESlistmulti(input(1,:),13),AESlistmulti(input(2,:),9)),bitxor(AESlistmulti(input(3,:),14),AESlistmulti(input(4,:),11)));
a(4,:)=bitxor(bitxor(AESlistmulti(input(1,:),11),AESlistmulti(input(2,:),13)),bitxor(AESlistmulti(input(3,:),9),AESlistmulti(input(4,:),14)));
output=a;
end

