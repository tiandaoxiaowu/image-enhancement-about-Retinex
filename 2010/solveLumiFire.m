function lumi=solveLumiFire( lumo , consts_map , consts_value , ci , epsilonMap , win_size , lambda , cie )
    allowedMemorySize = 3e8;
    [height,width]=size(lumo);
% create the linear system [S,B] as [17]
    [S,B]=getLaplacian4(lumo,win_size,epsilonMap,ci,cie,allowedMemorySize);
    rlength = height*width;
    cconsts_map = consts_map(:);
    cconsts_value = consts_value(:);
    Sp = S + spdiags( cconsts_map , 0 , rlength , rlength ).*lambda;
    Bp = cconsts_value.*cconsts_map.*lambda+B;
    
    tol = 1e-6;
    tol = tol./norm(Bp);
    maxIt = 2000;
        
     
    lguess = lumo.*ci;
    lguess = lguess(:);
% solve  the linear system
    lumi = symmlq( Sp , Bp , tol , maxIt , [] , [] , lguess );
    lumi = reshape( lumi , [height,width] );
end