% 12181769 남희원 11주차 실습
clc; clear; close all;
%% generate sample
rng(1)%랜덤 변수 시드 고정
sample=15;
modOrder=2;
%tx=[0 0 1 1 1 0 0 0 0 1 1 1 1 1 1];
tx=randi([0 modOrder-1],1,sample);
%0/1의 값을 갖는 15개의 bit 생성

%BPSK Modulation
tx_mod=qammod(tx,modOrder);%15개 비트를 BPSK 신호로 

%% OFDM Modulation
%Serial to Parallel
tx_mod=tx_mod';%1x15 -> 15x1

%IFFT
tx_ifft=ifft(tx_mod)*sqrt(sample);% freq -> time

% Parallel to Serial
tx_ofdm=tx_ifft';%15x1 -> 1x15

%% OFDM Demodulation
%Serial to Parallel
rx_ofdm=tx_ofdm';%1x15 -> 15x1

%FFT
rx_fft=fft(rx_ofdm)/sqrt(sample);% time->freq

%Parallel to Serail
rx_fft=rx_fft';%15x1 -> 1x15

%% BPSK demodulation
rx=qamdemod(rx_fft,modOrder);%알아서 가까이 있는 값으로 demod

%% PAPR Check
max_pow = max((abs(tx_ofdm)).^2);
mean_pow = mean((abs(tx_ofdm)).^2);
PARP = 10*log10(max_pow/mean_pow);

%% figure
figure(1);hold on;
subplot(2,1,1);stem(tx_mod','linewidth',2);grid on;xlabel('Sample in Freq.');ylabel('Value');title('BPSK Symbols');
subplot(2,1,2);plot(abs(tx_ifft'),'r-','linewidth',2);grid on;xlabel('Sample in Time');ylabel('Value');title('Symbols After IFFT(amplitude)');

figure(2);hold on;box on
stem(real(tx_mod'),'o','linewidth',2);
stem(real(rx_fft'),'--x','linewidth',2);
xlabel('Sample');ylabel('Value');
legend('Before IFFT','After FFT');
grid on;

x=[1:sample];
figure(3);hold on;
stem(x,tx,'o','linewidth',2);
stem(x,rx,'--x','linewidth',2);grid on;
xlabel('Index');ylabel('Value');legend('TX Bits','Rx Bits');ylim([0 1.5]);
