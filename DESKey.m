% 传入奇偶校验模式，0为偶校验，1为奇校验
% 返回生成的密钥64*1
function Key = DESKey(mode)
    K = round(rand(7, 8));
    tmp = mod(sum(K), 2);
    if mode == 1
        Key = [K; ~tmp];
    else
        Key = [K; tmp];
    end
    Key = reshape(Key, 64, 1);
end