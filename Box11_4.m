clear all; close all; clc;          %Clear all workspaces
 
ntime=3000;                 % number of time points
T=300;                          % time interval in seconds
t=T*[0:ntime-1]/ntime;      % define time
 
% Define the time axis and the hrf 
t25=0:.1:T; T0=0; n=4; lamda=2;
hrf=((t25-T0).^(n-1)).*exp(-(t25-T0)/lamda)/((lamda^n)*factorial(n-1));
 
% Define and plot the boxcars
box=zeros(1,3001); ev=ones(1,20); 
box(1,1:20)=ev; box(1,201:220)=ev; box(1,341:360)=ev; box(1,441:460)=ev; box(1,541:560)=ev; box(1,741:760)=ev; box(1,901:920)=ev; box(1,1041:1060)=ev; box(1,1161:1180)=ev; box(1,1301:1320)=ev; box(1,1481:1500)=ev; box(1,1581:1600)=ev; box(1,1761:1780)=ev; box(1,1881:1900)=ev; box(1,1981:2000)=ev; box(1,2081:2100)=ev; box(1,2181:2200)=ev; box(1,2261:2280)=ev; box(1,2381:2400)=ev; box(1,2481:2500)=ev;
 
% Convolve the hrf and boxcar
BS=conv(hrf,box)/10; B1=[zeros(1,5),BS(1:5996)]; B2=B1;
 
% Discretize the predicted BOLD response (i.e., in the vector N) & plot
for i=1:150
    BOLDS(i)=BS(i*20); BOLD1(i)=B1(i*20)+.05*randn; BOLD2(i)=B2(i*20)+.05*randn;
end;
tt=2:2:T;
subplot(2,1,1);
plot(tt,BOLD1); hold on; plot(tt,BOLD2); axis([0 280 -.15 .45]); xlabel('time (sec)');
ylabel('BOLD response');
 
% Compute partial coherence when there is no further influence between 1 & 2
[C12wo,freq]=mscohere(BOLD1,BOLD2,[],[]);           
[C13wo,freq]=mscohere(BOLD1,BOLDS,[],[]);
[C23wo,freq]=mscohere(BOLD2,BOLDS,[],[]);
Q12wo=abs(sqrt(C12wo)); Q13wo=abs(sqrt(C13wo)); Q23wo=abs(sqrt(C23wo));
C12dot3wo=(Q12wo-Q13wo.*Q23wo).^2./((1-C13wo).*(1-C23wo));
freq=freq*ntime/(T*2);
subplot(2,1,2); plot(freq, C12dot3wo); axis([0 .5 0 1]); xlabel('frequency (hz)'); 
ylabel('partial coherence'); figure;
 
BOLD1W=.7*BOLD1+.3*BOLD2;
BOLD2W=.3*BOLD1+.7*BOLD2;
 
subplot(2,1,1); plot(tt,BOLD1W); hold on; plot(tt,BOLD2W); axis([0 280 -.15 .45]);
xlabel('time (sec)'); ylabel('BOLD response');
 
[C12w,freq]=mscohere(BOLD1W,BOLD2W,[],[],[],[]);           
[C13w,freq]=mscohere(BOLD1W,BOLDS,[],[],[],[]);
[C23w,freq]=mscohere(BOLD2W,BOLDS,[],[],[],[]);
Q12w=abs(sqrt(C12w)); Q13w=abs(sqrt(C13w)); Q23w=abs(sqrt(C23w));
C12dot3w=(Q12w-Q13w.*Q23w).^2./((1-C13w).*(1-C23w));
freq=freq*ntime/(T*2);
subplot(2,1,2); plot(freq, C12dot3w); axis([0 .5 0 1]); xlabel('frequency (hz)');
ylabel('partial coherence');