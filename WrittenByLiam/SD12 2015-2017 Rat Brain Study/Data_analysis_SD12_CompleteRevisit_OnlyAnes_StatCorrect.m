% % % % % % % %   SD12 Data Processing  % % % % % % % %
% % % % % % % %    Liam Timms 3/15/16   % % % % % % % %
% % % % % % % % % % % % % % % % % % % % % % % % % % % %

% First we want to get CBV (f_B) values for each voxel of the anethesized
% scans, pre- and post-constrast. Second, we will calulate I_T pervoxel on
% the precontrast scans and that will be used in calculating all the
% other CBV values in all the other scans. Both of these will be output as
% .nii files for later analysis.

% f_B_vox=(I_post_vox - I_pre_vox)/(I_B_peak_post - I_B_peak_pre)
% Meth2 files will be focused on for now


[ROIave, ROIStds] =get_BloodValues_StatCorrect();

modality='UTE3D';
model='rSD12';
TotRegions=106; %either 59, 106 or 174
reg_num=sprintf('%d', TotRegions);

capmaskcrop=1; %0 means do not use, 1 means do use it

Stds=get_RealAndImaginaryStds();

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
    
    denom=ROIave(i,totscan)-ROIave(i,1);
    
    type='MAGNITUDE';
    
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
    
    file=strcat('map_', Subject, '_UTEscan', scn_num, '_MAGNITUDE_IMAGE_', reg_num ,'_REGION');
    loadname=strcat(folder2, '\', file, '.nii');
    ATLASNii=load_nii(loadname);
    ATLASimg=double(ATLASNii.img);
    
    [CorrectedPreConPerRegion, IntensityPreConStd, NpreCon] = Statistical_Correction_v2(PreConImg, ATLASimg, Stds, CapMapImg, i, 2, TotRegions);
    [CorrectedPostConPerRegion, IntensityPostConStd, NpostCon] = Statistical_Correction_v2(PostConImg, ATLASimg, Stds, CapMapImg, i, 2, TotRegions);
    
    i
    for n=1:1:TotRegions
        num=CorrectedPostConPerRegion(n)-CorrectedPreConPerRegion(n);
        CBV(i,n)=num/denom;
        CBV_error(i,n)=CBV(i,n)*((IntensityPreConStd(n)^2 + IntensityPostConStd(n)^2)/num^2 + (ROIStds(i,totscan)^2 +  ROIStds(i,1)^2)/denom^2)^2;
    end
    
    Nvoxels(i,:)=NpreCon(:);
    
end


%%

a=1;
b=2;
c=3;

for i=1:1:12
    
    for n=1:1:TotRegions
        SummaryMatrix(n,a)=CBV(i,n);
        SummaryMatrix(n,b)=CBV_error(i,n);
        SummaryMatrix(n,c)=Nvoxels(i,n);
    end
    
    a=a+3;
    b=b+3;
    c=c+3;
    
end




