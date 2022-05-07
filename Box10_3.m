clear all; close all; clc;                  		% Clear all workspaces
ntime=2000; T=200; t=T*[0:ntime-1]/ntime;   	    % define time
TR=2; TR=TR*ntime/T;                        		% TR in seconds
lag=1; lag=lag*ntime/T;                     		% ny lag in seconds

n=4; lamda=2;                               		% Create the hrf
hrf=(t.^(n-1)).*exp(-t/lamda)/((lamda^n)*factorial(n-1));

box=ones(1,10); ISI=250; sig=.001;

% Create the boxcars & BOLD responses
% Region 3
n3=zeros(1,ntime); 
for i=1:7
    delay=ISI*(i-1)+geornd(.01); E(i)=delay+1;
    ntemp=[zeros(1,delay),box,zeros(1,ntime-delay-10)];
    n3=n3+ntemp;
end;
B3=conv(hrf,n3)/10; B3=B3(1:ntime)+normrnd(0,sig,1,ntime);

% Region 1
n1=zeros(1,ntime); 
for i=1:7
    delay=E(i)+geornd(.01); 
    ntemp=[zeros(1,delay),box,zeros(1,ntime-delay-10)];
    n1=n1+ntemp;
end;
for i=1:4
    delay=1.5*ISI*i+geornd(.01);
    ntemp=[zeros(1,delay),box,zeros(1,ntime-delay-10)];
    n1=n1+ntemp;
end;
B1=conv(hrf,n1)/10; B1=B1(1:ntime);

% Region 2 with inputs from region 1 only
n2=zeros(1,ntime); 
for i=1:7
    delay=E(i)+geornd(.01); 
    ntemp=[zeros(1,delay),box,zeros(1,ntime-delay-10)];
    n2=n2+ntemp;
end;
B2=conv(hrf,n3)/10; B2=B2(1:ntime);

% Figure 10.4 model
% Evaluate (Order 2) model: 2 given 2 & 3 
X=[[B2(TR+1:ntime-TR)]' [B3(TR+1:ntime-TR)]' [B2(1:ntime-2*TR)]' [B3(1:ntime-2*TR)]']; 
Y=[B2(2*TR+1:ntime)]';
A=(inv(X'*X))*X'*Y; P=X*A;
tt=(2*TR+1)*T/ntime:T/ntime:T;
subplot(2,1,1); plot(tt,Y,tt,P); axis([0 200 0 .25]);
xlabel('time (sec)'); ylabel('BOLD Response');
sigsimp=(Y-P)'*(Y-P);

% Evaluate (Order 2) model: 2 given 1, 2 & 3 model 
X=[[B2(TR+1:ntime-TR)]' [B1(TR+1:ntime-TR)]' [B3(TR+1:ntime-TR)]' ...
     [B2(1:ntime-2*TR)]' [B1(1:ntime-2*TR)]' [B3(1:ntime-2*TR)]']; 
Y=[B2(2*TR+1:ntime)]';
A=(inv(X'*X))*X'*Y; P=X*A;
tt=(2*TR+1)*T/ntime:T/ntime:T;
subplot(2,1,2); plot(tt,Y,tt,P); axis([0 200 0 .25])
xlabel('time (sec)'); ylabel('BOLD Response');
sigfull=(Y-P)'*(Y-P);

% Compute conditional Granger causality
F12=log(sigsimp/sigfull) 

% Figure 10.5 model
% Build neural activation in region 2 
nkdelay=[zeros(1,20),n1(1:1980)];
n213=n2+nkdelay; 
B213=conv(hrf,n213)/10; B213=B213(1:ntime);

% Evaluate (Order 2) model: 2 given 2 & 3 
X=[[B213(TR+1:ntime-TR)]' [B3(TR+1:ntime-TR)]' [B213(1:ntime-2*TR)]' [B3(1:ntime-2*TR)]']; 
Y=[B213(2*TR+1:ntime)]';
A=(inv(X'*X))*X'*Y; P=X*A;
tt=(2*TR+1)*T/ntime:T/ntime:T;
figure;
subplot(2,1,1); plot(tt,Y,tt,P); axis([0 200 0 .45]);
xlabel('time (sec)'); ylabel('BOLD Response');
sigsimp=(Y-P)'*(Y-P);

% Evaluate (Order 2) model: 2 given 1, 2 & 3 model 
X=[[B213(TR+1:ntime-TR)]' [B1(TR+1:ntime-TR)]' [B3(TR+1:ntime-TR)]' ...
     [B213(1:ntime-2*TR)]' [B1(1:ntime-2*TR)]' [B3(1:ntime-2*TR)]']; 
Y=[B213(2*TR+1:ntime)]';
A=(inv(X'*X))*X'*Y; P=X*A;
tt=(2*TR+1)*T/ntime:T/ntime:T;
subplot(2,1,2); plot(tt,Y,tt,P); axis([0 200 0 .45])
xlabel('time (sec)'); ylabel('BOLD Response');
sigfull=(Y-P)'*(Y-P);

% Compute conditional Granger causality
F12=log(sigsimp/sigfull) 

