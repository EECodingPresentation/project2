function bitProb = soft_judge(channelres, bitmode, eff)
    G1 = [1, 0];
    G2 = [0, 0, 1, 1; 0, 1, 1, 0];%1/2效率
    G3 = [0, 0, 0, 0, 1, 1, 1, 1; 0, 0, 1, 1, 1, 1, 0, 0; ...
        0, 1, 1, 0, 0, 1, 1, 0];%1/3效率
%     %% 分情况，是否已知Phi角
%     if knownPhi
%         channelres = channelres .* exp(-1j*phi);
%     else
%         channelres = channelres .* exp(-1j*theta/2);
%     end
    %% 硬判决划分为bit
    switch bitmode
        case 1
            prob = calculateProbability(channelres, bitmode);
            bitProb(1, : ) = (prob * G1.').' - (prob * ~G1.').';
        case 2
            prob = calculateProbability(channelres, bitmode);
            bitProb = zeros(2, size(prob, 1));
            bitProb(2, : ) = (prob * G2(2, : ).').' - (prob * ~G2(2, : ).').';
            bitProb(1, : ) = (prob * G2(1, : ).').' - (prob * ~G2(1, : ).').';            
        case 3
            prob = calculateProbability(channelres, bitmode);
            bitProb = zeros(3, size(prob, 1));
            bitProb(3, : ) = (prob * G3(3, : ).').' - (prob * ~G3(3, : ).').';
            bitProb(2, : ) = (prob * G3(2, : ).').' - (prob * ~G3(2, : ).').';
            bitProb(1, : ) = (prob * G3(1, : ).').' - (prob * ~G3(1, : ).').';
        otherwise
            error('invalid bitmode!');
    end
    bitProb = reshape(bitProb, eff, size(bitProb, 1)*size(bitProb, 2)/eff);
end