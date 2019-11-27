function decode_bit = soft_viterbi(bitProb, eff, tail, holegap)
    %% 初始化
    len=size(bitProb, 2);
    decode_bit = zeros(1, len);
    num = 8;
    if eff==2
        G=[1,1,0,1;1,1,1,1;];%1/2效率
    elseif eff==3
        G=[1,0,1,1;1,1,0,1;1,1,1,1;];%1/3效率
    end
    G = fliplr(G);
    P = [4; 2; 1];
    if holegap > 2
        holes = ceil((len-1)/(holegap-1));
        dis = zeros(num, len + holes + 1);  % 记录距离
        pos = zeros(num, len + holes + 1);  % 记录路径
    else
        dis = zeros(num, len + 1);  % 记录距离
        pos = zeros(num, len + 1);  % 记录路径
    end
    
    dis(2: end, 1) = -Inf;
    dis(: , 2: end) = -Inf;
    
    Status = [0, 0, 0; 0, 0, 1; 0, 1, 0; 0, 1, 1; ...
        1, 0, 0; 1, 0, 1; 1, 1, 0; 1, 1, 1];
    trans = cell(num, 2);  % 状态转移的输出矩阵
    for i = 1: num
        s = Status(i, : )';
        for branch = 0: 1
            stmp = [s; branch];
            trans{i, branch + 1} = mod(G * stmp, 2);
        end
    end
    
    cnt = 0;
    %% viterbi译码
    for i = 1: length(pos) - 1
        if holegap > 2 && mod(i, holegap) == 2
            cnt = cnt + 1;
            for sNowNum = 1: num
                statusNow = Status(sNowNum, : );
                for branch = 0: 1
                    statusNext = [statusNow(2: 3), branch];
                    sNextNum = statusNext * P + 1;
                    if dis(sNowNum, i) > dis(sNextNum, i + 1)
                        dis(sNextNum, i + 1) = dis(sNowNum, i);
                        pos(sNextNum, i + 1) = sNowNum;
                    end
                end
            end
        else
            for sNowNum = 1: num
                statusNow = Status(sNowNum, : );

                for branch = 0: 1
                    statusNext = [statusNow(2: 3), branch];
                    sNextNum = statusNext * P + 1;
                    temp = trans{sNowNum, branch + 1};
                    temp(temp == 0) = -1;
                    hamming = temp.' * bitProb(: , i - cnt);
                    if dis(sNowNum, i) + hamming > dis(sNextNum, i + 1)
                        dis(sNextNum, i + 1) = dis(sNowNum, i) + hamming;
                        pos(sNextNum, i + 1) = sNowNum;
                    end
                end
            end
        end
    end
    
    %% 回溯求解最优路径
    if (tail)
        posEnd = 1;
    else
        [~, posEnd] = max(dis(: , end));
    end
    for i = length(pos): -1: 2
        decode_bit(i-1) = mod(posEnd - 1, 2);
        posEnd = pos(posEnd, i);
    end
    
end