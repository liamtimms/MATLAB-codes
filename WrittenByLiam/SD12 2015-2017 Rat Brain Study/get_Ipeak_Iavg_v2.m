function [I_peak, I_peak_std, I_avg, I_std, GOF] =get_Ipeak_Iavg_v2(Image, ROI)

% Median Filter of size 'filtsize' is used to smooth results below
% 'cutoff' is used to cut histogram of counts vs. intensity horizontally
% instead of thresholding. In this way we can grab bins with most counts,
% and follow peak instead of mean intensity per region. Visualize below by
% graphing data
filtsize=3;
cutoff=10;

% Select Region Post-contrast
%image=image.*mask; % 3-dimensional region selected

%Data=nonzeros(image); % 1D vector of nonzero values
%     % Select peak of histogram
%     nbins=max(image);
% %     nbins=1000;
%     [N,XX]=hist(image,nbins);
%     n=max(N); % n is max of intensity
%     N=N-n/cutoff;
%     N(N<0)=0;
%     N=medfilt1(N,filtsize);
%     I_peak=N*XX'/sum(N);

Data=Image.*ROI;
Data(isnan(Data))=0; %WTF NANS
Data=nonzeros(Data);

N=size(Data);

if N==[0,1]
    fprintf('Empty Region')
    I_peak=0;
    I_peak_std=0;
    I_avg=0;
    I_std=0;
    GOF=0;
else
    
    I_avg=mean(Data(:,1));
    I_std=std(Data(:,1));
    
    
    [counts,bins]=hist(Data,100);
    
    X(:,1)=bins(:);
    X(:,2)=medfilt1(counts(:),3);
    
    
    %
    %             k=2;
    %             GMModel = fitgmdist(X,k);
    %             Models.=GMModel;
    signal=X;
    %             center=(max(bins)-min(bins))/2;
    center=0;
    window=0;
    NumPeaks=1;
    peakshape=0;
    extra=0;
    NumTrials=2;
    
    [~,GOF,~,~,~,xi,yi]=peakfit(signal,center,window,NumPeaks,peakshape,extra,NumTrials);
    
    
    peak=0;
    for m=1:1:600
        if yi(m)>peak
            peak=yi(m);
            I_peak=xi(m);
        end
    end
    
    I_peak_std=0;
    diff=0;
    for m=1:1:600
        if abs(peak/2 - yi(m))<diff && peak~=0
            diff=abs(peak/2 - yi(n,m));
           I_peak_std=(abs(xi(m)-I_peak)*2)/2.355;
        end
    end

   
end


% % % % % % VISUALIZE Plots % % % % % % %
%     figure
%     hist(F,1000)
%     figure
%     plot(N,'*')
%     pause(1)
% % % % % % % % % % % % % % % % % % % % %
end