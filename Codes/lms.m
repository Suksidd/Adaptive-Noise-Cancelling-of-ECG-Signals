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

%%
f= 1800;
s = size(X,2);
d = D(56:56+f-1)'; %Clean Signal
x = X(56:56+f-1)'; %Taking the noisy portion of the input signal
bw = Bw(56:56+f-1)'; %Baseline wonder
ma = Ma(56:56+f-1)'; %Motion artifact
em = Em(56:56+f-1)'; %EMG artifact
N=3; %Sampling size
W=zeros(N,1); %Initialize weights

% Calculte the Covariance matrix of the given signal to estimate the
% optimum step-size(mu)
Cov = zeros(f,f);
Avg = mean(x);
for j = 1:f
    for i =1:f
        Cov(j, i) = ((x(j,1)-Avg)*(x(i,1)-Avg));
    end
end
Lamda = eig(Cov);
mu = 2/(min(Lamda)+max(Lamda));

itr=100; % Number of iterations
MSE1 =zeros(1,itr);

bww = [zeros(N-1,1); bw];
Ew = ma+em;
Eww = [zeros(N-1,1); Ew];

%LMS Algorithm - Filter Baseline Wander
 for i = 1:itr
    for k = 1:f
       Z = bww(k+N-1:-1:k);
       y = W'*Z;
       e(k,1) = x(k,1)-y;
       W = W + (2*mu*e(k,1))*Z;      
    end
     M = x-e;
     E = (M'*M)*1/f;
    MSE1(i) = log10(E);
 end
%%
W1=zeros(N,1); %Initialize weights
itr1=500;
MSE2 =zeros(1,itr1);

Cov1 = zeros(f,f);
Avg1 = mean(e);
for j = 1:f
    for i =1:f
        Cov1(j, i) = ((e(j,1)-Avg1)*(e(i,1)-Avg1));
    end
end
Lamda1 = eig(Cov1);
mu1 = 2/(min(Lamda1)+max(Lamda1));

%LMS Algorithm - EMG nad Motion removal
 for i = 1:itr1
    for k = 1:f
       Z1 = Eww(k+N-1:-1:k);
       y1 = W1'*Z1;
       e1(k,1) = e(k,1)-y1;       
       W1 = W1 + (2*mu1*e1(k,1))*Z1;      
    end
     E1 = (e-e1);
     E1 = (E1'*E1)*1/f;
     MSE2(i) = log10(E1);
 end

%Plots
subplot(3,1,1)
plot(x);title('Raw')
subplot(3,1,2)
plot(e1);title('Filtered')
subplot(3,1,3)
plot(d, 'k');title('Clean')

figure;
subplot(2,1,1)
plot(MSE1);title('MSE1');
subplot(2,1,2)
plot(MSE2);title('MSE2');

