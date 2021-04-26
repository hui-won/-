%12181769 ����� 4���� �ǽ� ����

clc;clear all;
%% ����� ���� �ҷ�����
[x,f0]=audioread('original.wav');
%x->���ø� �� ������, f0->���ø� ���ļ� ��ȯ
x=lowpass(x,6200,f0);
%����� �����Ϳ� 9000Hz�� lowpass filter ����
%������ ���� ����
T0 = 1/f0;%���ø� �ð�
t = 0:T0:4;%0-4�ʸ� ���
x=x(1:length(t));%������ �ڸ���

%sound(x,f0);
audiowrite('cut.wav',x,f0);
%���ø� ���ļ� f0, ����� ������ ��� x�� 'song.wav'�� ����

%% �ð��������� ���ø� ��ȣ ����
fs=7000;%����� ���ļ� (�ִ�)6200�� ���� Nyquist frequency
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

%% �ð����� reconstruction
y=zeros(1,length(t));
tic;%�ð� ����
parfor i=1:length(ts)
    y=y+x_s(i)*sinc((t-(i-1)*Ts)/Ts);
end
toc;

filename=char('reconstruction_fs_'+string(fs)+'HZ.wav');
audiowrite(filename,y,f0);
sound(y,f0);
hold on
plot(t,y); legend('origin','recon');

%% ���ļ��κп��� ����� �� Ȯ���ϱ� ���ؼ�
t_s2=t;%������ ��ȣ�� ���� ���̸� ������
x_s2=zeros(1,length(x));
x_s2(1)=x(1);
for i1=2:length(t)
    if(mod(i1,sample_step)==0)
        x_s2(i1)=x(i1);
    end
end
%���ø� �� ���� ���ؼ��� �״��, �ƴ� �������ؼ��� 0�� �ֱ�

%% ���ļ� ����

N=length(t);
f1=(-N/2:N/2-1)*(f0/N);

FT_x=abs(fftshift(fft(x)));
FT_x_s=abs(fftshift(fft(x_s2)));
FT_y=abs(fftshift(fft(y)));
figure(2);
subplot(3,1,1);plot(f1,10*log10(FT_x)); grid on;legend('Original');
subplot(3,1,2);plot(f1,10*log10(FT_x_s)); grid on;legend('Samling');
subplot(3,1,3);plot(f1,10*log10(FT_y)); grid on;legend('Reconstruction');











