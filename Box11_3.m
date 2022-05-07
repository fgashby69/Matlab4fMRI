clear all; close all; clc;              % Clear all workspaces

ntime=6000;             % number of time points
T=600;                  % time interval in seconds
t=T*[0:ntime-1]/ntime;  % define time
sig=.07;                % noise standard deviation
lag=15;                 % mean number of sec between events

% Create the hrfs & plot
n=4; lamda=2; n2=7; lamda2=2; a=.3;
hrf=(t.^(n-1)).*exp(-t/lamda)/((lamda^n)*factorial(n-1));
h2=(t.^(n2-1)).*exp(-t/lamda2)/((lamda2^n2)*factorial(n2-1));
hrf2=(hrf-a*h2)/(sum(hrf-a*h2)*.1);
subplot(3,1,1); plot(t,hrf,t,hrf2); axis([0 25 -.02 .2]);
xlabel('time (secs)'); ylabel('h(t)');

% Create the boxcars
n=zeros(1,ntime); ev=ones(1,25); n(26:50)=ones(1,25); lag=10*lag;

for i=2:20
    C1=(i-1)*2*lag+round(2*lag*rand-lag); 
    n(C1+1:C1+25)=ev;
end;
n2=[zeros(1,3),n(1:5997)];

% Convolve hrf & boxcar 
B=conv(hrf,n)/10; B2=conv(hrf2,n2)/10;
B=B(1:ntime); B2=B2(1:ntime);

% Discretize to TR = 1 sec, add noise, then plot
for i=1:T
    BOLD(i)=B(i*10)+sig*randn; BOLD2(i)=B2(i*10)+sig*randn;
end;

tt=1:T;
subplot(3,1,2); plot(tt,BOLD,tt,BOLD2); axis([0 600 -.1 .5]);
xlabel('time (secs)'); ylabel('BOLD response');

[C12,freq]=mscohere(BOLD,BOLD2,[],[],[],[]);          % Compute coherence 

% freq runs from 0 to 1. Our sampling rate is ntime/T samples per sec.
% Nyquist rate is half this value. So in Hz, frequencies run from 0
% to one-half ntime/T.
freq=freq*ntime/(T*2);

subplot(3,1,3); plot(freq, C12); axis([0 .5 0 1]);     % Plot
xlabel('frequency (hz)'); ylabel('coherence');
