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
Y = x-e; %Calculating Filtered Signal by removing the estimated error above



subplot(6,1,1)
plot(x);title('Raw')
subplot(6,1,2)
plot(Y);title('Filtered')
subplot(6,1,3)
plot(Bw);title('Basewander')
subplot(6,1,4)
plot(Ma);title('Muscle artifact')
subplot(6,1,5)
plot(Em);title('EMG')
subplot(6,1,6)
plot(d, 'k');title('Clean')
%%
y = sgolayfilt(ma,2,25);
c = smooth(ma,500,'moving');

subplot(3,1,1), plot(ma), hold on, plot(y,'r','linewidth',2), plot(c,'g','linewidth',2),
title('ECG + wandering signal'); 
legend('ECG', 'Savitzky-Golay', 'moving average');
%%
subplot(3,1,2), plot(x-y),
title('ECG with wandering filtered out using Savitzky-Golay filter');
subplot(3,1,3), plot(x-c),
title('ECG with wandering filtered out using moving average');
%figure;
%subplot(2,1,1)
%plot(MSE);title('MSE');