clear all; close all; clc;                  			% Clear all workspaces

% Set the effect size K (i.e., the value of the alternative hypothesis)
K=0.50;

% Set the standard deviation of within-subject noise
sigW=0.75;

% Set the standard deviation of between-subject noise
sigG=0.75;

% Set the total number of TRs 
% (half are from task blocks; half from rest blocks)
NTR=400;

% Set the alpha level (single voxel, one-tailed test)
alpha=.05;

% Select the number of subjects
NS=16;

% Compute the noncentrality parameter
delta=K/sqrt( (sigG*sigG/NS) + ((sigW*sigW)/(NS*NTR)) );

% Compute the critical value of the t-test
tc=icdf('t',1-alpha,NS-1);

% Compute the power using the normal approximation to the area under the
% noncentral t
X=(tc-delta)/sqrt(1+ ((tc*tc)/(2*(NS-1))));
power=1-normcdf(X,0,1)

% if the following commands are available, then power can be computed
% exactly 
powerNCT=1-cdf('nct',tc,NS-1,delta);
