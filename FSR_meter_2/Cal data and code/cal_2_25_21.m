cal_kohm=   [   129.0,  65.6,   58.9,   53.3,   47.9,   46.2,   43.33,  38.29,  35.14,  33.56,  28.5,   23.8,   20.75,  18.6,   17.13,  16.02,  14.73,  13.76];
cal_kg=     [   9.1,    13.8,   14.9,   16.6,   18.0,   18.8,   20.1,   22.8,   25.6,   26.1,   30.6,   36.9,   42.9,   46.5,   53.5,   58.4,   64.8,   71.4];

x=cal_kohm(1:end);
y=cal_kg(1:end);
% x=1./x;
n=4;
p = polyfit(1./x,y,n);
yfit = polyval(p,1./x);

% yfit = p1*x^n + p2*x^(n-1) + .... pn*x + pn+1

figure(1); clf; plot(x,y,x,yfit)

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
