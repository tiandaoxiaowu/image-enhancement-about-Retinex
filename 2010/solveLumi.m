function lumi = solveLumi(lumo,consts_map,consts_value,ci,levelNum,epsilonMap,lambda,win_size,multiGridFiltType,cie)          
  % a multigrid architecture

    if (~exist('lambda','var'))
        lambda = 1e6;
    end
    if (~exist('win_size','var'))
        win_size = 3;
    end
    if (~exist('epsilon','var'))
        multiGridFiltType = 1;
    end
    if (~exist('cie','var'))
        cie = 2;
    end    
% this function is recursion stucture, when recursion levelNum == 1, solveLumiFire will run.
    if (levelNum>1)
        slumo = imresize(lumo,0.5);
        sci = imresize( ci , 0.5 );
        sconsts_map = imresize(consts_map,0.5);
        sconsts_value = imresize(consts_value,0.5);
        sepsilonMap = imresize(epsilonMap,0.5);
%         slumo = downSmpIm(lumo,multiGridFiltType);
%         sci = downSmpIm( ci , multiGridFiltType );
%         sconsts_map = downSmpIm(consts_map,multiGridFiltType);
%         sconsts_value = downSmpIm(consts_value,multiGridFiltType);
%         sepsilonMap = downSmpIm(epsilonMap,multiGridFiltType);
        slumi = solveLumi(slumo,sconsts_map,sconsts_value,sci,levelNum-1,sepsilonMap,lambda,win_size,multiGridFiltType,cie);
        lumi = upSmpLumiByLinearCoeffs( slumi , slumo , lumo , sci , cie , epsilonMap ,win_size , multiGridFiltType );
    elseif (levelNum==1)
        consts_map = consts_map > 0.87;
        lumi=solveLumiFire( lumo , consts_map , consts_value , ci , epsilonMap , win_size , lambda , cie );
    end
end