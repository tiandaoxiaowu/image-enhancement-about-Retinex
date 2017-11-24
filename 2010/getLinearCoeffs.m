function linearCoeffs = getLinearCoeffs( lumi , lumo , ci , cie , epsilonMap ,win_size )
    [height,width]=size(lumo);
    hwinSize = (win_size-1)/2;
    
    linearCoeffs = zeros( height , width , 2 );
    
    for iwidth=1:width
        xstart = max(1,iwidth-hwinSize);
        xend = min(width,iwidth+hwinSize);
        for iheight=1:height
            ystart = max(1,iheight-hwinSize);
            yend = min(height,iheight+hwinSize);
            m = (yend-ystart+1)*(xend-xstart+1);
            if (iheight <= size(epsilonMap,1)  && iwidth <= size(epsilonMap,2)  )
               epsilon = epsilonMap( iheight,iwidth );
            else
                epsilon = 0.1;
            end
            
            winLumo = lumo( ystart:yend , xstart:xend );
            winLumi = lumi( ystart:yend , xstart:xend );
            
            tvar = std( winLumo(:) , 1 ).^2;
            tci = ci(iheight,iwidth);
            tdelta = tvar + (epsilon./m).*(tci.^(-cie));            
            tmean = mean(mean(winLumo));
            invHi = [1 -tmean; -tmean tdelta+tmean*tmean]./(m*tdelta);
            etai = [ epsilon/tci+sum(sum(winLumo.*winLumi)) ; sum(sum(winLumi)) ];
            
            linearCoeffs(iheight,iwidth,:)=(invHi*etai)/0.8;
        end
    end
end