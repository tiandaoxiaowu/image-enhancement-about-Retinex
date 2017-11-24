function [ v2 ] = gum( x1 )
[ m, n, k ] = size( x1 );
x = x1;
mask = ( 1 / 25 ) * ones( 5, 5 );
y1 = conv2( x, double( mask ), 'same' );
d = x - y1;
g = 3 .* d;
v1 = y1 + g;
y2 = medfilt2( x, [ 3, 3 ] );
X = ( 1 - x ) ./ max( x, 0.01 );
Y = ( 1 - y2 ) ./ max( y2, 0.01 );
I = ones( m, n );
d1 = I ./ ( 1 + ( X ./ Y ) );
h = adapthisteq( y2, 'clipLimit', 0.005 );
c = ( 2 .* d1 ) - 1;
Gmax = 5;Gmin = 1;eta = 0.5;
beta = ( Gmax - Gmin ) / ( 1 - exp(  - 1 ) );
alpha = ( Gmax - beta );
gama = alpha + ( beta * exp(  - 1 .* abs( c ) .^ eta ) );
D = ( 1 - d1 ) ./ max( d1, 0.01 );
g = I ./ ( 1 + D .^ gama );
G = ( 1 - g ) ./ max( g, 0.01 );
H = ( 1 - h ) ./ max( h, 0.01 );
v2 = I ./ max( 0.1, ( 1 + ( H .* G ) ) );
t = v2 > 1;
v2( t ) = x( t );
end 