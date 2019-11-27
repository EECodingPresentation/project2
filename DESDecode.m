% 传入64*1明文，以及64*1密钥，其中密钥的第8n位为奇偶校验位
% 输出DES解密后的明文
function M = DESDecode(DESCode, K)
    %% 获取子密钥KeyN
    % 压缩置换，去除奇偶校验位

    PC1 = [57; 49; 41; 33; 25; 17; 9; ...
        1; 58; 50; 42; 34; 26; 18; ...
        10; 2; 59; 51; 43; 35; 27; ...
        19; 11; 3; 60; 52; 44; 36; ...
        63; 55; 47; 39; 31; 23; 15; ...
        7; 62; 54; 46; 38; 30; 22; ...
        14; 6; 61; 53; 45; 37; 29; ...
        21; 13; 5; 28; 20; 12; 4];

    C0 = K(PC1(1: 28));
    D0 = K(PC1(29: 56));

    % 移位变换
    shiftBits = [1, 1, 2, 2, 2, 2, 2, 2, 1, 2, 2, 2, 2, 2, 2, 1];

    Cn = zeros(28, 16, 'double');
    Dn = zeros(28, 16, 'double');

    Cn(: , 1) = [C0(1+shiftBits(1): end); C0(1: shiftBits(1))];
    Dn(: , 1) = [D0(1+shiftBits(1): end); D0(1: shiftBits(1))];
    for index = 2: size(Cn, 2)
        Cn(: , index) = [Cn(1+shiftBits(index): end, index-1); ...
            Cn(1: shiftBits(index), index-1)];
        Dn(: , index) = [Dn(1+shiftBits(index): end, index-1); ...
            Dn(1: shiftBits(index), index-1)];
    end

    % 压缩得到最终子密钥
    PC2 = [14; 17; 11; 24; 1; 5; ...
        3; 28; 15; 6; 21; 10; ...
        23; 19; 12; 4; 26; 8; ...
        16; 7; 27; 20; 13; 2; ...
        41; 52; 31; 37; 47; 55; ...
        30; 40; 51; 45; 33; 48; ...
        44; 49; 39; 56; 34; 53; ...
        46; 42; 50; 36; 29; 32];

    tmp = [Cn; Dn];
    KeyN = tmp(PC2, :);
    
    %% 解密过程，只需要将解密密钥颠倒即可
    deKeyN = fliplr(KeyN);
    M = DESCoding(DESCode, deKeyN);
    
end

