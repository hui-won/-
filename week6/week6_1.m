%12181769 남희원 6주차 실습
clc; clear; close all;
%% Eb/N0에 따른 N0 설정
syms Eb t Tb f 
%심볼릭 변수 정의--> 문자 자체를 저장
f=1/Tb;
phi_t=sqrt(2/Tb)*cos(2*pi*f*t);%phi_t도 symbolic 
%Eb=1;
N_bits=1e4;%1000개 bit
Eb_No_dB=-2:2:10;
ber_=zeros(size(Eb_No_dB));

coordi_=zeros(2,N_bits);
N_error=zeros(1,N_bits);
for j=1:length(Eb_No_dB)
    parfor i=1:N_bits
        b_=rand()>0.5;
        %binary bit
        %0.5보다 크면 1, 작으면 0을 리턴
        if b_==1
            sn_t=sqrt(Eb)*phi_t;
            %sn_t=sqrt(Eb);
        else
            sn_t=-sqrt(Eb)*phi_t;
            %sn_t=-sqrt(Eb);
        end

        sn_t_=subs(sn_t,Eb,1)%Eb에 1mW로
        %심볼릭 변수는 subs를 사용해서 값을 할당
        %Eb자리에 1이 할당됨
        No=db2pow(-Eb_No_dB(j));
        %데시벨 값이 아닌 파워로 입력하기 위해
        noise_=sqrt(No/2)*randn()*phi_t;
        %noise_=sqrt(No/2)*randn();
        %No의 잡음 전력을 값는 값
        %가우시안 잡음이기 때문에 가우시안분포를 곱해줌
        %기저에 대한 잡음이기 때문에 기저 신호를 곱해줌

        x_t=sn_t_+noise_; %노이즈가 더해진 식

        c_n_est=vpa(int(x_t*phi_t,t,[0,Tb]));
        %c_n_est=x_t;
        %적분(int 함수)한 식, vpa-->소수점 사용
        if c_n_est > 0
            b_est=1;
        else
            b_est=0;
        end
        %적분 값이 0보다 크면 1, 작으면 0

        N_error(i)=(b_est~=b_);
        %복원한 신호와 원래의 신호가 다른 경우가 error
        %에러의 개수 count
        %에러가 발생할 때마다 1값을 저장
        coordi_(1,i)=c_n_est;
        %좌표값 저장
    end
    ber_(j)= sum(N_error)/N_bits;
end

%ber= sum(N_error)/N_bits;

Eb_No_linear=db2pow(Eb_No_dB);
BER_AWGN_theory=1/2*erfc(sqrt(Eb_No_linear));
%이론적인 값

%s1_t=sqrt(Eb)*phi_t;
%s0_t=-sqrt(Eb)*phi_t;
%s1_t_=subs(s1_t,Eb,1);c1_ =int(s1_t_*phi_t,t,[0,Tb]);
%s0_t_=subs(s0_t,Eb,1);c0_ =int(s0_t_*phi_t,t,[0,Tb]);
%에러가 더해지지 않았을 때 1일 때의 심볼과 0일때의 심볼의 좌표 찍기위한 값을 만들기 위해
%1일때 값을 가지는 심볼에 대해서와 0일때의 심볼에 대해서 그리기

figure
hold on; grid on
xlabel('Eb/No [dB]');ylabel('BER');
q1=plot(Eb_No_dB,ber_,'o');set(q1,'markersize',5,'markerEdgeColor','b','MarkerFaceColor','b')
q2=plot(Eb_No_dB,BER_AWGN_theory);
legend('BER','BER theory');
axis([-2,10,1e-5,1]);
set(gca,'yscale','log');
% 
% q1=plot(c1_,0,'o');set(q1,'markersize',15,'markerEdgeColor','b','MarkerFaceColor','b')
% q2=plot(c0_,0,'o');set(q2,'markersize',15,'markerEdgeColor','b','MarkerFaceColor','b')
% %1일때 값을 가지는 심볼에 대해서와 0일때의 심볼에 대해서 그리기
% p1=plot(coordi_(1,find(N_error)),coordi_(2,find(N_error)),'x');
% %에러가 발생한 인덱스를 찾아서 거기에 표시
% p2=plot(coordi_(1,setdiff(1:N_bits,find(N_error))),coordi_(2,setdiff(1:N_bits,find(N_error))),'o');
% %에러가 발생했을 때의 인덱스를 전체 인덱스에서 차집합 -->에러가 발생하지 않았을때의 값
% set(p1,'markersize',8,'color','r','linewidth',2);
% set(p2,'markersize',2,'color','g');
% axis([-2,2,-0.1,0.1]);
% set(gca,'ytick',-1:2:1);


