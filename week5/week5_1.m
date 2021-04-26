%12181769 남희원 5주차 실습
clc;clear all;close all;

%% 원신호 sin 함수 그리기
T0=0.001;
f0=1/T0;
start_time=0;
finish_time=2*pi;
t1=start_time:T0:finish_time;

x=2*sin(4*pi*t1)+cos(6*pi*t1)+1;
Max=max(x);
Min=min(x);

%% 샘플링 신호 생성
fs=8;
ts=1/fs;
sample_step=floor(ts/T0);

t2=start_time:ts:finish_time;
N_ts=length(t2);

x_s=zeros(1,N_ts);
x_s(1)=x(1);
for i=1:length(t2)-1
    x_s(i+1)=x(1+i*sample_step);
end

%% 양자화 진행

Q_level=64;
Q_step=(Max-Min)/Q_level;
%신호의 범위를 양자회 레벨로 구분
Q=zeros(1,Q_level);

for i1=1:Q_level
    Q(i1)=Q_step*(i1-1)+Min;
end


%샘플링 신호를 양자화 x_q로 변환
x_q=zeros(1,N_ts);
for i1=1:N_ts
    for i2=1:Q_level
        if((x_s(i1)>=Q(i2)) && (x_s(i1)<=Q(i2)+Q_step))
            x_q(i1)=i2-1;
        end
    end
end

%% 부호화
temp=dec2bin(x_q);
x_en=reshape(temp',1,numel(temp));

%% 복호화
N_bit=log2(Q_level);
temp=(reshape(x_en,N_bit,N_ts))';

x_de=zeros(1,N_ts);
for i1=1:N_ts
    x_de(i1)=Q_step*bin2dec(temp(i1,:))+Q_step/2+Min;
end

%% 복원
y=zeros(1,length(t1));
for i1=1:N_ts
    y=y+x_de(i1)*sinc((t1-(i1-1)*ts)/ts);
end

figure;
subplot(3,1,1);plot(t1,x);hold on;stem(t2,x_s);grid on;
xlabel('Time [s]');ylabel('Amplitude');axis([start_time finish_time Min Max]);
legend('Original','Sampling');
subplot(3,1,2);stem(t2,x_s);hold on;plot(t2,x_de,'x');grid on;
xlabel('Time [s]');ylabel('Amplitude');axis([start_time finish_time Min Max]);
legend('Sampling','Quantization');
subplot(3,1,3);plot(t1,x);hold on;plot(t1,y);grid on;
xlabel('Time [s]');ylabel('Amplitude');axis([start_time finish_time Min Max]);
legend('Original','Reconstruction');

%% 양자화 잡은 전력

% 이론값
Nq_th=(Q_step^2)/12;

% 측정값
Nq=mean((x_s-x_de).^2);