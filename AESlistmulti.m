function output = AESlistmulti(a,b)
global alog;
global polylog;
% if (a==0 || b ==0)
%     output=0;
%     return
% end
a1=(a==0);
b1=(b==0);
a(a1)=1;
b(b1)=1;
output = (alog(mod(polylog(a)+polylog(b),255)+1))';
output (a1|b1)=0;
end

