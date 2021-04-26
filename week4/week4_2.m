%12181769 ����� 4���� �ǽ� ����

clc;clear all;
%% ����� ���� �ҷ�����
[x,f0]=audioread('original.wav');
%x->���ø� �� ������, f0->���ø� ���ļ� ��ȯ
%x=lowpass(x,6000,f0);
%����� �����Ϳ� 3800Hz�� lowpass filter ����
%������ ���� ����
T0 = 1/f0;%���ø� �ð�
t = 0:T0:4;%0-4�ʸ� ���
x=x(1:length(t));%������ �ڸ���

sound(x,f0);

audiowrite('cut.wav',x,f0);
%figure(1)
%plot(t,x);legend('Original_time');
%���ø� ���ļ� f0, ����� ������ ��� x�� 'song.wav'�� ����
%% �ð��������� ���ø� ��ȣ ����
fs=13000;%����� ���ļ� (�ִ�)6200�� ���� Nyquist frequency
Ts=1/fs;
sample_step=floor(Ts/T0);
sample_len=length(t)/sample_step;

ts=0:Ts:4;%�ð� ��

x_s=zeros(1,length(ts));
x_s(1)=x(1);
for i=1:length(ts)-1
    x_s(i+1)=x(1+i*sample_step);
end

%sound(x_s,fs);
audiowrite('sampling.wav',x_s,fs);

figure(1)
plot(ts,x_s);

%% ���ļ� ����
N=length(t);
f1=(-N/2:N/2-1)*(f0/N);

FT_x=abs(fftshift(fft(x)));

figure(2);
plot(f1,10*log10(FT_x)); grid on;legend('Original freq');






