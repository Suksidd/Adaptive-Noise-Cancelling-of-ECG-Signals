clear all;
clc;

%Load Data
Data = load('118e00m.mat');  %Noise Free Signal (Reference Signal)
D = cell2mat(struct2cell(Data));
D = D(1,:);
Data = load('118e06m.mat'); %Signal to be filtered
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


f= 1800;
s = size(X,2);
d = D(56:56+f-1)'; %Clean Signal
x = X(56:56+f-1)'; %Taking the noisy portion of the input signal
bw = Bw(56:56+f-1)'; %Baseline wonder
ma = Ma(56:56+f-1)'; %Motion artifact
em = Em(56:56+f-1)'; %EMG artifact
N=3; %Sampling size
W1=zeros(N,1); %Initialize weights
itr1=500;
MSE2 =zeros(1,itr1);

Cov1 = zeros(f,f);
Avg1 = mean(x);
for j = 1:f
    for i =1:f
        Cov1(j, i) = ((x(j,1)-Avg1)*(x(i,1)-Avg1));
    end
end
Lamda1 = eig(Cov1);
mu1 = 2/(min(Lamda1)+max(Lamda1));

bww = [zeros(N-1,1); bw];
Ew = ma+em;
Eww = [zeros(N-1,1); Ew];

%LMS Algorithm - EMG nad Motion removal
 for i = 1:itr1
    for k = 1:f
       Z1 = Eww(k+N-1:-1:k);
       y1 = W1'*Z1;
       e1(k,1) = x(k,1)-y1;       
       W1 = W1 + (2*mu1*e1(k,1))*Z1;      
    end
     E1 = (x-e1);
     E1 = (E1'*E1)*1/f;
     MSE2(i) = log10(E1);
 end
rd = 9;
fl = 21;

smtlb = sgolayfilt(mtlb,rd,fl);

subplot(3,1,4)
plot(t,mtlb)
axis([0.2 0.22 -3 2])
title('Original')
grid

subplot(3,1,5)
plot(t,smtlb)
axis([0.2 0.22 -3 2])
title('Filtered')
grid

%Plots
subplot(3,1,1)
plot(x);title('Raw')
subplot(3,1,2)
plot(e1);title('Filtered emg and motion artifact')
subplot(3,1,3)
plot(d, 'k');title('Clean')