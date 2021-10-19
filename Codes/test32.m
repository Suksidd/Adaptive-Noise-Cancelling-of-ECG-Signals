clc
clear all;
close all;
%% obtain signals
[refsig,Fs]=rdsamp('nstdb/118e00',[],117999,108000);
[noisesig1,Fs1]=rdsamp('nstdb/118e06',[],117999,108000);
[noisesig2,Fs2]=rdsamp('nstdb/118e12',[],117999,108000);
[noisesig3,Fs3]=rdsamp('nstdb/118e18',[],117999,108000);
[noisesig4,Fs4]=rdsamp('nstdb/118e24',[],117999,108000);
[noisesig5,Fs5]=rdsamp('nstdb/119e12',[],117999,108000);
[noisesig6,Fs6]=rdsamp('nstdb/119e06',[],117999,108000);
[noisesig7,Fs7]=rdsamp('nstdb/119e18',[],117999,108000);
[noisesig8,Fs8]=rdsamp('nstdb/119e24',[],117999,108000);
[noise,Fss]=rdsamp('nstdb/em',[],117999,108000);

[MA,MAFs]=rdsamp('nstdb/ma',[],117999,108000);
[BW,BWFs]=rdsamp('nstdb/bw',[],117999,108000);
[EM,EMFs]=rdsamp('nstdb/em',[],117999,108000);

Total_Noise = BW+EM+MA; %Total Noise


x=noisesig7;
%% filter out baseline wander noise
Fc = 0.6; % Cutoff Frequency
[b,a] = butter(3,Fc/(Fs1/2),'high');
x1=noisesig7(:,2);
x2=x1./ max(x1);
%figure(1);
%subplot (4,1,1), plot(x2), title ('ECG Signal with low-frequency(baseline wander) noise'), grid on
y0=filtfilt(b,a, x2);
%subplot (4,1,2), plot(y0), title ('ECG signal with baseline wander REMOVED'), grid on

%% calculate snr
%r=snr(y0,Total_Noise(:,1))

%% filter out muscle artifact noise 
order = 2;
framelen = 25;
signalFiltered_1 = sgolayfilt(y0, order, framelen);
%subplot(4, 1, 3);
%plot(signalFiltered_1);
%title("ECG Signal with muscle artifact removed");

%% SNR
r=snr(signalFiltered_1(:,1),Total_Noise(:,1))

%% filter out Electrode motion artifact

N=4; % Sampling Rate
W=zeros(N,1); %Initialize weights
alpha= 0.001;
mu=0.0002;
itr=500;
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
%subplot(4,1,4)
%plot(Y);title('Filtered');
r=snr(Y(:,1),Total_Noise(:,1))