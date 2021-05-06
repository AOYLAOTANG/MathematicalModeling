clear;clc;
Province = ["�㶫","ɽ��","����","�Ĵ�","����",...
    "�ӱ�","����","����","����","�㽭",...
    "����","����","����","����","����",...
    "����","������","ɽ��","����","����",...
    "����","����","���ɹ�","�½�","�Ϻ�",...
    "����","���","����","����","�ຣ","����"];
[InitData]=xlsread('PopData.xls'); 
[PopFlow]=xlsread('PopflowData.xls');
target=39;

for i = 9:9
    N = InitData(i,1);      %�˿�����
    I = InitData(i,2);      %��Ⱦ��
    R = InitData(i,3);      %������
    E = InitData(i,5);      %��֢״
    S = N-I-R-E;            %�׸���
    DI= InitData(i,6);      %�ۼƸ�Ⱦ��
    D=zeros(1,200);
    D(1)= InitData(i,4);    %��������
    
    r = 15;                %��Ⱦ�߽Ӵ��׸��ߵ�����
    B = 0.05249;            %��Ⱦ����
    y = 0.154;              %�ָ��ʸ���
    p=1/7;                  %��֢״ת��Ϊ���߸���
    d=0.0675;               %������

    T = 1:200;
    PopOut=zeros(1,200);
    Per_E=zeros(1,200);
    Hubei_Data=zeros(1,7);
     
    for j = 1:200
        if j<28 
            PopOut(j) = 192600;%�����ڼ����ʡ�վ����������
        else
            PopOut(j) = 102000;%ƽ���ڼ����ʡ�վ����������
        end
    end
    
    for idx = 1:length(T)-1
        S(idx+1) = S(idx) - round(r*B*S(idx)*I(idx)/N);
        E(idx+1) = E(idx) + round(r*B*S(idx)*I(idx)/N)...
            - round(p*E(idx)) - round(PopOut(idx) * E(idx)/(S(idx)+R(idx)));
        I(idx+1) = I(idx) + round(p*E(idx)) - round(y*I(idx)) - round(d*p*E(idx));
        R(idx+1) = R(idx) + round(y*I(idx));
        DI(idx+1) = DI(idx) + round(p*E(idx));
        D(idx+1) = D(idx) + round(d*p*E(idx));
        Per_E(idx)=E(idx)/(S(idx)+R(idx));
    end
    
    Hubei_Data(1)=i;%ʡ������
    Hubei_Data(2)=S(target);%δ��Ⱦ����
    Hubei_Data(3)=DI(target);%�ۼƸ�Ⱦ����
    Hubei_Data(4)=E(target);%��֢״����
    Hubei_Data(5)=I(target);%�ִ��Ⱦ����
    Hubei_Data(6)=R(target);%��������
    Hubei_Data(7)=D(target);%��������
    save('Hubei_Data.mat','Hubei_Data');

    Per_E(length(T))=E(length(T))/(S(length(T))+R(length(T)));
    save('Per_E.mat','Per_E');

    plot(T,S,T,I,T,R,T,D);grid on;
    xlabel('��');ylabel('����')
    legend('�׸���','��Ⱦ��','������','������')
 
    disp(['δ��Ⱦ������' num2str(round(S(target))) '��']);
    disp(['�ۼƸ�Ⱦ��' num2str(round(DI(target))) '��']);
    disp(['��֢״������' num2str(round(E(target))) '��']);
    disp(['�ִ��Ⱦ��' num2str(round(I(target))) '��']);
    disp(['����������' num2str(round(R(target))) '��']);
    disp(['����������' num2str(round(D(target))) '��']);
end