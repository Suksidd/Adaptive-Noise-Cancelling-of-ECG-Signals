clc
clear all;
close all;
[refsig,Fs]=rdsamp('nstdb/118e00',[],10000);
[noisesig1,Fs1]=rdsamp('nstdb/118e06',[],10000);
[noisesig2,Fs2]=rdsamp('nstdb/118e12',[],10000);
[noisesig3,Fs3]=rdsamp('nstdb/118e18',[],10000);
[noisesig4,Fs4]=rdsamp('nstdb/118e24',[],10000);
[MA,MAFs]=rdsamp('nstdb/ma',[],10000);
[BW,BWFs]=rdsamp('nstdb/bw',[],10000);
[EM,EMFs]=rdsamp('nstdb/em',[],10000);

noise = BW+EM+MA; %Total Noise
%% compare between NLMS and SGolay filter
Fc = 0.6; % Cutoff Frequency
[b,a] = butter(3,Fc/(Fs1/2),'high');
x1=noisesig1(:,2);
x2=x1./ max(x1);
y0=filtfilt(b,a, x2);


order = 2;
framelen = 25;
signalFiltered_1 = sgolayfilt(y0, order, framelen);
%figure(1);
%plot(signalFiltered_1);

%% SNR for SG only

%% 

x=noisesig1;
N=4; % Sampling Rate
W=zeros(N,1); %Initialize weights
alpha= 0.001;
mu=0.0002;
itr=1000;
MSE =zeros(1,itr);
Dw = [zeros(N-1,1);y0 ]; %Padding reference signal with zeros
f=10000;
%NLMS Algorithm
for i = 1:itr
    for k = 1:f
       X = Dw(k+N-1:-1:k);
       y = W'*X;
       e(k,1) = x(k,1)-y; %Error signal
       p = alpha + X'*X;
       W = W + (2*mu*e(k,1)/p)*X;
    end     
     E =(e'*e)*1/f;
     MSE(i) = log10(E);
end
Y = (x-e)/100; %Calculating Filtered Signal by removing the estimated error above

%% calculate snr for nlms only
