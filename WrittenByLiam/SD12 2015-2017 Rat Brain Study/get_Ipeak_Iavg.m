function [I_peak, I_avg, I_std] =get_Ipeak_Iavg(image, mask)

% Median Filter of size 'filtsize' is used to smooth results below
% 'cutoff' is used to cut histogram of counts vs. intensity horizontally
% instead of thresholding. In this way we can grab bins with most counts,
% and follow peak instead of mean intensity per region. Visualize below by
% graphing data
    filtsize=3;
    cutoff=10;

    % Select Region Post-contrast
    image=image.*mask; % 3-dimensional region selected
    image=nonzeros(image); % 1D vector of nonzero values
    % Select peak of histogram
    nbins=max(image);
%     nbins=1000;
    [N,XX]=hist(image,nbins);
    n=max(N); % n is max of intensity
    N=N-n/cutoff;
    N(N<0)=0;
    N=medfilt1(N,filtsize);
    I_peak=N*XX'/sum(N);
    I_avg=mean(image);
    I_std=std(image);

    % % % % % % VISUALIZE Plots % % % % % % %
%     figure
%     hist(F,1000)
%     figure
%     plot(N,'*')
%     pause(1)
    % % % % % % % % % % % % % % % % % % % % %
end