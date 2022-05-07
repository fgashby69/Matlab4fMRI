clear all; close all; clc;                      % Clear all workspaces
ntime=2000; T=200; t=T*[0:ntime-1]/ntime;   	% define time
TR=2;                                       	% TR in seconds
TR=TR*ntime/T;

n=4; lamda=2;						% Create the hrf
hrf=(t.^(n-1)).*exp(-t/lamda)/((lamda^n)*factorial(n-1));

% Create the boxcar & BOLD response
box=ones(1,25); ISI=200; n=zeros(1,ntime); 
for i=1:8
    delay=ISI*(i-1)+geornd(.01);
    ntemp=[zeros(1,delay),box,zeros(1,ntime-delay-25)];
    n=n+ntemp;
end;
B=conv(hrf,n)/10; B=B(1:ntime);

% Order 1
X=[B(1:ntime-TR)]' ; Y=[B(TR+1:ntime)]';
A=(inv(X'*X))*X'*Y; P=X*A;
tt=(TR+1)*T/ntime:T/ntime:T;
subplot(3,1,1); plot(tt,Y,tt,P); axis([0 180 0 .5]);

% Order 2
X=[[B(TR+1:ntime-TR)]' [B(1:ntime-2*TR)]']; Y=[B(2*TR+1:ntime)]';
A=(inv(X'*X))*X'*Y 
P=X*A;
tt=(2*TR+1)*T/ntime:T/ntime:T;
subplot(3,1,2); plot(tt,Y,tt,P); axis([0 180 0 .5]);
ylabel('BOLD Response');

% Order 3
X=[[B(2*TR+1:ntime-TR)]' [B(TR+1:ntime-2*TR)]' [B(1:ntime-3*TR)]'];
Y=[B(3*TR+1:ntime)]'; A=(inv(X'*X))*X'*Y; P=X*A;
tt=(3*TR+1)*T/ntime:T/ntime:T;
subplot(3,1,3); plot(tt,Y,tt,P); axis([0 180 0 .5]);
xlabel('time (sec)');
