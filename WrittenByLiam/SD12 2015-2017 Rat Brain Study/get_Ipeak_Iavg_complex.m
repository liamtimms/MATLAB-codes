function [I_peak, I_avg, I_std] =get_Ipeak_Iavg_complex(image_R,image_I, mask)

% Median Filter of size 'filtsize' is used to smooth results below
% 'cutoff' is used to cut histogram of counts vs. intensity horizontally
% instead of thresholding. In this way we can grab bins with most counts,
% and follow peak instead of mean intensity per region. Visualize below by
% graphing data
    filtsize=3;
    cutoff=10;

    % Select Region Post-contrast
    image_R=abs(image_R).*mask; % 3-dimensional region selected (ABS)
    image_I=abs(image_I).*mask;
    
    image_R=nonzeros(image_R); % 1D vector of nonzero values
    image_I=nonzeros(image_I);
    
    peak=zeros(2,1);
    % Select peak of histogram
    nbins=max(image_R);
    [N,XX]=hist(image_R,nbins);
    n=max(N); % n is max of intensity
    N=N-n/cutoff;
    N(N<0)=0;
    N=medfilt1(N,filtsize);
    peak(1)=N*XX'/sum(N);
    
    nbins=max(image_I);
    [N,XX]=hist(image_I,nbins);
    n=max(N); % n is max of intensity
    N=N-n/cutoff;
    N(N<0)=0;
    N=medfilt1(N,filtsize);
    peak(2)=N*XX'/sum(N);
    
    I_peak=sqrt(peak(1)^2+peak(2)^2);
    
    I_avg=sqrt(mean(image_R)^2+mean(image_I)^2);
    I_std=(std(image_R)+std(image_I))/2;

    % % % % % % VISUALIZE Plots % % % % % % %
    % figure
    % hist(F,1000)
    % figure
    % plot(N,'*')
    % pause(1)
    % % % % % % % % % % % % % % % % % % % % %
end