%12181769 ����� 3���� �ǽ� ����

clear all; clc;
%% ����ȣ �ð��������� �׸���
A=2;
B=1;
fm1=3;
fm2=4;
start=1;
tc=0.01;%discrete ��ȣ�� continuous�ϰ� ���̱� ����
t=start:tc:2*pi;
x=A*cos(2*pi*fm1*t)+B*cos(2*pi*fm2*t);

figure(1)
plot(t,x);
%% �ð��������� ���ø� ��ȣ ����
fs=10;%���ø� ���ļ�
ts=1/fs;%���ø� �ð�--> fs�� ����

sample_step=floor(ts/tc);
%sampling �ð��� ������ �ð� �������� �������ֱ�
%������ ������ֱ�

t2=start:ts:2*pi;
x_s(1)=x(1);
for i=1: length(t2)-1
    x_s(i+1) =x(1+i*sample_step);
end

hold on
stem(t2, x_s);

%% �ð����� reconstruction
y=zeros(length(t2),length(t));
for i=1:length(t2)
    y(i,:)=x_s(i)*sinc((t-(i-1+start*fs)*ts)/ts);
end
y=sum(y);

plot(t,y); legend('origin','sample','recon');

%% ���ļ� ���� �׷���
N=length(t);
f2=(-N/2:N/2-1)*(fs/N);
f1=(-N/2:N/2-1)*(1/tc/N);

X=abs(fftshift(fft(x)));
X_s=abs(fftshift(fft(x_s,N)));
Y=abs(fftshift(fft(y)));
%abs--> ���Ҽ��� ũ�⸸ Ȯ��
%fftshift --> �׷����� ���ϴ� ���� ���� ���ؼ�
%fft --> fast fourier transform

figure(2)
subplot(3,1,1);plot(f1,X);
subplot(3,1,2);plot(f2,X_s);
subplot(3,1,3);plot(f1,Y);





