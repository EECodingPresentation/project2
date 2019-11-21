%生成S盒
global s_box;
s_box=uint8(reshape((0:255),[16,16])');
s_box(1)=1;
%构造对数表
global alog;
global polylog;
alog=zeros(256,1);
alog(1)=1;
for i=2:256
    alog(i)=ploymulti(3,alog(i-1));
end
polylog=zeros(256,1);
for i=1:255
    polylog(alog(i))=i-1;
end
s_box=alog(256-polylog(s_box));
s_box(1)=0;
for i=1:256
    s_box(i)=bytetrans(s_box(i),99);
end
%构造逆S盒
global inv_s_box_i;
inv_s_box_i=zeros(16,16);
global s_box_i;
s_box_i=s_box';
for i=1:256
    inv_s_box_i(s_box_i(i)+1)=i-1;
end
inv_s_box=inv_s_box_i';



function output = ploymulti(a,b)
%PLOYMUTI 此处显示有关此函数的摘要
%   此处显示详细说明
    p=[1,0,0,0,1,1,0,1,1];
    a=dec2bin(a);
    a=double(a)-'0';
    b=dec2bin(b);
    b=double(b)-'0';
    q=mod(conv(a,b),2);
    [~,r]=deconv(q,p);
    r=mod(r,2);
    r=char(r+'0');
    output=bin2dec(r);
end


function output = bytetrans(a,x)
%BYTETRANS 此处显示有关此函数的摘要
%   此处显示详细说明
a=uint8(a);
x=uint8(x);
temp=zeros(1,8);
temp=uint8(temp);
for i=1:8
    temp(9-i)= (bitget(a,i))+(bitget(a,mod(i+3,8)+1))+(bitget(a,mod(i+4,8)+1))+(bitget(a,mod(i+5,8)+1))+(bitget(a,mod(i+6,8)+1))+(bitget(x,i)) ;
end
temp=mod(temp,2);
temp=char(temp+'0');
output=bin2dec(temp);
end
