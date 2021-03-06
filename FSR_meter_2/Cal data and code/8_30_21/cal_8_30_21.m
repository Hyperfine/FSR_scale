%% 
%%
% now I have kohm data
% this is the load cell data yin gave me
dat=xlsread('FSR VS load (100kg).xlsx');

cal_kg=dat(:,2);
cal_kohm=dat(:,1);

% cal_kg = [  7       8.3     8.5     9.4     10      10.7    11.3    12.5    13.2    14.5    15.2    16.6    18.1    18.9...
%             20.1    21.6    23.2    24.8    26.0    27.6    28.7    30.2    31.4    33.2    35.3    37.2    39.5    42.3....
%             44.6    46.8    49.6    52.1    53.7    57.4    59.4    62.0    64.9    67.7    71.2    73.3];
%         
% cal_kohm =[ 2537    1553    1183.6  910.1   869.3   737.8   640.0   504.7   467.1   389.2   373.5   326.8   290.0   272.3...
%             249.2   226.5   209.9   195.4   184.6   173.0   166.0   157.9   151.9   145.0   141.1   137.4   132.8   129.3...
%             125.11  121.08  119.19  117.32  115.5   111.15  109.49  106.55  104.76  102.52  100.35  98.95];
%  
        cal_kohm=cal_kohm/1;       
figure(1); clf; plot(cal_kohm,cal_kg)

cal_start=1; cal_end=length(cal_kg);

cal_kg_0=cal_kg;
cal_kohm_0=cal_kohm;
cal_kg=cal_kg(cal_start:cal_end);
cal_kohm=cal_kohm(cal_start:cal_end);

figure(1); clf; plot(cal_kohm,cal_kg)
        
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
% [pnew, S, mu] = polyfit(1./x,y,n);
% yfit = polyval(pnew,1./x,[],mu);

% yfit = p1*x^n + p2*x^(n-1) + .... pn*x + pn+1

figure(3); clf; 
subplot(3,1,1)
plot(x,y,x,yfit)
title('new cal')
xlabel('kohm')
ylabel('kg')
subplot(3,1,2)
plot(y,y,y,yfit)
legend('ref','fit','Location','SouthEast')
xlabel('measured kg')
ylabel('kg')
subplot(3,1,3)
plot(y,yfit-y)
xlabel('measured kg')
ylabel('error kg')


% return;
% figure(4); clf; plot(x,yfit-y)
% figure(4); clf; plot(y,yfit-y)
% title('error')

x=cal_kohm_0(1:end);
y=cal_kg_0(1:end);
% yfit_0 = polyval(pnew,1./x,[],mu);
yfit_0 = polyval(pnew,1./x);

figure(4); clf; 
subplot(2,1,1)
plot(x,y,x,yfit_0)
title('new cal')
xlabel('kohm')
ylabel('kg')
subplot(2,1,2)
plot(y,yfit_0-y)
ylabel('error')
% figure(1);
xlabel('kohm')
ylabel('kg error')

arduino_code_string = sprintf('float p[5] = {%e, %e, %e, %e, %e};',pnew(1),pnew(2),pnew(3),pnew(4),pnew(5));
disp(arduino_code_string)
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
