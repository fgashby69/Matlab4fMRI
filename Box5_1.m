clear all; close all; clc;     					%Clear all workspaces
 
% Create the difference-of-gammas hrf
t=0:.01:24;
n1=4; lamda1=2; n2=7; lamda2=2; a=.3; c1=1; c2=.5;
hx=(t.^(n1-1)).*exp(-t/lamda1)/((lamda1^n1)*factorial(n1-1));
hy=(t.^(n2-1)).*exp(-t/lamda2)/((lamda2^n2)*factorial(n2-1));
hrf=a*(c1*hx-c2*hy);
 
subplot(2,2,1);     						%Plot the difference-of-gamma hrf
plot(t,hrf,'k'); axis([0 24 -.01 .04]); 
xlabel('time (sec)'); ylabel('BOLD');
 
% Sample hrf every TR=3 seconds. These points are the raw data to interpolate.
for i=1:9
    xx(i)=hrf(300*i-299);
    n(i)=300*i-299;
end;
tt=0:3:24;
 
subplot(2,2,2);     						%Linear interpolation
plot(t,hrf,'k'); axis([0 24 -.01 .04]); hold on;
xi=(0:.25:24)'; tlin=tt'; xlin=xx';
yi = interp1q(tlin,xlin,xi); 
plot(tlin,xlin,'o',xi,yi);
xlabel('time (sec)'); ylabel('BOLD');
 
subplot(2,2,3);     						%Cubic spline interpolation
plot(t,hrf,'k'); axis([0 24 -.01 .04]); hold on;
xi=(0:.25:24)';
tspline=tt';
xspline=xx';
yi = spline(tspline,xspline,xi); 
plot(tspline,xspline,'o',xi,yi);
xlabel('time (sec)'); ylabel('BOLD');
 
% Sinc interpolate with Eq. 4.4. L = width of Hanning window.
L=10;
for i=1:2401;
    B_interp(i)=sum(xx.*sinc((i-n)/300).*(1+cos(pi*.01*(i-n)/L))/2);
end;
 
subplot(2,2,4);
plot(tt,xx,'o'); hold on;
plot(t,hrf,'k'); axis([0 24 -.01 .04]); hold on;
xlabel('time (sec)'); ylabel('BOLD');
plot(t,B_interp); xlabel('time (sec)'); ylabel('BOLD');

