% 12181769 남희원 10주차 실습
clc; clear; close all;

% load image
image_ori=imread('original.jpg');
image_height=size(image_ori,1);
image_width=size(image_ori,2);
image_ch=size(image_ori,3);
level=double(max(max(max(image_ori))));%몇 개의 비트가 필요한지
level_binary=ceil(log2(level));%올림 값을 사용(cei)

%figure(1)
%imshow(image_ori)

% vectorization
image_vec=image_ori(:);%reshape사용해도 되고, :을 써도 됨

% decimal to binary
image_bi = de2bi(image_vec);
bit_stream=image_bi(:);%다시 vectorization
% 부호화가 된 비트

% BPSK modulation
s=2*double(bit_stream)-1;%1->1, 0->-1

% fading channel
h = (randn(length(s),1)+1i*randn(length(s),1))*sqrt(2);

noise_=-15;
% noise(-10dB)
n = (randn(length(s),1)+1i*randn(length(s),1))*sqrt(db2pow(noise_)/2);

y = h.*s + n;%신호
%element별로 곱할때는 .*, 더하기는 상관 없음
%자료형이 안맞는 경우 오류가 날 수 있음

r = (conj(h)./abs(h).^2).*y; %채널 보상 팩터 곱하기

bit_stream_re = real(r) > 0; %비트 복원

% 이미지 벡터 복원
image_vec_re = reshape(bit_stream_re,[image_height*image_width*image_ch,level_binary]);
image_vec_re = bi2de(image_vec_re);

image_re = uint8(reshape(image_vec_re,[image_height,image_width,image_ch]));

figure(2)
imshow(image_re)

ber= sum(s ~= bit_stream_re)/length(s);





