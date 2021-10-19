clear all;
clc;

Data = load('118e00m.mat'); %Noise Free Signal (Reference Signal)
D = cell2mat(struct2cell(Data));
D = D(1,:);                                     
Data = load('118e06m.mat'); %Noisy Signal
X = cell2mat(struct2cell(Data));
X = X(1,:); 
Data = load('bwm.mat'); %Baseline wander Noise
Bw = cell2mat(struct2cell(Data));
Bw = Bw(1,:);
Data = load('mam.mat'); %Muscle Artifact
Ma = cell2mat(struct2cell(Data));
Ma = Ma(1,:);
Data = load('emm.mat'); %Electrode motion artifact
Em = cell2mat(struct2cell(Data));
Em = Em(1,:);
Total_Noise = Bw+Em+Ma; %Total Noise

f =1800;
s = size(X,2);
d = D(56:56+f-1)'; %Clean Signal
x = X(56:56+f-1)'; %Taking the noisy portion of the input signal
TN = Total_Noise(56:56+f-1)'; %Corresponding Total Noise
bw = Bw(56:56+f-1)';
ma = Ma(56:56+f-1)';
em = Em(56:56+f-1)';

N=4; % Sampling Rate
W=zeros(N,1); %Initialize weights
alpha= 0.001;
mu=0.0002;
itr=1000;
MSE =zeros(1,itr);
Dw = [zeros(N-1,1); d]; %Padding reference signal with zeros

%%
figure(1)
subplot(4,1,1)
plot(x);title('Raw')
subplot(4,1,2)
%%plot(Y);title('Filtered')
%%subplot(6,1,3)
plot(Bw);title('Basewander')
subplot(4,1,3)
plot(Ma);title('Muscle artifact')
subplot(4,1,4)
plot(Em);title('EMG')

%% filtering base line wander

Fc = 0.6; % Cutoff Frequency
% Construct an FDESIGN object and call its BUTTER method.
[signal,f]=rdsamp('nstdb/118e06',[],10000);
%[signal,Fs]=rdsamp('mitdb/100',[],10000);
%signal=load("bwm.mat");
%Fc=powerbw(signal,Fs);
%h = fdesign. highpass ('N,Fc', N, Fc, Fs);
[b,a] = butter(3,Fc/(f/2),'high');

x1=signal(:,2);
x2=X./ max(x1);
figure(2)
subplot (3,1,1), plot(x2), title ('ECG Signal with low-frequency(baseline wander) noise'), grid on
y0=filtfilt(b,a, x2);
subplot (3,1,2), plot(y0), title ('ECG signal with baseline wander REMOVED'), grid on

%% filtering muscle artifact

order = 5;
framelen = 51;
signalFiltered_1 = sgolayfilt(y0, order, framelen);

subplot(3, 1, 3);
plot(signalFiltered_1(:));
title("Ecg signal with muscle artifact removed");

%%