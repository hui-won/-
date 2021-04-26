%12181769 ����� 5���� �ǽ� ����
clc;clear all;close all;
%% ��ȣ ����
f0=22050;
T0=1/f0;
start_time=0;
finish_time=5.5;
t1=start_time:T0:finish_time;

fs=11025;
ts=1/fs;
t2=start_time:ts:finish_time;
N_ts=length(t2);


Max=1;
Min=-1;

Q_level=64;
Q_step=(Max-Min)/Q_level;

%% ������ ��ȣȭ ��ȣ �������� 
load('encode_data.mat');
%% ��ȣȭ
N_bit=log2(Q_level);
temp=(reshape(x_en,N_bit,N_ts))';

x_de=zeros(1,N_ts);
for i1=1:N_ts
    x_de(i1)=Q_step*bin2dec(temp(i1,:))+Q_step/2+Min;
end

%% ����
y=zeros(1,length(t1));
for i1=1:N_ts
    y=y+x_de(i1)*sinc((t1-(i1-1)*ts)/ts);
end

audiowrite('reconstruction_week5_3.wav',y,f0);
sound(y,f0);

