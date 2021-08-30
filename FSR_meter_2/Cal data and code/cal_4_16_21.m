%% 
%%
% now I have kohm data
% this is the load cell data yin gave me
cal_kg = [  4.9     6.3     7.9     8.9     9.7     10.9    11.5    12.6    13.4    14.5    15.7    16.4    17.6    18.3...
            19.0    19.6    20.5    21.4    22.3    23.4    24.5    25.5    27.0    28.0    29.7    31.1    32.0    33.2...
            34.5    35.5    36.7    37.4    38.0    41.2    43.5    44.6    47.1    50.3];
        
cal_kohm =[ 223.57  154.87  112.86  93.04   84.39   77.90   70.53   63.85   61.10   56.63   53.86   50.31   47.95   46.63...
            44.75   43.94   42.57   40.71   38.63   37.15   35.9    34.13   32.78   31.67   30.77   29.78   27.61   26.82...
            25.98   25.57   24.97   24.48   24.09   23.26   22.63   22.01   21.00   20.03];
        
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

% figure(4); clf; plot(x,yfit-y)
figure(4); clf; plot(y,yfit-y)
title('error')
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
