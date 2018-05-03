% % % % % % % %   SD12 Data Processing  % % % % % % % %
% % % % % % % %    Liam Timms 3/25/16   % % % % % % % %
% % % % % % % % % % % % % % % % % % % % % % % % % % % %


%%

% To investigate differences we ware going to look at histograms of the regions
% themselves

TotRegions=59; %either 59, 106 or 174

capmaskcrop=0; %0 means do not use, 1 means do use it

reg_num=sprintf('%d', TotRegions);

modality='UTE3D';
model='rSD12';

n1=1;
n2=1;
n3=1;
n4=1;

for i=1:1:12
    
    if i==7
        totscan=7;
    elseif i==12
        totscan=6;
    else
        totscan=5;
    end
    
    type='Magnitude';
    
    an_num=sprintf('%d', i);
    folder1='SD12_RAT_CBV_REDO';
    folder2='Atlas_Map_Files';
    folder3='Cap_MAP_from_CBV_REDO';
    Subject=strcat(model, '_', an_num, '_', modality);
    
    
    scn_num=sprintf('%d', totscan);
    file=strcat('map_', Subject, '_UTEscan', scn_num, '_MAGNITUDE_IMAGE_', reg_num ,'_REGION');
    loadname=strcat(folder2, '\', file, '.nii');
    ATLASNii=load_nii(loadname);
    ATLASimg=double(ATLASNii.img);
    
    
    if capmaskcrop==1
        file=strcat('map_' ,Subject, '_Caps_CBV_from_UTEscan', scn_num, '_', type, '_IMAGE_CORRECTED_CROPPED_METH2');
        loadname=strcat(folder3, '\', file, '.nii');
        CapMapNii=load_nii(loadname);
        CapMapImg=double(CapMapNii.img);
    else
        CapMapImg=zeros(200,200,200);
    end
    %invert CapMap
    CapMapImg(CapMapImg~=0)=1;
    CapMapImg=CapMapImg-1;
    CapMapImg(CapMapImg<0)=1;
    
    for j=2:1:totscan
        scn_num=sprintf('%d', j);
        file=strcat(Subject, '_CBV_from_UTEscan', scn_num, '_', type, '_IMAGE_CORRECTED_CROPPED_METH2');
        loadname=strcat(folder1, '\', file, '.nii');
        CBVNii=load_nii(loadname);
        CBVImg=double(CBVNii.img);
        
        for n=1:1:TotRegions+1
            
            % select region
            ROI=ATLASimg;
            
            if n<(TotRegions+1)
                ROI(ROI~=n)=0;
            end
            
            ROI(ROI~=0)=1;
            
            ROI=ROI.*CapMapImg;
            
            Data=CBVImg.*ROI;
            Data(isnan(Data))=0; %WTF NANS
            Data=nonzeros(Data);
            s=size(Data);
            
            if j==(totscan-3)
                DataForSober1{n1,n}=Data;
            elseif j==(totscan-2)
                DataForCO2{n2,n}=Data;
            elseif j==(totscan-1)
                DataForSober2{n3,n}=Data;
            elseif j==totscan
                DataForAnet{n4,n}=Data;
            end
        end
        
        if j==(totscan-3)
            n1=n1+1;
        elseif j==(totscan-2)
            n2=n2+1;
        elseif j==(totscan-1)
            n3=n3+1;
        elseif j==totscan
            n4=n4+1;
        end
    end
    
end

%% Awake1 vs Ane

for n=1:1:TotRegions+1
    DataForSober1_hist=0;
    DataForAne_hist=0;
    for i=1:1:12
        newData=DataForSober1{i,n};
        newData=newData';
        DataForSober1_hist=[newData DataForSober1_hist];
        
        newData=DataForAnet{i,n};
        newData=newData';
        DataForAne_hist=[newData DataForAne_hist];
        i
    end
    
    figure
    hold on
    histogram(DataForSober1_hist)
    histogram(DataForAne_hist)
    hold off
    %     clear DataForAPOEM_hist
    
end

%% Region Comparisons

Region1=133;
Region2=125;
Region3=52;


DataForReg1_hist=[];
DataForReg2_hist=[];
DataForReg3_hist=[];

for i=1:1:12
    newData=DataForAnet{i,Region1};
    newData=newData';
    DataForReg1_hist=[newData DataForReg1_hist];
    
    newData=DataForAnet{i,Region2};
    newData=newData';
    DataForReg2_hist=[newData DataForReg2_hist];
    
    newData=DataForAnet{i,Region3};
    newData=newData';
    DataForReg3_hist=[newData DataForReg3_hist];
end

figure
hold on

[h1, x1]=hist(DataForReg1_hist,500);
[h2, x2]=hist(DataForReg2_hist,500);
[h3, x3]=hist(DataForReg3_hist,500);
h1norm=h1/trapz(x1,h1);
h2norm=h2/trapz(x2,h2);
h3norm=h3/trapz(x3,h3);

plot(x1,h1norm)
plot(x2,h2norm)
plot(x3,h3norm)

hold off

% end

%% Histograms for all (no figures)

filtersize=3;
binsize=10;

for n=1:1:TotRegions+1
    
    DataForSober1_hist=0;
    DataForCO2_hist=0;
    DataForSober2_hist=0;
    DataForAne_hist=0;
    
    for i=1:1:12
        newData=DataForSober1{i,n};
        newData=newData';
        DataForSober1_hist=[newData DataForSober1_hist];
        
        newData=DataForCO2{i,n};
        newData=newData';
        DataForCO2_hist=[newData DataForCO2_hist];
        
        newData=DataForSober2{i,n};
        newData=newData';
        DataForSober2_hist=[newData DataForSober2_hist];
        
        newData=DataForAnet{i,n};
        newData=newData';
        DataForAne_hist=[newData DataForAne_hist];
        
    end
    
    [counts,bins,smoothedcounts,meanOfData,stdOfData,medianOfData,modeOfData] =get_SD12_HistData(DataForSober1_hist,filtersize,binsize)
    Sober1_counts(n,:)=counts(:);
    Sober1_bins(n,:)=bins(:);
    Sober1_mean(n)=meanOfData;
    Sober1_std(n)=stdOfData;
    Sober1_median(n)=medianOfData;
    Sober1_mode(n)=modeOfData;
    
    
    
    [counts,bins,smoothedcounts,meanOfData,stdOfData,medianOfData,modeOfData] =get_SD12_HistData(DataForCO2_hist,filtersize,binsize)
    CO2_counts(n,:)=counts(:);
    CO2_bins(n,:)=bins(:);
    CO2_mean(n)=meanOfData;
    CO2_std(n)=stdOfData;
    CO2_median(n)=medianOfData;
    CO2_mode(n)=modeOfData;
    
    [counts,bins,smoothedcounts,meanOfData,stdOfData,medianOfData,modeOfData] =get_SD12_HistData(DataForSober2_hist,filtersize,binsize)
    Sober2_counts(n,:)=counts(:);
    Sober2_bins(n,:)=bins(:);
    Sober2_mean(n)=meanOfData;
    Sober2_std(n)=stdOfData;
    Sober2_median(n)=medianOfData;
    Sober2_mode(n)=modeOfData;
    
    
    [counts,bins,smoothedcounts,meanOfData,stdOfData,medianOfData,modeOfData] =get_SD12_HistData(DataForAne_hist,filtersize,binsize)
    Ane_counts(n,:)=counts(:);
    Ane_bins(n,:)=bins(:);
    Ane_mean(n)=meanOfData;
    Ane_std(n)=stdOfData;
    Ane_median(n)=medianOfData;
    Ane_mode(n)=modeOfData;
    
    
    % clear DataForAPOEM_hist
    
end

%% Checking out the precontrast scans to help with APOE neg study

TotRegions=174; %either 59, 106 or 174
resolution=0.001;

capmaskcrop=0; %0 means do not use, 1 means do use it

reg_num=sprintf('%d', TotRegions);

modality='UTE3D';
model='rSD12';

n1=1;
n2=1;
n3=1;
n4=1;

for i=1:1:12
    
    if i==7
        totscan=7;
    elseif i==12
        totscan=6;
    else
        totscan=5;
    end
    
    type='Magnitude';
    
    an_num=sprintf('%d', i);
    folder1='SD12_RAT_CBV_REDO';
    folder2='Atlas_Map_Files';
    folder3='Cap_MAP_from_CBV_REDO';
    Subject=strcat(model, '_', an_num, '_', modality);
    
    
    scn_num=sprintf('%d', totscan);
    file=strcat('map_', Subject, '_MAGNITUDE_IMAGE_', reg_num ,'_REGION');
    loadname=strcat(folder2, '\', file, '.nii');
    ATLASNii=load_nii(loadname);
    ATLASimg=double(ATLASNii.img);
    
    
    if capmaskcrop==1
        file=strcat('map_' ,Subject, '_Caps_CBV_from_UTEscan', scn_num, '_', type, '_IMAGE_CORRECTED_CROPPED_METH2');
        loadname=strcat(folder3, '\', file, '.nii');
        CapMapNii=load_nii(loadname);
        CapMapImg=double(CapMapNii.img);
    else
        CapMapImg=zeros(200,200,200);
    end
    %invert CapMap
    CapMapImg(CapMapImg~=0)=1;
    CapMapImg=CapMapImg-1;
    CapMapImg(CapMapImg<0)=1;
    
    for j=1:1:3
        scn_num=sprintf('%d', j);
        file=strcat(Subject, '_CBV_from_', scn_num, '_', type, '_IMAGE_CORRECTED_CROPPED_METH2');
        loadname=strcat(folder1, '\', file, '.nii');
        CBVNii=load_nii(loadname);
        CBVImg=double(CBVNii.img);
        
        for n=1:1:TotRegions+1
            
            % select region
            ROI=ATLASimg;
            
            if n<(TotRegions+1)
                ROI(ROI~=n)=0;
            end
            
            ROI(ROI~=0)=1;
            
            ROI=ROI.*CapMapImg;
            
            Data=CBVImg.*ROI;
            Data(isnan(Data))=0; %WTF NANS
            Data=nonzeros(Data);
            s=size(Data);
            
            if s(1,1)~=0
                
                       maxVal=max(Data);
                    minVal=min(Data);
                     nbins=(maxVal-minVal)/resolution;
            [histCounts,histBins]=hist(Data,nbins);
                
                [counts, bins]=hist(Data);
                mydataHist(i,j,n)={[counts;bins]'};
                X(:,1)=bins;
                X(:,2)=counts;
                
                [M,I]=max(X(:,2));
                signal=X;
                center=X(I,1);
                window=.1;
                NumPeaks=1;
                peakshape=0;
                extra=0;
                NumTrials=3;
                
                [~,GOF,~,~,~,xi,yi]=peakfit(signal,center,window,NumPeaks,peakshape,extra,NumTrials);
                
                [M,I]=max(yi);
                ModeVals(i,j,n)=xi(I);
                
            else
                ModeVals(i,j,n)=NaN;
            end
            
            clearvars yi xi X signal s Data
        end
    end
    
end

%% Pre Vs Post Whole Brain Hists on Raw Intensity (added much later on 5/19/17)

TotRegions=59; %either 59, 106 or 174
filtersize=3;
binsize=10;

reg_num=sprintf('%d', TotRegions);

modality='UTE3D';
model='rSD12';

for i=1:1:12
    
    an_num=sprintf('%d', i);
    folder1='SD12_RAT_EXTRACTED_CORRECTED_CROPPED_ALIGNED_ABS';
    Subject=strcat(model, '_', an_num, '_', modality);
    folder2='Atlas_Map_Files';
    
    if i==7
        totscan=7;
    elseif i==12
        totscan=6;
    else
        totscan=5;
    end
    
    type='MAGNITUDE';
    
    file=strcat('map_', Subject, '_MAGNITUDE_IMAGE_', reg_num ,'_REGION');
    loadname=strcat(folder2, '\', file, '.nii');
    ATLASNii=load_nii(loadname);
    ATLASimg=double(ATLASNii.img);
    
    scn_num=sprintf('%d', 1);
    file=strcat(Subject, '_UTEscan', scn_num, '_', type, '_IMAGE_CORRECTED_CROPPED_METH2');
    loadname=strcat(folder1, '\', file, '.nii');
    PreConNii=special_load_nii(loadname);
    PreConImg=double(PreConNii.img);
    
    scn_num=sprintf('%d', totscan);
    file=strcat(Subject, '_UTEscan', scn_num, '_', type, '_IMAGE_CORRECTED_CROPPED_METH2');
    loadname=strcat(folder1, '\', file, '.nii');
    PostConNii=special_load_nii(loadname);
    PostConImg=double(PostConNii.img);
    
    ROI=ATLASimg;
    ROI(ROI~=0)=1;
    
    
    PreConBrainImg=PreConImg.*ROI;
    PreConBrainNii=PreConNii;
    PreConBrainNii.img=PreConBrainImg;
    %view_nii(PreConBrainNii);
    
    DataPre=PreConBrainImg;
    DataPre(isnan(DataPre))=0; %WTF NANS
    DataPre=nonzeros(DataPre);
    sPre=size(DataPre);
    
    PostConBrainImg=PostConImg.*ROI;
    PostConBrainNii=PostConNii;
    PostConBrainNii.img=PostConBrainImg;
    %view_nii(PostConBrainNii);
    
    DataPost=PostConBrainImg;
    DataPost(isnan(DataPost))=0; %WTF NANS
    DataPost=nonzeros(DataPost);
    sPost=size(DataPost);
    
    [countsPre,binsPre,~,~,~,~,~] =get_SD12_HistData(DataPre,filtersize,binsize);
    [countsPost,binsPost,~,~,~,~,~] =get_SD12_HistData(DataPost,filtersize,binsize);
    
    HistDataPre{i,1}=binsPre';
    HistDataPre{i,2}=countsPre';
    HistDataPost{i,1}=binsPost';
    HistDataPost{i,2}=countsPost';
    
    %     figure
    %     hold on
    %     plot(binsPre, countsPre)
    %     plot(binsPost, countsPost)
    %     hold off
    
    
end


