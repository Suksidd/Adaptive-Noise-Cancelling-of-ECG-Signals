clear all;
clc;

Data = load('118e00m.mat'); %Noise Free Signal (Reference Signal)
D = cell2mat(struct2cell(Data));
D = D(1,:);                                     
Data = load('118e06m.mat'); %Noisy Signal
X = cell2mat(struct2cell(Data));
X = X(1,:); 

Data1 = load('118e12m.mat'); %Noisy Signal
X1 = cell2mat(struct2cell(Data1));
X1 = X1(1,:); 

Data2 = load('118e18m.mat'); %Noisy Signal
X2 = cell2mat(struct2cell(Data2));
X2 = X2(1,:); 

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

N=25; % Sampling Rate
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
plot(Bw);title('Basewander')
subplot(4,1,3)
plot(Ma);title('Muscle artifact')
subplot(4,1,4)
plot(Em);title('EMG')

%% filtering base line wander

Fc = 0.6; % Cutoff Frequency
% Construct an FDESIGN object and call its BUTTER method.
%[signal,Fs]=rdsamp('mitdb/100',[],10000);
%signal=load("bwm.mat");
%Fc=powerbw(signal,Fs);
%h = fdesign. highpass ('N,Fc', N, Fc, Fs);
[b,a] = butter(5,Fc/(f/2),'high');

%x1=signal(:,2);
x2=X2./ max(X2);
%figure(2)
%subplot (3,1,1), plot(x2), title ('ECG Signal with low-frequency(baseline wander) noise'), grid on
y0=filtfilt(b,a, x2);
%subplot (3,1,2), plot(y0), title ('ECG signal with baseline wander REMOVED'), grid on

%% filtering muscle artifact

%order = 2;
%framelen = 25;
%signalFiltered_1 = savitzkygolayfilt(y0, order,0,framelen);

%subplot(3, 1, 3);
%plot(signalFiltered_1(:));
%title("Ecg signal with muscle artifact removed");

%% filtering EMM noise
N=4; % Sampling Rate
W=zeros(N,1); %Initialize weights
itr=100;
MSE =zeros(1,itr);
Dw = [zeros(N-1,1); d]; %Padding reference signal with zeros

%NLMS Algorithm
for i = 1:itr
    for k = 1:f
       A = em(k+N-1:-1:k);
       y = W'*A;
       e(k,1) = x(k,1)-y; %Error signal
       p = alpha + A'*A;
       W = W + (2*mu*e(k,1)/p)*A;
    end     
     E =(e'*e)*1/f;
     MSE(i) = log10(E);
end
Y = x-e; %Calculating Filtered Signal by removing the estimated error above
