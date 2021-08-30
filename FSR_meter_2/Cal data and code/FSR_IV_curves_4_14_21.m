V=zeros(2,6);
I=zeros(2,6);
Vfit=[0:0.1:5];
Ifit=zeros(2,length(Vfit));

V(1,:)=(0:1:5);
I(1,:)=[0 3.35 7.84 13.47 20.1 27.61];
V(2,:)=(0:1:5);
I(2,:)=[0 19.3 , 44.6, 75.4, 110.5, 151];
figure(1); clf; plot(V(1,:),I(1,:),V(2,:),I(2,:))
xlabel('Vfsr (V)'); ylabel('Ifsr (uA)'); grid on;

n=2;
p1 = polyfit(squeeze(V(1,:)),squeeze(I(1,:)),n);
p2 = polyfit(squeeze(V(2,:)),squeeze(I(2,:)),n);
Ifit(1,:)=polyval(p1,Vfit);
Ifit(2,:)=polyval(p2,Vfit);

figure(2); clf; plot(V(1,:),I(1,:),Vfit,Ifit(1,:))

figure(3); clf; plot(V(1,:),I(1,:),Vfit,Ifit(1,:),V(2,:),I(2,:),Vfit,Ifit(2,:))

figure(3); clf; 
scatter(V(1,:),I(1,:),'s');
hold on
scatter(V(2,:),I(2,:),'s');
plot(Vfit,Ifit(1,:));
plot(Vfit,Ifit(2,:));
hold off;
txt1=sprintf('I=%.3f*v^2%+.3f*v%+.3f',p1(1),p1(2),p1(3));
th1=text(2.5,32,txt1)
txt2=sprintf('I=%.3f*v^2%+.3f*v%+.3f',p2(1),p2(2),p2(3));
th2=text(0.5,90,txt2)
xlabel('Vfsr (V)'); ylabel('Ifsr (uA)'); grid on;
return;
norm=p1(2);
txt1=sprintf('I=%.3f*v^2%+.3f*v%+.3f',p1(1)/norm,p1(2)/norm,p1(3)/norm);
txt2=sprintf('I=%.3f*v^2%+.3f*v%+.3f',p2(1)/norm,p2(2)/norm,p2(3)/norm);
% xlabel('Vfsr (V)'); ylabel('Ifsr (uA)'); grid on;

% yfit = polyval(pnew,1./x);

% y=polyval(p,1./x); %create dummy kg data using previous polynomial fit