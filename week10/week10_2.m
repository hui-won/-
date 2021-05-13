% 12181769 남희원 10주차 과제

clc; clear; close all;
%% load data 
loaded_data = load('homework.mat');

Height_ = loaded_data.Height_;
Width_ = loaded_data.Width_;
CH_ = loaded_data.CH_;
Level_binary = loaded_data.Level_binary;
h = loaded_data.h;
y1=loaded_data.y1;
y2=loaded_data.y2;
y3=loaded_data.y3;

%% recon
r1 = (conj(h)./abs(h).^2).*y1;
r2 = (conj(h)./abs(h).^2).*y2;
r3 = (conj(h)./abs(h).^2).*y3;

%bit reconstruction 
bit_stream_re1=real(r1) > 0;
bit_stream_re2=real(r2) > 0;
bit_stream_re3=real(r3) > 0;

% vector 
image_vec_re1 = reshape(bit_stream_re1,[Height_*Width_*CH_,Level_binary]);
image_vec_re1 = bi2de(image_vec_re1);
image_vec_re2 = reshape(bit_stream_re2,[Height_*Width_*CH_,Level_binary]);
image_vec_re2 = bi2de(image_vec_re2);
image_vec_re3 = reshape(bit_stream_re3,[Height_*Width_*CH_,Level_binary]);
image_vec_re3 = bi2de(image_vec_re3);

% image recon
image_re1 = uint8(reshape(image_vec_re1,[Height_,Width_,CH_]));
image_re2 = uint8(reshape(image_vec_re2,[Height_,Width_,CH_]));
image_re3 = uint8(reshape(image_vec_re3,[Height_,Width_,CH_]));

figure(1)
imshow(image_re1);
figure(2)
imshow(image_re2);
figure(3)
imshow(image_re3);
