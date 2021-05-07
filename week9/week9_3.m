%12181769 남희원 9주차 실습 과제
clc; clear;close all;

Eb_No_dB = -10:5:30;

Eb_mW = 1;%fix
Eb_dBm = pow2db(Eb_mW);

No_dBm = Eb_dBm-Eb_No_dB;
No_mW = db2pow(No_dBm);

N_bits=1e5;

n_bit_error_saved = zeros(1,N_bits);
BER_=zeros(2,length(Eb_No_dB));

for j_=1:length(Eb_No_dB)
    parfor i_symbol=1:N_bits
      % bit generation  
      bits_=rand()>0.5;%bit--> 0 or 1

      % bit encoding
      bits_after_encoding=bits_*2-1;%1->+1,0->-1

      %Rayleigh channel
      h=(randn()+1j*randn())/sqrt(2);

      %noise generation
      noise_=sqrt(No_mW(j_)/2)*(randn()+1j*randn());

      % signal with noise
      y = h*bits_after_encoding+noise_;%채널을 통과한 신호+noise

      % signal detection
      r=(conj(h)/(abs(h)^2))*y;%real
      %bpsk기 때문에 real만
      bit_re=real(r)>0;

      % error bit count
      n_bit_error=bits_~=bit_re;
      n_bit_error_saved(i_symbol)=n_bit_error;
    end
    %experiment
    BER_(1,j_)=mean(n_bit_error_saved);
    %theorem
    BER_(2,j_)=1/2*(1-sqrt(db2pow(Eb_No_dB(j_))/(db2pow(Eb_No_dB(j_))+1)));
end

figure
hold on;grid on;
xlabel('Eb/No[dB]');ylabel('BER');
p1=plot(Eb_No_dB,BER_(1,:),'o');set(p1,'markersize',5,'markeredgecolor','b','markerfacecolor','b');
p2=plot(Eb_No_dB,BER_(2,:),'color','r');
legend('BER','BER theory');
set(gca,'yscale','log')
axis([Eb_No_dB(1),Eb_No_dB(end),1e-4,1]);

