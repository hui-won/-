% 12181769 ����� 10���� �ǽ�
clc; clear; close all;

% load image
image_ori=imread('original.jpg');
image_height=size(image_ori,1);
image_width=size(image_ori,2);
image_ch=size(image_ori,3);
level=double(max(max(max(image_ori))));%�� ���� ��Ʈ�� �ʿ�����
level_binary=ceil(log2(level));%�ø� ���� ���(cei)

%figure(1)
%imshow(image_ori)

% vectorization
image_vec=image_ori(:);%reshape����ص� �ǰ�, :�� �ᵵ ��

% decimal to binary
image_bi = de2bi(image_vec);
bit_stream=image_bi(:);%�ٽ� vectorization
% ��ȣȭ�� �� ��Ʈ

% BPSK modulation
s=2*double(bit_stream)-1;%1->1, 0->-1

% fading channel
h = (randn(length(s),1)+1i*randn(length(s),1))*sqrt(2);

noise_=-15;
% noise(-10dB)
n = (randn(length(s),1)+1i*randn(length(s),1))*sqrt(db2pow(noise_)/2);

y = h.*s + n;%��ȣ
%element���� ���Ҷ��� .*, ���ϱ�� ��� ����
%�ڷ����� �ȸ´� ��� ������ �� �� ����

r = (conj(h)./abs(h).^2).*y; %ä�� ���� ���� ���ϱ�

bit_stream_re = real(r) > 0; %��Ʈ ����

% �̹��� ���� ����
image_vec_re = reshape(bit_stream_re,[image_height*image_width*image_ch,level_binary]);
image_vec_re = bi2de(image_vec_re);

image_re = uint8(reshape(image_vec_re,[image_height,image_width,image_ch]));

figure(2)
imshow(image_re)

ber= sum(s ~= bit_stream_re)/length(s);





