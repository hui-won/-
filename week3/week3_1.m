%12181769 남희원 3주차 실습 과제

clear all; clc;
%% 원신호 시간영역에서 그리기
A=2;
B=1;
fm1=3;
fm2=4;
start=1;
tc=0.01;%discrete 신호를 continuous하게 보이기 위해
t=start:tc:2*pi;
x=A*cos(2*pi*fm1*t)+B*cos(2*pi*fm2*t);

figure(1)
plot(t,x);
%% 시간영역에서 샘플링 신호 생성
fs=10;%샘플링 주파수
ts=1/fs;%샘플링 시간--> fs의 역수

sample_step=floor(ts/tc);
%sampling 시간을 원래의 시간 간격으로 나누어주기
%정수로 만들어주기

t2=start:ts:2*pi;
x_s(1)=x(1);
for i=1: length(t2)-1
    x_s(i+1) =x(1+i*sample_step);
end

hold on
stem(t2, x_s);

%% 시간영역 reconstruction
y=zeros(length(t2),length(t));
for i=1:length(t2)
    y(i,:)=x_s(i)*sinc((t-(i-1+start*fs)*ts)/ts);
end
y=sum(y);

plot(t,y); legend('origin','sample','recon');

%% 주파수 영역 그래프
N=length(t);
f2=(-N/2:N/2-1)*(fs/N);
f1=(-N/2:N/2-1)*(1/tc/N);

X=abs(fftshift(fft(x)));
X_s=abs(fftshift(fft(x_s,N)));
Y=abs(fftshift(fft(y)));
%abs--> 복소수의 크기만 확인
%fftshift --> 그래프의 원하는 영역 보기 위해서
%fft --> fast fourier transform

figure(2)
subplot(3,1,1);plot(f1,X);
subplot(3,1,2);plot(f2,X_s);
subplot(3,1,3);plot(f1,Y);





