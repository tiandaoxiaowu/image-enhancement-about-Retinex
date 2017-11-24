function [S,B]=getLaplacian4(lumin,win_size,epsilonMap,ci,cie,allowedMemorySize)
% this function create the linear system [S,B] follow the (17)(18)
    if (~exist('cie','var'))
        cie = 0;
    end

    [height,width]=size(lumin);
    hwinSize = (win_size-1)/2;

    indxM = reshape( 1:(height*width) , [height,width] );
    
    vCount = (win_size.^4)*height*width;
    vy = zeros( vCount , 1 );
    vx = zeros( vCount , 1 );    
    vv = zeros( vCount , 1 );
    cvCount = 0;

    B = zeros( height*width , 1 );
    
    for iwidth=1:width
        xstart = max(1,iwidth-hwinSize);
        xend = min(width,iwidth+hwinSize);
        for iheight=1:height
            ystart = max(1,iheight-hwinSize);
            yend = min(height,iheight+hwinSize);
            m = (yend-ystart+1)*(xend-xstart+1);
            if (iheight <= size(epsilonMap,1)  && iwidth <= size(epsilonMap,2)  )
                epsilon = epsilonMap( iheight , iwidth );
            else
                epsilon = 0.1;
            end
            
            winLum = lumin( ystart:yend , xstart:xend );
            indx = indxM( ystart:yend , xstart:xend );
            
            eCount = (xend-xstart+1).*(yend-ystart+1);
            twinLum = winLum(:);
            twinLum1 = repmat( twinLum , [1 eCount] );
            twinLum2 = repmat( twinLum' , [eCount 1] );
            tindx = indx(:);
            tindx1 = repmat( tindx , [1 eCount] );
            tindx2 = repmat( tindx' , [eCount 1] );
            
            tci = ci(iheight,iwidth);
            tvar = std( twinLum , 1 ).^2;
            tdelta = tvar+(epsilon./m).*(tci.^(-cie));
            tmean = mean( twinLum );
            
            %tval = (tindx1==tindx2)-((twinLum1-tmean).*(twinLum2-tmean)+tdelta)./(m*tdelta);
            tval = (tindx1==tindx2)-((twinLum1-tmean).*(twinLum2-tmean)./tdelta+1)./(m);
            
            vIncrease = length(tval(:));            
            vy(cvCount+1:cvCount+vIncrease) = tindx1(:);
            vx(cvCount+1:cvCount+vIncrease) = tindx2(:);            
            vv(cvCount+1:cvCount+vIncrease) = tval(:);            
            cvCount=cvCount+vIncrease;            

            B(tindx) = B(tindx)+( twinLum - tmean ).*(epsilon./(m*tdelta*(tci.^(cie-1))));

        end
    end
    
    vy=vy(1:cvCount);
    vx=vx(1:cvCount);
    vv=vv(1:cvCount);
    
    S = sparse(vy,vx,vv, height*width , height*width);
end


