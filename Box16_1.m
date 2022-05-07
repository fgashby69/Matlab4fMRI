clear all; close all; clc;      % Clear all workspaces
 
% Define the connection matrices
A=[-.3 1.36 0; .02 -.85 .7; 0 .84 -.95];
B2=[0 .57 0; 0 0 0;0 0 0];
B3=[0 .23 0; 0 0 0;0 0 0];
C=[.85 0 0; 0 0 0;0 0 0];

% For Model 2, replace B3 with B3=[0 0 0; 0 0 .05;0 0 0];
 
% Define time
T=340; tau=.1; n=round(T/tau); t=0:tau:T;
 
% Create the hrf
ns=4; lamda=2;
hrf=(t.^(ns-1)).*exp(-t/lamda)/((lamda^ns)*factorial(ns-1));
 
% Initialize the activation vectors
v=zeros(3,n); vL=zeros(3,n);
 
% Define the inputs
   stim=ones(1,400);
   % u1 = visual input
   u1=[zeros(1,300),stim,zeros(1,400),stim,zeros(1,400),stim,zeros(1,400),stim,zeros(1,300)]; 
   % u2 = motion input
   u2=[zeros(1,1100),stim,zeros(1,1200),stim,zeros(1,300)];
   % u3 = attention input
   u3=[zeros(1,1900),stim,zeros(1,400),stim,zeros(1,300)];
   U=[u1; u2; u3];
 
% Solve the linear (vL) and binlinear (v) equations using Euler's method   
for i=1:n-1
    vL(:,i+1)=vL(:,i)+A*vL(:,i)+u2(1,i)*B2*vL(:,i)+u3(1,i)*B3*vL(:,i)+C*U(:,i);
    v(:,i+1)=v(:,i)+A*v(:,i)+C*U(:,i);
end;
    
% Plot the linear and bilinear neural activations
    % Area V1
    subplot(3,1,1); plot(tau*(1:n)-20,v(1,:)); hold on; plot(tau*(1:n)-20,vL(1,:));  
    axis([00 300 0 10]); xlabel('Time (sec)'); ylabel('Activation');
 
    % Area MT
    subplot(3,1,2); plot(tau*(1:n)-20,v(2,:)); hold on; plot(tau*(1:n)-20,vL(2,:)); 
    axis([00 300 0 1]); xlabel('Time (sec)'); ylabel('Activation');
 
    % Area SPC
    subplot(3,1,3); plot(tau*(1:n)-20,v(3,:)); hold on; plot(tau*(1:n)-20,vL(3,:)); 
    axis([00 300 0 1]); xlabel('Time (sec)'); ylabel('Activation');
 
% Convolve neural activation and hrf to generate predicted BOLD response
BOLDV1=conv(vL(1,:),hrf)/10; BOLDMT=conv(vL(2,:),hrf)/10; BOLDspc=conv(vL(3,:),hrf)/10;  
 
% Plot the predicted BOLD responses for the binlinear model
    figure; tt=0.1:.1:680;
    % Area V1
    subplot(3,1,1); plot(tt,BOLDV1);  
    axis([00 350 0 10]); xlabel('Time (sec)'); ylabel('BOLD');
 
    % Area MT
    subplot(3,1,2); plot(tt,BOLDMT); 
    axis([00 350 0 1]); xlabel('Time (sec)'); ylabel('BOLD');
 
    % Area SPC
    subplot(3,1,3); plot(tt,BOLDspc);
    axis([00 350 0 1]); xlabel('Time (sec)'); ylabel('BOLD');
