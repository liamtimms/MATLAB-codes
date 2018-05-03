%% Version 4 from BloodValues.m moved to a function for ease of use and memory concerns

function [BloodFromPeak, BloodFromPeakStd, ROIave, ROIStds, BloodTQAve, BloodTQStd, BloodMax] =get_BloodValues_APOEneg()

modality='UTE3D';
model='APOEneg';
mask=zeros(200,200,200);
mask(:,:,90:110)=1;

BloodFromPeak=0; BloodFromPeakStd=0; ROIave=0; ROIStds=0;

for i=1:1:17
    
    if i==1 ||  i==4 ||  i==5 ||  i==11 ||  i==12 ||  i==15 || i==17
        totscan=2;
    else
        totscan=1;
    end
    
    an_num=sprintf('%d', i);
    folder='APOEneg_EXTRACTED';
    
    clear ROI;
    
    for j=1:1:totscan
        
        if j==1
            Subject=strcat(model, an_num, '_postcon_', modality);
            file=strcat(Subject, '_MAGNITUDE_IMAGE');
            loadname=strcat('APOEneg_SSS_Labels\', file, '-label.nii');
            ROINii=load_nii(loadname);
            ROI=double(ROINii.img);
            ROI=ROI.*mask;
        else
            Subject=strcat('r',model, an_num, '_precon_', modality);
        end
        
        file=strcat(Subject, '_MAGNITUDE_IMAGE');
        loadname=strcat(folder, '\', file, '.nii');
        CurrentNii=load_nii(loadname);
        Image=double(CurrentNii.img);
        Data=Image.*ROI;
        Data(isnan(Data))=0; %WTF NANS
        Data=nonzeros(Data);
        
        ROIave(i,j)=mean(Data(:,1));
        ROIStds(i,j)=std(Data(:,1));
        
        [counts,bins]=hist(Data,100);
        
        X(:,1)=bins(:);
        X(:,2)=medfilt1(counts(:),3);
        
        %%%%%%% cut bottom %%%%%%%%%%%%%%%%
        nbins=max(Data);
        [counts,bins]=hist(Data,100);
        NN=counts;
        XX=bins;
        nn=max(NN); % n is max of intensity
        NN=NN-nn/5;
        NN(NN<0)=0;
        NN=medfilt1(NN,3);
        I_peak(i,1)=NN*XX'/sum(NN);
        
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        
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
        NumTrials=5;
        
        %             figure
        [~,GOF,~,~,~,xi,yi]=peakfit(signal,center,window,NumPeaks,peakshape,extra,NumTrials);
        
        if GOF<.07
            fprintf('Note: there is a poor fit for animal %d, scan %d \n', i, j)
        else
            
            %[M,I]=max(yi);
            %ModeVals(i,j,k)=xi(I);
            peak=0;
            diff=10000;
            for m=1:1:600
                if yi(m)>peak
                    peak=yi(m);
                    BloodFromPeak(i,j)=xi(m);
                end
            end
            
            
            for m=1:1:600
                if abs(peak/2 - yi(m))<diff && peak~=0
                    diff=abs(peak/2 - yi(m));
                    BloodFromPeakStd(i,j)=(abs(xi(m)-BloodFromPeak(i,j))*2)/2.355;
                end
            end
            
            BloodMax(i,j)=max(Data);
            
            Data2=nonzeros(Data);
            
            for blah=1:1:2
                cut=median(Data2);
                Data2(Data2<cut)=0;
                Data2=nonzeros(Data2);
            end
            
            BloodTQAve(i,j)=mean(Data2);
            BloodTQStd(i,j)=std(Data2);

            
        end
    end
    
end

end