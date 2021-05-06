y=[40 41 42 43 44 45 46 47];
x=[45 62 121 198 270 375 444 549];

y1=[1 2 3 4 5 6 7 8];


f=fittype('exp(a*t)','independent','t','coefficients',{'a'});
cfun=fit(y1',x',f)

% plot(x,y,'g*');
% hold on
% b=polyfit(x,y,1);
% 
% yy=polyval(b,x);
% plot(x,yy,'r-')