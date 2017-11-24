% function mainEntry1()
% read the image and data initiation 
%     image_name = '_example.pfm';
%     imageData = getpfmraw(image_name);
%     imageData = imageData(end:-1:1,:,:);
%     imageData = double(imageData);
%     tlum = rgb2hsv(imageData);
%     tlum = tlum(:,:,3);
%     imageData = imageData.*(200./(mean(mean(mean(tlum)))));
    imageData=double(imread('F:\xp\对比实验\实验原图\13.jpg'));
    lumo = rgb2hsv(imageData);
    lumo = lumo(:,:,3);
    figure,imshow(uint8(lumo));

    if (min(lumo(:))<1e-3)
        lumo=lumo+1e-3;
    end 
    [height,width]=size(lumo);
  
    kappa = 0.5;
    consts_map = zeros(height,width);
    consts_value = zeros(height,width);
    levelNum = 3;   % maltigrid recursion num 
% set the important parameter  
    epsilon = 0.1;
    lambda = 0;
    win_size = 3;
    multiGridFiltType = 2;
    beta1 = 1.2;
    beta2 = 0.0;
    beta3 = 0.;
    s_sat = 0.6;

% create the map matrix ci as (6)   
    ci = generateGuidanceMap1( lumo , win_size , kappa , beta1 , beta2 , beta3 );

% maltigrid architecture function establish and solve the linear system in (17)
    lumi = solveLumi(lumo,consts_map,consts_value,ci,levelNum,epsilon,lambda,win_size,multiGridFiltType);
    
    lumi = im_norm(lumi);

% the RGB channels are reconstucted in (5)    
    rgbRatio = imageData./(repmat(lumo,[1,1,3])+1e-9);
    retRGB = (rgbRatio.^s_sat).*(repmat(lumi,[1,1,3]));


    nidata = cutPeakValley( retRGB , 0.5 , 0.5 );
    figure,imshow( nidata );
    imwrite(nidata,'F:\xp\对比实验\2010-GLOW\13.jpg');
% end