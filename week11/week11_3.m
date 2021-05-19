% 12181769 남희원 11주차 과제
clc; clear; close all;
%% generate sample
Eb_No_dB = 0:1:10;
N_bits=1e6;
%rng(1)%랜덤 변수 시드 고정
sample=8;
modOrder=2;

bit_error_saved=zeros(N_bits/sample,sample);
BER_=zeros(2,length(Eb_No_dB));
%% OFDM Modulation
for i_ = 1:length(Eb_No_dB)
    for i_symbol=1:N_bits/8
        %bit generation
        tx=randi([0 modOrder-1],1,sample);
        %BPSK Modulation
        tx_mod=qammod(tx,modOrder);%8개 비트를 BPSK 신호로 
        %Serial to Parallel
        tx_mod=tx_mod';%1x8 -> 8x1

        %IFFT
        tx_ifft=ifft(tx_mod)*sqrt(sample);% freq -> time
        % Parallel to Serial
        tx_ofdm = tx_ifft';%8x1 -> 1x8
       
       %% signal with noise
        rx_ofdm=awgn(tx_ofdm,Eb_No_dB(i_));
        
       %% OFDM Demodulation
        %Serial to Parallel
        rx_ofdm=rx_ofdm';%1x8 -> 8x1

        %FFT
        rx_fft=fft(rx_ofdm)/sqrt(sample);% time->freq

        %Parallel to Serail
        rx_fft=rx_fft';

       %% BPSK demodulation
        rx=qamdemod(rx_fft,modOrder);%알아서 가까이 있는 값으로 demod
        
        %error bit count
        bit_error=tx~=rx;
        bit_error_saved(i_symbol,:)=bit_error;
    end
    %experiment
    BER_(1,i_)=mean(bit_error_saved(:));
    %theorem
    BER_(2,i_)=1/2*erfc(sqrt(db2pow(Eb_No_dB(i_))));
end
%% figure
figure
hold on;grid on;
xlabel('Eb/No[dB]');ylabel('BER');
p1=plot(Eb_No_dB,BER_(1,:),'o');set(p1,'markersize',5,'markeredgecolor','b','markerfacecolor','b');
p2=plot(Eb_No_dB,BER_(2,:),'color','r');
legend('BER','BER theory');
set(gca,'yscale','log')
axis([Eb_No_dB(1),Eb_No_dB(end),1e-5,1]);