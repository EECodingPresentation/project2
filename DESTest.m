clear all;
close all;
clc;

M = round(rand(64, 1));

DES_key = zeros(64, 40, 'double');
for i = 1: 20
    DES_key(:, i) = DESKey(0);
    DES_key(:, i+20) = DESKey(1);
end
save('DES_key\DES_key.mat', 'DES_key');

Key = DESKey(1);

DESCode = DESEncode(M, Key);

M1 = DESDecode(DESCode, Key);
Res1 = (M1 ~= M);
disp(["Res1:", num2str(sum(Res1(:)))]);

index = randi(length(Key));

Key(index) = ~Key(index);

M2 = DESDecode(DESCode, Key);
Res2 = (M2 ~= M);
disp(["Res2:", num2str(sum(Res2(:)))]);

tic;
for i = 1: 128
    M = round(rand(64, 1));

    Key = DESKey(1);

    DESCode = DESEncode(M, Key);

    M1 = DESDecode(DESCode, Key);
end
t = toc;