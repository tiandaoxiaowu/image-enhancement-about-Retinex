function value = QM( method, in_Y )

% -------------------------------------------------------------------------
% This script evaluates the performance of CE algorithms using 4 quality
% metrics, "DE," "EME," "AB," and "PixDist."
% 
% DE (Discrete Entropy): C. E. Shannon, "A mathematical theory of
% communication," Bell Syst. Tech. J., vol. 27, pp. 623-656, Oct. 1948.
%
% EME (Measure of Enhancement): S. Again, B. Silver, and K. Panetta,
% "Transform coefficient histogram-based image enhancement algorithms using
% contrast entropy," IEEE Trans. Image Process., vol. 16, no. 3, pp.
% 741-758, Mar. 2007.
%
% AB (Average Brightness)
%
% PixDist: Z. Chen, B. R. Abidi, D. L. Page, and M. A. Abidi, "Gray-level
% grouping (GLG): An automatic method for optimized image contrast
% enhanceemnt-part I: The basic method," IEEE Trans. Image Process., vol.
% 15, no. 8, pp. 2290-2302, Aug. 2006.
%
% -------------------------------------------------------------------------
% Input variables
%   method: You can specify one of the evaluation methods.
%   in_Y  : input gray scale image, single channel.
% 
% -------------------------------------------------------------------------
%                           written by Chulwoo Lee, chulwoo@mcl.korea.ac.kr


w = 8;      % window size for EME

[R, C] = size(in_Y);


%% Quality measures
if strcmp(method, 'DE')
    
    h_in = zeros(256,1);

    for j=1:R
        for i=1:C
            ref = in_Y(j,i);

            h_in(ref+1,1) = h_in(ref+1,1) + 1;
        end
    end
    clear ref

    p_in = h_in/sum(h_in);
    tmp_sum = 0;
    for k=1:256
        if p_in(k,1) == 0
            continue
        else
            tmp_sum = tmp_sum - p_in(k,1)*log2(p_in(k,1));
        end
    end
    
    value = tmp_sum;
    clear tmp_sum
    
    
elseif strcmp(method, 'EME')
    
    tmp_sum = 0;
    for j=1:R/w
        for i=1:C/w
            
            J = (j-1)*w + 1;
            I = (i-1)*w + 1;
            
            tmp_block = in_Y(J:J+w-1, I:I+w-1);
            
            block_max = max(tmp_block(:));
            block_min = min(tmp_block(:));
            
            if block_max ==  block_min
                continue
            else
                tmp_sum = tmp_sum + 20*log(block_max/(block_min+1e-4));
            end
        end
    end
    
    value = tmp_sum/(R*C)*w^2;
    
    clear tmp_sum
    
    
elseif strcmp(method, 'AB')
    
    value = mean(in_Y(:));
    
    
elseif strcmp(method, 'PixDist')

    h_in = zeros(256,1);

    for j=1:R
        for i=1:C
            ref = in_Y(j,i);

            h_in(ref+1,1) = h_in(ref+1,1) + 1;
        end
    end
    clear ref
    
    tmp_sum = 0;
    for j=1:256
        for i=j:256
            tmp_sum = tmp_sum + h_in(j)*h_in(i)*(i-j);
        end
    end
    
    value = tmp_sum/(R*C*(R*C-1));
            
    
end




end

