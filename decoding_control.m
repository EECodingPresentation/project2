function data=decoding_control(data1,idx)
%% idxΪѡ���k����Կ��k��1��100
%ǰ30����Կ��RSA�㷨��
if(idx>=1&&idx<=30) 
    %% �������ݵ��ļ�ciphertext.txt
    fid=fopen("ciphertext.txt",'w');
    fprintf(fid,'%d',data1);
    sta=fclose(fid);
    
    %% ��ȡ��idx����Կ�Ͳ�����д��RSA_key.txt,RSA_public_key.txt,RSA_private_key.txt��
    %���ڽ��ܲ���������ֻ��Ҫ����RSA_key��RSA_private_key���ɡ�
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
    
    %% ִ��RSA_decode.exe���򣬽����ݱ��浽plaintext.txt��
    status=dos("RSA_decode.exe");
    
    %% �����Ķ��뵽data������
    fid=fopen("plaintext.txt","r");
    data=fscanf(fid,"%s");
    data=data-'0';
    sta=fclose(fid);
end

end