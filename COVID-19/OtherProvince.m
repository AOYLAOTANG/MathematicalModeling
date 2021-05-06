clear;clc;
Province = ["广东","山东","河南","四川","江苏",...
    "河北","湖南","安徽","湖北","浙江",...
    "广西","云南","江西","辽宁","福建",...
    "陕西","黑龙江","山西","贵州","重庆",...
    "吉林","甘肃","内蒙古","新疆","上海",...
    "北京","天津","海南","宁夏","青海","西藏"];
[InitData]=xlsread('PopData.xls'); 
[PopFlow]=xlsread('PopflowData.xls'); 
Per_E=load('Per_E.mat');Per_E=Per_E.Per_E;
Hubei_Data=load('Hubei_Data.mat');Hubei_Data=Hubei_Data.Hubei_Data;

target=39;%需要计算的日期离1.23日的天数
China_Data=zeros(31,7);

file=fopen('result.txt','w');

for i = 1:31
    if i==9 %直接导入湖北省数据
        China_Data(i,:)=Hubei_Data;
        continue;
    end
    N = InitData(i,1);      %人口总数
    I = InitData(i,2);      %传染者
    R = InitData(i,3);      %康复者
    E = InitData(i,5);      %无症状
    S = N-I-R-E;            %易感者
    DI= InitData(i,6);      %累计感染者
    D=zeros(1,200);
    D(1)= InitData(i,4);    %死亡人数
    
    r = 15;                 %感染者接触易感者的人数
    B = 0.05249;            %传染概率
    y = 0.154;              %恢复率概率
    p=1/7;                  %无症状转换为患者概率
    d=0.0675;               %死亡率

    T = 1:200;
    PopIn=zeros(1,200);
    
    for j = 1:200
        if j<28
            PopIn(j) = 192600 * PopFlow(i,j);%春运期间湖北省日均输入到该省客流量
        elseif j<39
            PopIn(j) = 102000 * PopFlow(i,j);%平常期间湖北省日均输入到该省客流量
        else
            PopIn(j) = 102000 * PopFlow(i,40);%平常期间湖北省日均输入到该省客流量
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
        China_Data(i,1)=i;%省份名称
        China_Data(i,2)=S(target);%未感染人数
        China_Data(i,3)=DI(target);%累计感染人数
        China_Data(i,4)=E(target);%无症状人数
        China_Data(i,5)=I(target);%现存感染人数
        China_Data(i,6)=R(target);%治愈人数
        China_Data(i,7)=D(target);%死亡人数
    end
    
    if i==1||i==3||i==7||i==9||i==10
        figure,
        plot(T,S,T,I,T,R,T,D);grid on;
        xlabel('天');ylabel('人数')
        legend('易感者','传染者','康复者','死亡者')
        title(Province(i));
    end
  
    fprintf(file,'%s\r\n',Province(i));
    fprintf(file,'未感染人数：%d\r\n',round(S(target)));
    fprintf(file,'累计感染人数：%d\r\n',round(DI(target)));
    fprintf(file,'无症状人数：%d\r\n',round(E(target)));
    fprintf(file,'现存感染人数：%d\r\n',round(I(target)));
    fprintf(file,'治愈人数：%d\r\n',round(R(target)));
    fprintf(file,'死亡人数：%d\r\n\r\n',round(D(target)));
end

res=sortrows(China_Data,3);
total=sum(res);
cost=total(3)*23000+total(7)*70892;

fprintf('截至3月1日中国大陆疫情情况\n');
disp(['疫情所造成的经济损失约：' num2str(cost) '元']);
disp(['未感染人数：' num2str(total(2)) '人']);
disp(['累计感染：' num2str(total(3)) '人']);
disp(['无症状人数：' num2str(total(4)) '人']);
disp(['现存感染：' num2str(total(5)) '人']);
disp(['治愈人数：' num2str(total(6)) '人']);
disp(['死亡人数：' num2str(total(7)) '人']);
fprintf('\n');

disp('最严重的五个省市区：');
for i=1:5
    fprintf('%d.%s\n',i,Province(res(32-i,1)));
    disp(['未感染人数：' num2str(res(32-i,2)) '人']);
    disp(['累计感染：' num2str(res(32-i,3)) '人']);
    disp(['无症状人数：' num2str(res(32-i,4)) '人']);
    disp(['现存感染：' num2str(res(32-i,5)) '人']);
    disp(['治愈人数：' num2str(res(32-i,6)) '人']);
    disp(['死亡人数：' num2str(res(32-i,7)) '人']);
    fprintf('\n');
end
