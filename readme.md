## 文件目录
用到的代码按照先文件夹、后文件的方式排序，文件或文件夹索引按字母升序排序。  
类别包含:通信系统(不含加解密)、RSA、AES、DES
|文件/文件夹|类别|作用|
|--|--|--|
|/AES_key|AES|AES30对密钥的存储，对应71-100|
|/DES_key|DES|DES40对密钥的存储，对应31-69|
|/prime|RSA|Java程序，生成100个长度为128bit的质数，保存在prime.txt中|
|/RSA_key|RSA|RSA密钥30对，由main.m中选择第k对，对应1-30|
|AESCoding.m|AES|AES加密|
|AESDecoding.m|AES|AES解密|
|AESlistmulti.m|AES|用查表法算扩域乘法|
|AESpre.m|AES|AES预处理|
|bign.h|RSA|高精度模板|
|calculateProbability.m|通信系统|为软判决计算概率|
|channel2.m|通信系统|信道|
|channel3.m|通信系统|绘图程序，绘制Eb/n0|
|checkinp.m|通信系统|根号升余弦组件|
|ciphertext.txt|RSA|密文文件，RSA_code.exe运行得到，作为RSA_decode.exe调用的输入|
|coding_control.m|通信系统|选择第k对密钥对，对原文加密得到密文|
|data.txt|RSA|待加密原文|
|decoding_congtrol.m|通信系统|选择第k对密钥对，对密文解密得到原文|
|DESCoding.m|DES|DES加密函数|
|DESDecode.m|DES|DES解密|
|DESEncode.m|DES|DES加密|
|DESKey.m|DES|DES生成密钥|
|DESTest.m|DES|DES测试程序|
|Eb_n0_pb.m|通信系统|绘制Eb/n0与误码率关系曲线|
|error_map.m|通信系统|绘制误码图案|
|hard_judge.m|通信系统|硬判决判决|
|hard_viterbi.m|通信系统|硬判决译码|
|main.m|通信系统|通信系统主程序，模拟整个通信系统，包含加解密、调制解调、电平映射、成型滤波、信道、判决、译码等|
|model_conv.m|通信系统|卷积编码|
|model_map.m|通信系统|电平映射|
|plaintext.txt|RSA|解密明文，运行RSA_decode.exe得到|
|prime.txt|RSA|100个质数文件|
|rcosfir.m|通信系统|根号升余弦所需组件|
|RSA_code.cpp|RSA|RSA加密源程序|
|RSA_code.exe|RSA|RSA加密|
|RSA_creator.cpp|RSA|RSA密钥生成源程序|
|RSA_creator.exe|RSA|RSA密钥生成|
|RSA_decode.cpp|RSA|RSA解密源程序|
|RSA_decode.exe|RSA|RSA解密|
|RSA_key.txt|RSA|RSA的n|
|RSA_private_key.txt|RSA|RSA的e，私钥|
|RSA_public_key.txt|RSA|RSA的d,公钥|
|soft_judge.m|通信系统|软判决判决|
|soft_viterbi.m|通信系统|软判决译码|
|sourcedata.m|通信系统|原文生成程序|


### 生成大质数
> 文件夹:/prime  
用Java的IDE运行其中的代码，则会在与prime文件夹同目录的位置生成文件prime.txt。  
内容:prime.txt包含了100行数据，每行是一个1024bit的大质数。

### 高精度
> 文件:bign.cpp  
内容:封装了高精度整数的加、减、乘、除、取模等运算。目前采用文件读写封装了一个高精度整数乘法。  


### RSA密钥对
>文件夹:/RSA_key  
保存了30对RSA密钥，由coding_control.m选择密钥对。
