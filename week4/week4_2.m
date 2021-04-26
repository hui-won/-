%12181769 남희원 4주차 실습 과제

clc;clear all;
%% 오디오 파일 불러오기
[x,f0]=audioread('original.wav');
%x->샘플링 된 데이터, f0->샘플링 주파수 반환
%x=lowpass(x,6000,f0);
%오디오 데이터에 3800Hz의 lowpass filter 적용
%고주파 성분 제거
T0 = 1/f0;%샘플링 시간
t = 0:T0:4;%0-4초만 사용
x=x(1:length(t));%데이터 자르기

sound(x,f0);

audiowrite('cut.wav',x,f0);
%figure(1)
%plot(t,x);legend('Original_time');
%샘플링 주파수 f0, 오디오 데이터 행렬 x를 'song.wav'에 쓰기
%% 시간영역에서 샘플링 신호 생성
fs=13000;%오디오 주파수 (최대)6200에 대한 Nyquist frequency
Ts=1/fs;
sample_step=floor(Ts/T0);
sample_len=length(t)/sample_step;

ts=0:Ts:4;%시간 축

x_s=zeros(1,length(ts));
x_s(1)=x(1);
for i=1:length(ts)-1
    x_s(i+1)=x(1+i*sample_step);
end

%sound(x_s,fs);
audiowrite('sampling.wav',x_s,fs);

figure(1)
plot(ts,x_s);

%% 주파수 영역
N=length(t);
f1=(-N/2:N/2-1)*(f0/N);

FT_x=abs(fftshift(fft(x)));

figure(2);
plot(f1,10*log10(FT_x)); grid on;legend('Original freq');






