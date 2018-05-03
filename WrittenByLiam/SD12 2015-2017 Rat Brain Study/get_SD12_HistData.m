function [counts,bins,smoothedcounts,meanOfData,stdOfData,medianOfData,modeOfData] =get_SD12_HistData(DataFor_hist,filtersize,binsize)
    
    nbins=(max(DataFor_hist)-min(DataFor_hist))/binsize;
    [counts,bins] = hist(DataFor_hist,nbins);
   smoothedcounts=medfilt1(counts,filtersize);
   
   meanOfData=mean(DataFor_hist);
   stdOfData=std(DataFor_hist);
    medianOfData=median(DataFor_hist);
    
    maxCounts=0;
    for i=1:1:nbins
        if maxCounts<smoothedcounts(i)
            maxCounts=smoothedcounts(i);
            modeOfData=bins(i);
        end
    end

end