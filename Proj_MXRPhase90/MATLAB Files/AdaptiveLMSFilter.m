clear all
close all
h =[10 3];
a=1;
N = input('Enter N =');
t = 0:N-1;
x = sin(t);%random sine signal
%xf = filter(h,a,x);%filtered output
xf = conv(h,x); %in case filter function is considered to be a part of signal processing toolbox
xf(1) = [];
mean = 0;
var = 1;
n =var*rand(size(t))+mean;%Noise signal
y = xf+n; %output with noise
w = zeros(1,N); %adaptive filter coefficients
e = zeros(1,N); %Error signal
yhat = zeros(1,N);%Adaptive Filter Output
mu = input('Enter the value =');
for i = 1:N
    e(i) = y(i)- w(i)*x(i);
    w(i+1) = w(i)+mu*e(i)*x(i);
end
for i=1:N
yhat(i) = w(i) * x(i);  
end
w(1) = [];
subplot(1,2,1)
plot(t,e)
xlabel('Time');
ylabel('LMS Estimate Error');
grid on
subplot(1,2,2)
plot(t,w)
xlabel('Time');
ylabel('Coefficients');
grid on