%12181769 남희원 7주차 실습
clc; clear;close all;

%% No값 설정
Eb_No_dB = 5;

Eb_mW = 1;%fix
Eb_dBm = pow2db(Eb_mW);
No_dBm = Eb_dBm-Eb_No_dB;
No_mW = db2pow(No_dBm);

%% 변수 및 배열 초기화
N_bits=1*1e4;
N_symbol=N_bits/2;

BER_=zeros(2,1);
SER_=zeros(2,1);

n_symbol_error_saved = zeros(1,N_symbol);
n_bit_error_saved = zeros(1,N_symbol);

coordi_=zeros(2,N_symbol);

for i_symbol=1:N_symbol
  % bit generation  
  bits_=rand(2,1)>0.5;%bit--> 0 or 1
 
  % bit encoding
  bits_after_encoding=bits_*2-1;%1->+1,0->-1
 
  % symbol energy
  Es_mW=2*Eb_mW;%하나의 심볼에 두 개 비트가 존재하므로
  
  % QPSK modulation
  symbol_=sqrt(Es_mW/2)*(bits_after_encoding(1)+1j*bits_after_encoding(2));
  
  %noise generation
  noise_=sqrt(No_mW/2)*(randn(size(symbol_))+1j*randn(size(symbol_)));
  
  % signal with noise
  y=symbol_+noise_;
  
  % symbol demodulation
  symbol_after_decoding=2*(real(y)>0)-1+1j*(2*(imag(y)>0)-1);
  
  % bit demodulation with demodulated symbol
  bit_re=[real(symbol_after_decoding)>0;imag(symbol_after_decoding)>0];
  
  % error symbol count
  bool_symbol_error=(symbol_~=symbol_after_decoding);
  n_symbol_error_saved(i_symbol)=bool_symbol_error;
  
  % error bit count
  n_bit_error=sum(bits_~=bit_re);
  n_bit_error_saved(i_symbol)=n_bit_error;
  
  coordi_(:,i_symbol)=[real(y);imag(y)];
end

SER=sum(n_symbol_error_saved)/N_symbol;
BER=sum(n_bit_error_saved)/(2*N_symbol);
%% 그래프 그리기
qpsk_symbol=[1 1 -1 -1;1 -1 1 -1];
figure
hold on;grid on;
q=plot(coordi_(1,:),coordi_(2,:),'*','color','b','markersize',2);
p=plot(qpsk_symbol(1,:),qpsk_symbol(2,:),'o');
set(p,'markersize',8,'markeredgecolor','r','markerfacecolor','r');
title_=sprintf('Eb/No : %d [dB]',Eb_No_dB);
xlabel('In-phase'),ylabel('Quadrature'),title(title_);



