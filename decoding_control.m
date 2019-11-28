function data=decoding_control(data1,idx)
%% idx为选择第k对秘钥，k从1到100
%前30对秘钥是RSA算法的
if(idx>=1&&idx<=30) 
    %% 发送数据到文件ciphertext.txt
    fid=fopen("ciphertext.txt",'w');
    fprintf(fid,'%d',data1);
    sta=fclose(fid);
    
    %% 读取第idx对秘钥和参数，写到RSA_key.txt,RSA_public_key.txt,RSA_private_key.txt中
    %对于解密操作，我们只需要读入RSA_key和RSA_private_key即可。
    %RSA_key
    fid=fopen(strcat("./RSA_key/RSA_key",num2str(idx,'%02d'),".txt"),"r");
    RSA_key=fscanf(fid,'%s');
    sta=fclose(fid);
    fid=fopen('RSA_key.txt',"w");
    fprintf(fid,"%s",RSA_key);
    sta=fclose(fid);
    
    %RSA_private_key
    fid=fopen(strcat("./RSA_key/RSA_private_key",num2str(idx,'%02d'),".txt"),"r");
    RSA_private_key=fscanf(fid,'%s');
    sta=fclose(fid);
    fid=fopen('RSA_private_key.txt',"w");
    fprintf(fid,"%s",RSA_private_key);
    sta=fclose(fid);
    
    %% 执行RSA_decode.exe程序，将数据保存到plaintext.txt中
    status=dos("RSA_decode.exe");
    
    %% 将密文读入到data并返回
    fid=fopen("plaintext.txt","r");
    data=fscanf(fid,"%s");
    data=data-'0';
    sta=fclose(fid);
    
elseif(idx >= 31 && idx <= 70)
    %% 从DES_key\DES_Key.m文件中读取密钥
    % 31~50为偶校验，51~70为奇校验
    load('DES_key\DES_key.mat');
    idx = idx - 30;
    blocks = ceil(length(data1) / 64);
    if blocks*64 > length(data1)
        data1 = [data1, zeros(1, blocks*64 - length(data1))]';
    else
        data1 = data1';
    end
    data = zeros(blocks*64, 1, 'double');
    for b = 1: blocks
        index = (b-1)*64+1: b*64;
        data(index) = DESDecode(data1(index), DES_key(: , idx));
    end
    data = data';
end

end