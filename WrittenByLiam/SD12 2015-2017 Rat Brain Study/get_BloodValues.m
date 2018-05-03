%% Version 4 from BloodValues.m moved to a function for ease of use and memory concerns

function [BloodFromPeak, BloodFromPeakStd, ROIave, ROIStds, BloodTQAve, BloodTQStd, BloodMax] =get_BloodValues(k)

modality='UTE3D';
model='rSD12';
mask=zeros(200,200,200);
mask(:,:,50:100)=1;

BloodFromPeak=0; BloodFromPeakStd=0; ROIave=0; ROIStds=0;

for i=1:1:12
    
    
    
    an_num=sprintf('%d', i);
    folder='SD12_RAT_EXTRACTED_CORRECTED_CROPPED_ALIGNED_ABS';
    Subject=strcat(model, '_', an_num, '_', modality);
    
    if i==7
        totscan=7;
    elseif i==12
        totscan=6;
    else
        totscan=5;
    end
    
    
    
    for j=1:1:totscan
        
        
        if j==1
            ROI_scn_num=sprintf('%d', 2);
        else
            ROI_scn_num=sprintf('%d', j);
        end
        
        file=strcat(Subject, '_UTEscan', ROI_scn_num, '_MAGNITUDE_IMAGE_CORRECTED_CROPPED_METH2');
        if j==totscan
            file=strcat(file, '_auto2_SSS');
        end
        
        loadname=strcat(folder, '\', file, '-label.nii');
        ROINii=load_nii(loadname);
        ROI=double(ROINii.img);
        ROI=ROI.*mask;
        
        scn_num=sprintf('%d', j);
        
        %         for k=1:1:3
        clear type
        
        l=0;
        if k==1
            type='REAL';
        elseif k==2
            type='IMAGINARY';
        elseif k==3
            type='MAGNITUDE';
            l=1;
        end
        
        
        file=strcat(Subject, '_UTEscan', scn_num, '_', type, '_IMAGE_CORRECTED_CROPPED');
        
        if l==0
            file=strcat(file, '_ABS');
        elseif l==1
            file=strcat(file, '_METH2');
        end
        
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
            
            
            
            %             if k==3
            %                 if j==1
            %                     fit_bins1(i,:)=xi(:);
            %                     fit_curve1(i,:)=yi(:);
            %                     raw_bins1(i,:)=X(:,1);
            %                     raw_hist1(i,:)=X(:,2);
            %                 elseif j==2
            %                     fit_bins2(i,:)=xi(:);
            %                     fit_curve2(i,:)=yi(:);
            %                     raw_bins2(i,:)=X(:,1);
            %                     raw_hist2(i,:)=X(:,2);
            %                 elseif j==3
            %                     fit_bins3(i,:)=xi(:);
            %                     fit_curve3(i,:)=yi(:);
            %                     raw_bins3(i,:)=X(:,1);
            %                     raw_hist3(i,:)=X(:,2);
            %                 elseif j==4
            %                     fit_bins4(i,:)=xi(:);
            %                     fit_curve4(i,:)=yi(:);
            %                     raw_bins4(i,:)=X(:,1);
            %                     raw_hist4(i,:)=X(:,2);
            %                 elseif j==5
            %                     fit_bins5(i,:)=xi(:);
            %                     fit_curve5(i,:)=yi(:);
            %                     raw_bins5(i,:)=X(:,1);
            %                     raw_hist5(i,:)=X(:,2);
            %                 elseif j==6
            %                     fit_bins6(i,:)=xi(:);
            %                     fit_curve6(i,:)=yi(:);
            %                     raw_bins6(i,:)=X(:,1);
            %                     raw_hist6(i,:)=X(:,2);
            %                 elseif j==7
            %                     fit_bins7(i,:)=xi(:);
            %                     fit_curve7(i,:)=yi(:);
            %                     raw_bins7(i,:)=X(:,1);
            %                     raw_hist7(i,:)=X(:,2);
            %                 end
            %             end
            
            %         end
            
        end
    end
    
end

end