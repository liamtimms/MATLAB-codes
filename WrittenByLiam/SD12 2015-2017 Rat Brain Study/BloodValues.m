%% Version 1 using combination of "potLabel" and a hand drawn label cropping out the SSS and that other vessel which goes down into the brain

modality='UTE3D';
model='rSD12';

for i=1:1:10
    
    
    an_num=sprintf('%d', i);
    folder1='SD12_RAT_EXTRACTED_CORRECTED_CROPPED_ALIGNED_ABS';
    %folder2=strcat(folder1, '_CORRECTED');
    Subject=strcat(model, '_', an_num, '_', modality);
    
    
    if i==7
        totscan=7;
    elseif i==12
        totscan=6;
    else
        totscan=5;
    end
    
    scn_num=sprintf('%d', totscan);
    
    file=strcat(Subject, '_UTEscan', scn_num, '_MAGNITUDE_IMAGE_CORRECTED_CROPPED_METH2_PotLabel');
    loadname=strcat(folder1, '\', file, '.nii');
    ROINii1=load_nii(loadname);
    
    file=strcat(Subject, '_UTEscan', scn_num, '_MAGNITUDE_IMAGE_CORRECTED_CROPPED_METH2-label');
    loadname=strcat(folder1, '\', file, '.nii');
    ROINii2=load_nii(loadname);
    
    ROI1=double(ROINii1.img);
    ROI2=double(ROINii2.img);
    ROI=ROI1.*ROI2;
    %     ROI=uint32(ROI);
    
    for j=1:1:totscan
        scn_num=sprintf('%d', j);
        
        for k=1:1:3
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
            
            loadname=strcat(folder1, '\', file, '.nii');
            CurrentNii=load_nii(loadname);
            Image=double(CurrentNii.img);
            %             Image=uint32(Image);
            Data=Image.*ROI;
            Data(isnan(Data))=0; %WTF NANS
            Data=nonzeros(Data);
            
            BloodValueMeans(i,j,k)=mean(Data(:,1));
            BloodValueStds(i,j,k)=std(Data(:,1));
            %             GMModel = fitgmdist(X,k)
            
            
        end
        
    end
    
end

%% Version 2 which uses Codi's labels and fits multiple Gaussians to the histogram

modality='UTE3D';
model='rSD12';

for i=1:1:12
    
    
    an_num=sprintf('%d', i);
    folder1='SD12_RAT_EXTRACTED_CORRECTED_CROPPED_ALIGNED_ABS';
    Subject=strcat(model, '_', an_num, '_', modality);
    
    if i==7
        totscan=7;
    elseif i==12
        totscan=6;
    else
        totscan=5;
    end
    
    scn_num=sprintf('%d', totscan);
    
    file=strcat(Subject, '_UTEscan', scn_num, '_MAGNITUDE_IMAGE_CORRECTED_CROPPED_METH2_SSS-label');
    loadname=strcat(folder1, '\', file, '.nii');
    ROINii=load_nii(loadname);
    ROI=double(ROINii.img);
    
    for j=1:1:totscan
        scn_num=sprintf('%d', j);
        
        for k=1:1:3
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
            
            loadname=strcat(folder1, '\', file, '.nii');
            CurrentNii=load_nii(loadname);
            Image=double(CurrentNii.img);
            Data=Image.*ROI;
            Data(isnan(Data))=0; %WTF NANS
            Data=nonzeros(Data);
            
            ROIave(i,j,k)=mean(Data(:,1));
            ROIStds(i,j,k)=std(Data(:,1));
            
            [counts,bins]=hist(Data,100);
            
            X(:,1)=bins(:);
            X(:,2)=medfilt1(counts(:),3);
            
            %
            %             k=2;
            %             GMModel = fitgmdist(X,k);
            %             Models.=GMModel;
            signal=X;
            NumPeaks=2;
            %             center=(max(bins)-min(bins))/2;
            center=0;
            window=0;
            NumPeaks=2;
            peakshape=0;
            extra=0;
            NumTrials=5;
            
            [FitResults,GOF,baseline,coeff,residual,xi,yi]=peakfit(signal,center,window,NumPeaks,peakshape,extra,NumTrials);
            
            
            peak=0;
            diff=10000;
            for m=1:1:600
                for n=2:1:2
                    if yi(n,m)>peak
                        peak=yi(n,m);
                        BloodFromPeak(i,j,k)=xi(m);
                    end
                end
            end
            
            for m=1:1:600
                for n=2:1:2
                    if abs(peak/2 - yi(n,m))<diff && peak~=0
                        diff=abs(peak/2 - yi(n,m));
                        BloodFromPeakStd(i,j,k)=(abs(xi(m)-BloodFromPeak(i,j,k))*2)/2.355;
                    end
                end
            end
            
            if k==3 && j==totscan
                fit_bins(i,:)=xi(:);
                fit_curve(i,:)=yi(1,:);
                fit_curve2(i,:)=yi(2,:);
                raw_bins(i,:)=X(:,1);
                raw_hist(i,:)=X(:,2);
            end
            
            %             BloodFromPeakStds(i,j,k)=std(yi(2,:));
        end
        
    end
    
end

fit_bins=fit_bins.';
fit_curve=fit_curve.';
fit_curve2=fit_curve2.';
raw_bins=raw_bins.';
raw_hist=raw_hist.';


%% Version 3 which uses Codi's labels and fits one Gaussian to the histogram

modality='UTE3D';
model='rSD12';

for i=1:1:12
    
    
    an_num=sprintf('%d', i);
    folder1='SD12_RAT_EXTRACTED_CORRECTED_CROPPED_ALIGNED_ABS';
    Subject=strcat(model, '_', an_num, '_', modality);
    
    if i==7
        totscan=7;
    elseif i==12
        totscan=6;
    else
        totscan=5;
    end
    
    scn_num=sprintf('%d', totscan);
    
    file=strcat(Subject, '_UTEscan', scn_num, '_MAGNITUDE_IMAGE_CORRECTED_CROPPED_METH2_auto2_SSS-label');
    loadname=strcat(folder1, '\', file, '.nii');
    ROINii=load_nii(loadname);
    ROI=double(ROINii.img);
    ROI(:,:,1:50)=0;ROI(:,:,101:200)=0;
    
    for j=1:1:totscan
        scn_num=sprintf('%d', j);
        
        for k=1:1:3
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
            
            loadname=strcat(folder1, '\', file, '.nii');
            CurrentNii=load_nii(loadname);
            Image=double(CurrentNii.img);
            Data=Image.*ROI;
            Data(isnan(Data))=0; %WTF NANS
            Data=nonzeros(Data);
            
            ROIave(i,j,k)=mean(Data(:,1));
            ROIStds(i,j,k)=std(Data(:,1));
            
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
            NumPeaks=2;
            %             center=(max(bins)-min(bins))/2;
            center=0;
            window=0;
            NumPeaks=1;
            peakshape=0;
            extra=0;
            NumTrials=5;
            
            [FitResults,GOF,baseline,coeff,residual,xi,yi]=peakfit(signal,center,window,NumPeaks,peakshape,extra,NumTrials);
            
            
            peak=0;
            diff=10000;
            for m=1:1:600
                %                 for n=2:1:2
                %                     if yi(n,m)>peak
                %                         peak=yi(n,m);
                %                 for n=2:1:2
                if yi(m)>peak
                    peak=yi(m);
                    BloodFromPeak(i,j,k)=xi(m);
                end
                %             end
            end
            
            for m=1:1:600
                %                 for n=1:1:1
                %                     if abs(peak/2 - yi(n,m))<diff && peak~=0
                %                         diff=abs(peak/2 - yi(n,m));
                if abs(peak/2 - yi(m))<diff && peak~=0
                    diff=abs(peak/2 - yi(m));
                    BloodFromPeakStd(i,j,k)=(abs(xi(m)-BloodFromPeak(i,j,k))*2)/2.355;
                end
                %             end
            end
            
            
            
            if k==3 && j==totscan
                fit_bins(i,:)=xi(:);
                fit_curve(i,:)=yi(:);
                raw_bins(i,:)=X(:,1);
                raw_hist(i,:)=X(:,2);
                percent(i)=(BloodFromPeak(i,j,k)-Aves(i,4))/Aves(i,4);
            end
            
            %             BloodFromPeakStds(i,j,k)=std(yi(2,:));
        end
        
    end
    
end

% fit_bins=fit_bins.';
% fit_curve=fit_curve.';
% raw_bins=raw_bins.';
% raw_hist=raw_hist.';

%% Version 4 which is basically version 3 adapted for all scans

modality='UTE3D';
model='rSD12';

mask=zeros(200,200,200);

mask(:,:,50:100)=1;


for i=1:1:12
    
    i
    
    an_num=sprintf('%d', i);
    folder1='SD12_RAT_EXTRACTED_CORRECTED_CROPPED_ALIGNED_ABS';
    Subject=strcat(model, '_', an_num, '_', modality);
    
    if i==7
        totscan=7;
    elseif i==12
        totscan=6;
    else
        totscan=5;
    end
    
    
    
    for j=1:1:totscan
        j
        
        if j==1
            ROI_scn_num=sprintf('%d', 2);
        else
            ROI_scn_num=sprintf('%d', j);
        end
        
        file=strcat(Subject, '_UTEscan', ROI_scn_num, '_MAGNITUDE_IMAGE_CORRECTED_CROPPED_METH2');
        if j==totscan
            file=strcat(file, '_auto2_SSS')
        end
        
        loadname=strcat(folder1, '\', file, '-label.nii');
        ROINii=load_nii(loadname);
        ROI=double(ROINii.img);
        ROI=ROI.*mask;
        
        scn_num=sprintf('%d', j);
        
        for k=1:1:3
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
            
            loadname=strcat(folder1, '\', file, '.nii');
            CurrentNii=load_nii(loadname);
            Image=double(CurrentNii.img);
            Data=Image.*ROI;
            Data(isnan(Data))=0; %WTF NANS
            Data=nonzeros(Data);
            
            
            
            ROIave(i,j,k)=mean(Data(:,1));
            ROIStds(i,j,k)=std(Data(:,1));
            
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
            NumPeaks=2;
            %             center=(max(bins)-min(bins))/2;
            center=0;
            window=0;
            NumPeaks=1;
            peakshape=0;
            extra=0;
            NumTrials=5;
            
%             figure
            [FitResults,GOF,baseline,coeff,residual,xi,yi]=peakfit(signal,center,window,NumPeaks,peakshape,extra,NumTrials);
            
            
            peak=0;
            diff=10000;
            for m=1:1:600
                if yi(m)>peak
                    peak=yi(m);
                    BloodFromPeak(i,j,k)=xi(m);
                end
            end
            
            for m=1:1:600
                if abs(peak/2 - yi(m))<diff && peak~=0
                    diff=abs(peak/2 - yi(m));
                    BloodFromPeakStd(i,j,k)=(abs(xi(m)-BloodFromPeak(i,j,k))*2)/2.355;
                end
            end
            
            
            
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
            
        end
        
    end
    
end

% fit_bins=fit_bins.';
% fit_curve=fit_curve.';
% raw_bins=raw_bins.';
% raw_hist=raw_hist.';