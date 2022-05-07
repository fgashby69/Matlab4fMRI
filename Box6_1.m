clear all; close all; clc;      %Clear all workspaces

% Define the time axis and the hrf 
t25=0:.01:32; T0=0; n=4; lamda=2;
hrf=((t25-T0).^(n-1)).*exp(-(t25-T0)/lamda)/((lamda^n)*factorial(n-1));

% Define and plot the boxcar
box=zeros(1,3201); event=ones(1,200);
box(1,1:200)=event; box(1,801:1000)=event; box(1,1601:1800)=event; box(1,2401:2600)=event;
subplot(3,1,1); plot(t25,box); axis([0 40 0 1.5]); 
xlabel('Time (sec)'); ylabel('Neural Activation') % axis labels

% Convolve the hrf and boxcar and then plot
B=conv(hrf,box)/100;
t=0:.01:64;
subplot(3,1,2); plot(t,B); axis([0 40 0 .4]);
xlabel('Time (sec)'); ylabel('Predicted BOLD') % axis labels

% Discretize the predicted BOLD response (i.e., in the vector N) & plot
Nplot=zeros(1,6401);
for i=1:20
    N(i)=B(i*200);
    Nplot(i*200)=N(i);
end;
subplot(3,1,3); plot(t,Nplot); axis([0 40 0 .4]);
xlabel('Time (sec)'); ylabel('Predicted BOLD') % axis labels


