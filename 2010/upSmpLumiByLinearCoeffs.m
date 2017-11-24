function blumi = upSmpLumiByLinearCoeffs( lumi , lumo , blumo , ci , cie, ...
                epsilonMap ,win_size , multiGridFiltType )

    coeffs = getLinearCoeffs( lumi , lumo , ci, cie , epsilonMap ,win_size );
    
    bcoeff = imresize(coeffs,[size(blumo,1),size(blumo,2)],'bilinear');
   % bcoeff = upSmpIm(coeffs,[size(blumo,1),size(blumo,2)],multiGridFiltType);
    
    blumi=bcoeff(:,:,1).*blumo(:,:,1)+bcoeff(:,:,2);

end