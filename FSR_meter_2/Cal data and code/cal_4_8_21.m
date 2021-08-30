%% 
% yin gave me data in terms of kg according to the previous cal curve...
% so first need to transfer it back to kohm
load('cal_result_2_25_21.mat') %load workspace with the previous cal results
figure(1); clf; plot(x,y,x,yfit)
title('original cal from 2/21')
% yin gave me a list of measurements from a load cell and the FSR
% but the FSR measurements were in kg, not kohm!
% so first convert those back to kohm
cal_kg = [0 6.58 10.32 12.38 13.77 15.53 16.17 17.82 19.45 20.59 21.60 22.25 23.03 24.55 26.15 26.26 27.62 28.56 29.77 30.90 31.94 32.74 33.83 33.19 33.28];
cal_kg = cal_kg(2:end); %omit 0 measurement
% I'll use interpolation
% vq = interp1(x,v,xq)
x=[10:0.5:500]; %create dummy resistance data
y=polyval(p,1./x); %create dummy kg data using previous polynomial fit
figure(2); clf; plot(x,y)
title('curve used for interpolation')
% I'm trying to invert the fit, so I will swap x and y
yq = cal_kg; %query at the cal_kg points
xq = interp1(y,x,yq);
cal_kohm = xq;

%%
% now I have kohm data
% this is the load cell data yin gave me
cal_kg = [0 3.7 7.2 8.7 10.0 11.6 12.1 13.4 14.6 15.4 16.0 16.7 17.2 18.4 19.00 19.3 20.4 21.2 22.2 23.3 24.00 25.1 26.1 27.0 28.0];
cal_kg = cal_kg(2:end); %omit 0 measurement
% return;
% the load cell kg measurements from the same expe


% cal_kohm=   [   129.0,  65.6,   58.9,   53.3,   47.9,   46.2,   43.33,  38.29,  35.14,  33.56,  28.5,   23.8,   20.75,  18.6,   17.13,  16.02,  14.73,  13.76];
% cal_kg=     [   9.1,    13.8,   14.9,   16.6,   18.0,   18.8,   20.1,   22.8,   25.6,   26.1,   30.6,   36.9,   42.9,   46.5,   53.5,   58.4,   64.8,   71.4];

x=cal_kohm(1:end);
y=cal_kg(1:end);
% x=1./x;
n=4;
pnew = polyfit(1./x,y,n);
yfit = polyval(pnew,1./x);

% yfit = p1*x^n + p2*x^(n-1) + .... pn*x + pn+1

figure(3); clf; plot(x,y,x,yfit)
title('new cal')
% figure(1);
return;
p2 = [2.8373e6, -4.0202e5, 2.2768e4, 291.58,5.4305];
n=4;
cal_in=46.2;
cal_out=0;
% for k=1:n+1
%     cal_out=cal_out+p2(k)*(1/cal_in)^(n-k+1);
%     disp(p2(k))
%     disp(n-k+1)
% end
% cal_out

for k=0:n
    cal_out=cal_out+p2(k+1)*(1/cal_in)^(n-k);
    disp(p2(k+1))
    disp(n-k+1+1)
end
cal_out
