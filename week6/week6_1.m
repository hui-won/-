%12181769 ����� 6���� �ǽ�
clc; clear; close all;
%% Eb/N0�� ���� N0 ����
syms Eb t Tb f 
%�ɺ��� ���� ����--> ���� ��ü�� ����
f=1/Tb;
phi_t=sqrt(2/Tb)*cos(2*pi*f*t);%phi_t�� symbolic 
%Eb=1;
N_bits=1e4;%1000�� bit
Eb_No_dB=-2:2:10;
ber_=zeros(size(Eb_No_dB));

coordi_=zeros(2,N_bits);
N_error=zeros(1,N_bits);
for j=1:length(Eb_No_dB)
    parfor i=1:N_bits
        b_=rand()>0.5;
        %binary bit
        %0.5���� ũ�� 1, ������ 0�� ����
        if b_==1
            sn_t=sqrt(Eb)*phi_t;
            %sn_t=sqrt(Eb);
        else
            sn_t=-sqrt(Eb)*phi_t;
            %sn_t=-sqrt(Eb);
        end

        sn_t_=subs(sn_t,Eb,1)%Eb�� 1mW��
        %�ɺ��� ������ subs�� ����ؼ� ���� �Ҵ�
        %Eb�ڸ��� 1�� �Ҵ��
        No=db2pow(-Eb_No_dB(j));
        %���ú� ���� �ƴ� �Ŀ��� �Է��ϱ� ����
        noise_=sqrt(No/2)*randn()*phi_t;
        %noise_=sqrt(No/2)*randn();
        %No�� ���� ������ ���� ��
        %����þ� �����̱� ������ ����þȺ����� ������
        %������ ���� �����̱� ������ ���� ��ȣ�� ������

        x_t=sn_t_+noise_; %����� ������ ��

        c_n_est=vpa(int(x_t*phi_t,t,[0,Tb]));
        %c_n_est=x_t;
        %����(int �Լ�)�� ��, vpa-->�Ҽ��� ���
        if c_n_est > 0
            b_est=1;
        else
            b_est=0;
        end
        %���� ���� 0���� ũ�� 1, ������ 0

        N_error(i)=(b_est~=b_);
        %������ ��ȣ�� ������ ��ȣ�� �ٸ� ��찡 error
        %������ ���� count
        %������ �߻��� ������ 1���� ����
        coordi_(1,i)=c_n_est;
        %��ǥ�� ����
    end
    ber_(j)= sum(N_error)/N_bits;
end

%ber= sum(N_error)/N_bits;

Eb_No_linear=db2pow(Eb_No_dB);
BER_AWGN_theory=1/2*erfc(sqrt(Eb_No_linear));
%�̷����� ��

%s1_t=sqrt(Eb)*phi_t;
%s0_t=-sqrt(Eb)*phi_t;
%s1_t_=subs(s1_t,Eb,1);c1_ =int(s1_t_*phi_t,t,[0,Tb]);
%s0_t_=subs(s0_t,Eb,1);c0_ =int(s0_t_*phi_t,t,[0,Tb]);
%������ �������� �ʾ��� �� 1�� ���� �ɺ��� 0�϶��� �ɺ��� ��ǥ ������� ���� ����� ����
%1�϶� ���� ������ �ɺ��� ���ؼ��� 0�϶��� �ɺ��� ���ؼ� �׸���

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
% %1�϶� ���� ������ �ɺ��� ���ؼ��� 0�϶��� �ɺ��� ���ؼ� �׸���
% p1=plot(coordi_(1,find(N_error)),coordi_(2,find(N_error)),'x');
% %������ �߻��� �ε����� ã�Ƽ� �ű⿡ ǥ��
% p2=plot(coordi_(1,setdiff(1:N_bits,find(N_error))),coordi_(2,setdiff(1:N_bits,find(N_error))),'o');
% %������ �߻����� ���� �ε����� ��ü �ε������� ������ -->������ �߻����� �ʾ������� ��
% set(p1,'markersize',8,'color','r','linewidth',2);
% set(p2,'markersize',2,'color','g');
% axis([-2,2,-0.1,0.1]);
% set(gca,'ytick',-1:2:1);


