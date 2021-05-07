% Rayleigh PDF 
clc;clear;close all;
N=1e5;

%N개의 채널 한 번에 만들기
h=(randn(1,N)+1j*randn(1,N))/sqrt(2);
%평균이 0이고 분산이 1/2인 실수부, 허수부

%(채널의 크기)^2=(실수부)^2+(허수부)^2
%          = h*conj(h)
h_square=h.*conj(h);%element별로
h_amp=sqrt(h_square);%채널의 크기

%pdf구하기
h_=0:0.01:5;%구하고싶은 범위
dl=h_(2)-h_(1);%간격 설정
pdf=zeros(1,length(h_));
for i=1:length(h_)
    for j=1:length(h_amp)
        if(h_amp(j)>=h_(1)+(i-1)*dl && h_amp(j)<h_(1)+i*dl)
            pdf(i)=pdf(i)+1/(length(h_amp)*dl);
        end
    end
end

sigma_square=0.5;
pdf_h_theory=h_/sigma_square.*exp(-h_.^2/(2*sigma_square));

figure
hold on;grid on
p=plot(h_,pdf);set(p,'linestyle','none','marker','o');
r=plot(h_,pdf_h_theory);
xlabel('|h|'), ylabel('PDF');