% % % % % % % %   SD12 Data Processing  % % % % % % % %
% % % % % % % %    Liam Timms 3/18/16   % % % % % % % %
% % % % % % % % % % % % % % % % % % % % % % % % % % % %


modality='UTE3D';
model='rSD12';
TotRegions=59; %either 59, 106 or 174
reg_num=sprintf('%d', TotRegions);

capmaskcrop=1; %0 means do not use, 1 means do use it

Stds=get_RealAndImaginaryStds_v2();

[BloodROIave, BloodROIStds] =get_BloodValues_StatCorrect();
HomoMap=ones(200,200,200);
HomoMap=Inhomogeneity_Correction_complex(HomoMap, 3);


for i=1:1:12
    an_num=sprintf('%d', i);
    folder1='SD12_RAT_EXTRACTED_CORRECTED_CROPPED_ALIGNED_ABS';
    folder2='Atlas_Map_Files';
    folder3='Cap_MAP_from_CBV';
    Subject=strcat(model, '_', an_num, '_', modality);
    
    if i==7
        totscan=7;
    elseif i==12
        totscan=6;
    else
        totscan=5;
    end
    
    scn_num=sprintf('%d', totscan);
    file=strcat('map_', Subject, '_UTEscan', scn_num, '_MAGNITUDE_IMAGE_', reg_num ,'_REGION');
    loadname=strcat(folder2, '\', file, '.nii');
    ATLASNii=load_nii(loadname);
    ATLASimg=double(ATLASNii.img);
    
    
    if capmaskcrop==1 
        CapMapImg =get_SummedCapMap(i, Subject, type, folder3);
    else 
        CapMapImg=zeros(200,200,200);
    end
    
    %invert CapMap
    CapMapImg(CapMapImg~=0)=1;
    CapMapImg=CapMapImg-1;
    CapMapImg(CapMapImg<0)=1;
    
    
    
    for j=2:1:totscan
        
        stdforcorrection=(Stds(i,j,1)+Stds(i,j,2))/2;
        StdCorrMap=HomoMap*stdforcorrection;
        
        scn_num=sprintf('%d', j);
        
        type='MAGNITUDE';
        
        file=strcat(Subject, '_UTEscan', scn_num, '_', type, '_IMAGE_CORRECTED_CROPPED_METH2');
        
        loadname=strcat(folder1, '\', file, '.nii');
        MagNii=load_nii(loadname);
        MagImg=double(MagNii.img);
        
        
        for n=1:1:TotRegions+1
            
            % select region
            ROI=ATLASimg;
            
            if n<(TotRegions+1)
                ROI(ROI~=n)=0;
            end
            
            ROI(ROI~=0)=1;
            ROI=ROI.*CapMapImg;
            Data=MagImg.*ROI;
            
            Data(isnan(Data))=0; %WTF NANS
            Data=nonzeros(Data);
            s=size(Data);
            Nvox(i,j,n)=s(1,1);
            
            DataCorrection=StdCorrMap.*ROI;
            DataCorrection=nonzeros(DataCorrection);
            stdforcorrection=mean(DataCorrection);
            IntensityCorrectedAve(i,j,n)=((mean(Data))^2-stdforcorrection^2)^(.5);
            IntensityStd(i,j,n)=std(Data);
            IntensityMedian(i,j,n)=median(Data);
            
            
        end
        
    end
    
end

% [M, M_STAT] =get_StatMatrix_v2(TotRegions, InsenstiyAverage);