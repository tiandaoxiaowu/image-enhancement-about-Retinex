function [ R, I, error_R, error_I ] = processing( S, alpha, beta, gamma, lambda, error_R, error_I, error )%bete数据为0.01，为10
H = fspecial( 'gaussian' );%默认产生3*3的高斯矩阵
%img1=imread('F:\亮度1\1.jpg');
%I1=double(img1);
I1 = S;%进行3*3高斯滤波
%enhanced_result = cast(I1, 'uint8');
%imwrite(enhanced_result,'enhanced_result.png');
%I1=double(enhanced_result);
I_0 = mean( S( : ) );
R = zeros( size( S ) );
I = zeros( size( S ) );
b_y = zeros( size( S ) );
b_x = zeros( size( S ) );
R1 = R;
eigsDtD = getC( S );
while error_R > error || error_I > error
if error_R > error
    
[ R, b_x, b_y ] = solving( S, I1, R1, beta, lambda, b_y, b_x );
error_R = norm( ( R - R1 ), 2 ) / norm( R1, 2 );
R1 = R;

end 


if error_I > error

temp = fft2( S ./ max( R, 0.001 ) + gamma * I_0 );
I1 = ifft2( temp ./ ( ( 1 + gamma ) + alpha * eigsDtD ) );
I1 = real( I1 );
I1 = max( I1, S );
error_I = norm( ( I - I1 ), 2 ) / norm( I1, 2 );
I = I1;

end 

R = min( 1, max( 0, R ) );
end 


function [ R, b_x, b_y ] = solving( S, L, R1, beta, lambda, b_y, b_x )

h = [ diff( R1, 1, 2 ), R1( :, 1, : ) - R1( :, end , : ) ];
v = [ diff( R1, 1, 1 );R1( 1, :, : ) - R1( end , :, : ) ];

V1 = h + b_y;
V2 = v + b_x;

d_y = max( abs( V1 ) - 1 / ( 2 * lambda ), 0 ) .* sign( V1 );
d_x = max( abs( V2 ) - 1 / ( 2 * lambda ), 0 ) .* sign( V2 );

Normin1 = fft2( S ./ max( L, 1 ) );
Denormin2 = getC( S );
Denormin = 1 + beta * lambda * Denormin2;
tmpd_y = d_y - b_y;
tmpd_x = d_x - b_x;

Normin2 = [ tmpd_y( :, end , : ) - tmpd_y( :, 1, : ),   -diff( tmpd_y, 1, 2 ) ];
Normin2 = Normin2 + [ tmpd_x( end , :, : ) - tmpd_x( 1, :, : ); -diff( tmpd_x, 1, 1 ) ];
FS = ( Normin1 + beta * lambda * fft2( Normin2 ) ) ./ Denormin;
R = real( ifft2( FS ) );

b_y = b_y - ( d_y - [ diff( R, 1, 2 ), R( :, 1, : ) - R( :, end , : ) ] );
b_x = b_x - ( d_x - [ diff( R, 1, 1 );R( 1, :, : ) - R( end , :, : ) ] );

end 

function eigsDtD = getC( F )
fx = [ 1,  - 1 ];
fy = [ 1; - 1 ];
[ N, M, D ] = size( F );
sizeI2D = [ N, M ];
otfFx = psf2otf( fx, sizeI2D );
otfFy = psf2otf( fy, sizeI2D );
eigsDtD = abs( otfFx ) .^ 2 + abs( otfFy ) .^ 2;
end 

end 


