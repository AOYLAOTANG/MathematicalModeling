clear;clc;
Province = ["�㶫","ɽ��","����","�Ĵ�","����",...
    "�ӱ�","����","����","����","�㽭",...
    "����","����","����","����","����",...
    "����","������","ɽ��","����","����",...
    "����","����","���ɹ�","�½�","�Ϻ�",...
    "����","���","����","����","�ຣ","����"];
[InitData]=xlsread('PopData.xls'); 
[PopFlow]=xlsread('PopflowData.xls'); 
Per_E=load('Per_E.mat');Per_E=Per_E.Per_E;
Hubei_Data=load('Hubei_Data.mat');Hubei_Data=Hubei_Data.Hubei_Data;

target=39;%��Ҫ�����������1.23�յ�����
China_Data=zeros(31,7);

file=fopen('result.txt','w');

for i = 1:31
    if i==9 %ֱ�ӵ������ʡ����
        China_Data(i,:)=Hubei_Data;
        continue;
    end
    N = InitData(i,1);      %�˿�����
    I = InitData(i,2);      %��Ⱦ��
    R = InitData(i,3);      %������
    E = InitData(i,5);      %��֢״
    S = N-I-R-E;            %�׸���
    DI= InitData(i,6);      %�ۼƸ�Ⱦ��
    D=zeros(1,200);
    D(1)= InitData(i,4);    %��������
    
    r = 15;                 %��Ⱦ�߽Ӵ��׸��ߵ�����
    B = 0.05249;            %��Ⱦ����
    y = 0.154;              %�ָ��ʸ���
    p=1/7;                  %��֢״ת��Ϊ���߸���
    d=0.0675;               %������

    T = 1:200;
    PopIn=zeros(1,200);
    
    for j = 1:200
        if j<28
            PopIn(j) = 192600 * PopFlow(i,j);%�����ڼ����ʡ�վ����뵽��ʡ������
        elseif j<39
            PopIn(j) = 102000 * PopFlow(i,j);%ƽ���ڼ����ʡ�վ����뵽��ʡ������
        else
            PopIn(j) = 102000 * PopFlow(i,40);%ƽ���ڼ����ʡ�վ����뵽��ʡ������
        end
    end
    
    for idx = 1:length(T)-1
        S(idx+1) = S(idx) - round(r*B*S(idx)*I(idx)/N) + round(PopIn(idx)*(1-Per_E(idx)));
        E(idx+1) = E(idx) + round(r*B*S(idx)*I(idx)/N) - round(p*E(idx)) + round(PopIn(idx)*Per_E(idx));
        I(idx+1) = I(idx) + round(p*E(idx)) - round(y*I(idx)) - round(d*p*E(idx));
        R(idx+1) = R(idx) + round(y*I(idx));
        DI(idx+1) = DI(idx) + round(p*E(idx));
        D(idx+1) = D(idx) + round(d*p*E(idx));
    end
    
    for k=1:7
        China_Data(i,1)=i;%ʡ������
        China_Data(i,2)=S(target);%δ��Ⱦ����
        China_Data(i,3)=DI(target);%�ۼƸ�Ⱦ����
        China_Data(i,4)=E(target);%��֢״����
        China_Data(i,5)=I(target);%�ִ��Ⱦ����
        China_Data(i,6)=R(target);%��������
        China_Data(i,7)=D(target);%��������
    end
    
    if i==1||i==3||i==7||i==9||i==10
        figure,
        plot(T,S,T,I,T,R,T,D);grid on;
        xlabel('��');ylabel('����')
        legend('�׸���','��Ⱦ��','������','������')
        title(Province(i));
    end
  
    fprintf(file,'%s\r\n',Province(i));
    fprintf(file,'δ��Ⱦ������%d\r\n',round(S(target)));
    fprintf(file,'�ۼƸ�Ⱦ������%d\r\n',round(DI(target)));
    fprintf(file,'��֢״������%d\r\n',round(E(target)));
    fprintf(file,'�ִ��Ⱦ������%d\r\n',round(I(target)));
    fprintf(file,'����������%d\r\n',round(R(target)));
    fprintf(file,'����������%d\r\n\r\n',round(D(target)));
end

res=sortrows(China_Data,3);
total=sum(res);
cost=total(3)*23000+total(7)*70892;

fprintf('����3��1���й���½�������\n');
disp(['��������ɵľ�����ʧԼ��' num2str(cost) 'Ԫ']);
disp(['δ��Ⱦ������' num2str(total(2)) '��']);
disp(['�ۼƸ�Ⱦ��' num2str(total(3)) '��']);
disp(['��֢״������' num2str(total(4)) '��']);
disp(['�ִ��Ⱦ��' num2str(total(5)) '��']);
disp(['����������' num2str(total(6)) '��']);
disp(['����������' num2str(total(7)) '��']);
fprintf('\n');

disp('�����ص����ʡ������');
for i=1:5
    fprintf('%d.%s\n',i,Province(res(32-i,1)));
    disp(['δ��Ⱦ������' num2str(res(32-i,2)) '��']);
    disp(['�ۼƸ�Ⱦ��' num2str(res(32-i,3)) '��']);
    disp(['��֢״������' num2str(res(32-i,4)) '��']);
    disp(['�ִ��Ⱦ��' num2str(res(32-i,5)) '��']);
    disp(['����������' num2str(res(32-i,6)) '��']);
    disp(['����������' num2str(res(32-i,7)) '��']);
    fprintf('\n');
end
