%%%%%%% The calculation is in HSV space

clc;
clear all;
img = imread('1.jpg'); 
alpha = 1000;  beta= 0.01;  gamma = 0.1;  lambda = 10; % 相关参数设置

error_R = 10; error_I = 10;      % initial stopping criteria error_R and error_I
stop = 0.1;                      % stopping criteria
HSV = rgb2hsv( double(img) );    % RGB space to HSV  space

S = HSV(:,:,3);                  % V layer

[ R, I, error_R, error_I ] = processing( S, alpha, beta, gamma, lambda, error_R, error_I, stop);



% Gamma correction  
gamma1 = 2.2;
I_0 = mean( R( : ) );
I_0;
I_gamma = 255 * ( (I/255).^(1/gamma1) );
enhanced_V = R .* I_gamma;
HSV(:,:,3) = enhanced_V;
enhanced_result = hsv2rgb(HSV);  %  HSV space to RGB space
enhanced_result = cast(enhanced_result, 'uint8');
%imwrite(enhanced_result,'enhanced_result12.jpg');
%R=cast(R, 'uint8');
%imwrite(R,'F:\胥培\R\R17.jpg');
%imwrite(uint8(I),'F:\胥培\I\I17.jpg');
%figure,imshow(img),title('observed image');
figure,imshow(enhanced_result),title('Gamma correction');
figure,imshow(uint8(I)),title('estimated illumination');
figure,imshow(R),title('estimated reflectance')