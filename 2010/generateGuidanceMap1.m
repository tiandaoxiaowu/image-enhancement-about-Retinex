function ci=generateGuidanceMap1( lumo , win_size , kappa , beta1 , beta2 , beta3 )

    hwinSize = (win_size-1)/2;
    meanFilter = ones( win_size , win_size );
    meanFilter = meanFilter./sum(sum(meanFilter));
    meanLum = imfilter( lumo , meanFilter , 'corr' , 'replicate' );
    tlumin = padarray( lumo , [hwinSize,hwinSize] , 'replicate' , 'both' );
    stdLum = colfilt( tlumin , [win_size,win_size] , 'sliding' , @std );
    stdLum = stdLum( 1+hwinSize:end-hwinSize , 1+hwinSize:end-hwinSize );
    clear tlumin;
    
    ci = (meanLum.^beta1).*(stdLum.^beta2).*(lumo.^beta3)+kappa;
    ci = ci*0.2;
    ci = ci.^(-1);
end