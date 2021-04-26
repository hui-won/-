%12181769 남희원 4주차 실습 과제

clc;clear all;
%% 오디오 파일 불러오기
[x,f0]=audioread('original.wav');
%x->샘플링 된 데이터, f0->샘플링 주파수 반환
x=lowpass(x,6200,f0);
%오디오 데이터에 9000Hz의 lowpass filter 적용
%고주파 성분 제거
T0 = 1/f0;%샘플링 시간
t = 0:T0:4;%0-4초만 사용
x=x(1:length(t));%데이터 자르기

%sound(x,f0);
audiowrite('cut.wav',x,f0);
%샘플링 주파수 f0, 오디오 데이터 행렬 x를 'song.wav'에 쓰기

%% 시간영역에서 샘플링 신호 생성
fs=7000;%오디오 주파수 (최대)6200에 대한 Nyquist frequency
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

%% 시간영역 reconstruction
y=zeros(1,length(t));
tic;%시간 측정
parfor i=1:length(ts)
    y=y+x_s(i)*sinc((t-(i-1)*Ts)/Ts);
end
toc;

filename=char('reconstruction_fs_'+string(fs)+'HZ.wav');
audiowrite(filename,y,f0);
sound(y,f0);
hold on
plot(t,y); legend('origin','recon');

%% 주파수부분에서 결과를 잘 확인하기 위해서
t_s2=t;%원래의 신호와 같은 길이를 갖도록
x_s2=zeros(1,length(x));
x_s2(1)=x(1);
for i1=2:length(t)
    if(mod(i1,sample_step)==0)
        x_s2(i1)=x(i1);
    end
end
%샘플링 된 값에 대해서는 그대로, 아닌 값에대해서는 0을 넣기

%% 주파수 영역

N=length(t);
f1=(-N/2:N/2-1)*(f0/N);

FT_x=abs(fftshift(fft(x)));
FT_x_s=abs(fftshift(fft(x_s2)));
FT_y=abs(fftshift(fft(y)));
figure(2);
subplot(3,1,1);plot(f1,10*log10(FT_x)); grid on;legend('Original');
subplot(3,1,2);plot(f1,10*log10(FT_x_s)); grid on;legend('Samling');
subplot(3,1,3);plot(f1,10*log10(FT_y)); grid on;legend('Reconstruction');











