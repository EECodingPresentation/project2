function data=coding_control(data1,idx)
%% idxΪѡ���k����Կ��k��1��100
%ǰ30����Կ��RSA�㷨��
if(idx>=1&&idx<=30) 
    %% �������ݵ��ļ�data.txt
    fid=fopen("data.txt",'w');
    fprintf(fid,'%d',data1);
    sta=fclose(fid);
    
    %% ��ȡ��idx����Կ�Ͳ�����д��RSA_key.txt,RSA_public_key.txt,RSA_private_key.txt��
    %���ڼ��ܲ���������ֻ��Ҫ����RSA_key��RSA_public_key���ɡ�
    %RSA_key
    fid=fopen(strcat("./RSA_key/RSA_key",num2str(idx,'%02d'),".txt"),"r");
    RSA_key=fscanf(fid,'%s');
    sta=fclose(fid);
    fid=fopen('RSA_key.txt',"w");
    fprintf(fid,"%s",RSA_key);
    sta=fclose(fid);
    
    %RSA_public_key
    fid=fopen(strcat("./RSA_key/RSA_public_key",num2str(idx,'%02d'),".txt"),"r");
    RSA_public_key=fscanf(fid,'%s');
    sta=fclose(fid);
    fid=fopen('RSA_public_key.txt',"w");
    fprintf(fid,"%s",RSA_public_key);
    sta=fclose(fid);
    
    %% ִ��RSA_code.exe���򣬽����ݱ��浽����ciphertext.txt��
    status=dos("RSA_code.exe");
    
    %% �����Ķ��뵽data������
    fid=fopen("ciphertext.txt","r");
    data=fscanf(fid,"%s");
    data=data-'0';
    sta=fclose(fid);

elseif(idx >= 31 && idx <= 70)
    %% ��DES_key\DES_Key.m�ļ��ж�ȡ��Կ
    % 31~50ΪżУ�飬51~70Ϊ��У��
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
        data(index) = DESEncode(data1(index), DES_key(: , idx));
    end
    data = data';
end

end