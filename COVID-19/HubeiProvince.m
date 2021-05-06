clear;clc;
Province = ["广东","山东","河南","四川","江苏",...
    "河北","湖南","安徽","湖北","浙江",...
    "广西","云南","江西","辽宁","福建",...
    "陕西","黑龙江","山西","贵州","重庆",...
    "吉林","甘肃","内蒙古","新疆","上海",...
    "北京","天津","海南","宁夏","青海","西藏"];
[InitData]=xlsread('PopData.xls'); 
[PopFlow]=xlsread('PopflowData.xls');
target=39;

for i = 9:9
    N = InitData(i,1);      %人口总数
    I = InitData(i,2);      %传染者
    R = InitData(i,3);      %康复者
    E = InitData(i,5);      %无症状
    S = N-I-R-E;            %易感者
    DI= InitData(i,6);      %累计感染者
    D=zeros(1,200);
    D(1)= InitData(i,4);    %死亡人数
    
    r = 15;                %感染者接触易感者的人数
    B = 0.05249;            %传染概率
    y = 0.154;              %恢复率概率
    p=1/7;                  %无症状转换为患者概率
    d=0.0675;               %死亡率

    T = 1:200;
    PopOut=zeros(1,200);
    Per_E=zeros(1,200);
    Hubei_Data=zeros(1,7);
     
    for j = 1:200
        if j<28 
            PopOut(j) = 192600;%春运期间湖北省日均输出客流量
        else
            PopOut(j) = 102000;%平常期间湖北省日均输出客流量
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
    
    Hubei_Data(1)=i;%省份名称
    Hubei_Data(2)=S(target);%未感染人数
    Hubei_Data(3)=DI(target);%累计感染人数
    Hubei_Data(4)=E(target);%无症状人数
    Hubei_Data(5)=I(target);%现存感染人数
    Hubei_Data(6)=R(target);%治愈人数
    Hubei_Data(7)=D(target);%死亡人数
    save('Hubei_Data.mat','Hubei_Data');

    Per_E(length(T))=E(length(T))/(S(length(T))+R(length(T)));
    save('Per_E.mat','Per_E');

    plot(T,S,T,I,T,R,T,D);grid on;
    xlabel('天');ylabel('人数')
    legend('易感者','传染者','康复者','死亡者')
 
    disp(['未感染人数：' num2str(round(S(target))) '人']);
    disp(['累计感染：' num2str(round(DI(target))) '人']);
    disp(['无症状人数：' num2str(round(E(target))) '人']);
    disp(['现存感染：' num2str(round(I(target))) '人']);
    disp(['治愈人数：' num2str(round(R(target))) '人']);
    disp(['死亡人数：' num2str(round(D(target))) '人']);
end