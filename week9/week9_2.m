%12181769 남희원 9주차 실습
clc; clear;close all;

Eb_No_dB = 20;

Eb_mW = 1;%fix
Eb_dBm = pow2db(Eb_mW);

No_dBm = Eb_dBm-Eb_No_dB;
No_mW = db2pow(No_dBm);

N_symbol=10^4;

n_bit_error_saved = zeros(1,N_symbol);
coordi_s1=zeros(2,N_symbol);
coordi_s2=zeros(2,N_symbol);

for i_symbol=1:N_symbol
  % bit generation  
  bits_=rand()>0.5;%bit--> 0 or 1
 
  % bit encoding
  bits_after_encoding=bits_*2-1;%1->+1,0->-1

  %Rayleigh channel
  h=(randn()+1j*randn())/sqrt(2);

  %noise generation
  noise_=sqrt(No_mW/2)*(randn()+1j*randn());
  
  % signal with noise
  y = h*bits_after_encoding+noise_;%채널을 통과한 신호+noise
  
  % signal detection
  r=(conj(h)/(abs(h)^2))*y;%real
  %bpsk기 때문에 real만
  bit_re=real(r)>0;
 
  % error bit count
  n_bit_error=bits_~=bit_re;
  n_bit_error_saved(i_symbol)=n_bit_error;
  
  if bits_==1
      coordi_s1(:,i_symbol)=[real(r);imag(r)];
  else
      coordi_s2(:,i_symbol)=[real(r);imag(r)];
  end
end
%experiment
BER(1)=mean(n_bit_error_saved);
%theorem
BER(2)=1/2*(1-sqrt(db2pow(Eb_No_dB)/(db2pow(Eb_No_dB)+1)));

figure
hold on;grid on;
p1=plot(coordi_s1(1,:),coordi_s1(2,:),'o');
p2=plot(coordi_s2(1,:),coordi_s2(2,:),'s');

set(p1,'color','b');
set(p2,'color','k');
axis([-3,3,-3,3]);
set(gca,'ytick',-3:0.5:3,'xtick',-3:0.5:3)
title(sprintf('Eb/No = %d[dB]',Eb_No_dB));
q1=plot(1,0,'o');set(q1,'markersize',15,'markerEdgeColor','r','markerfacecolor','r');
q2=plot(-1,0,'o');set(q2,'markersize',15,'markeredgecolor','r','markerfacecolor','r');


