% % % % % % % %   SD12 Data Processing  % % % % % % % %
% % % % % % % %    Liam Timms 3/8/16    % % % % % % % %
% % % % % % % % % % % % % % % % % % % % % % % % % % % %

% First we want to get CBV (f_B) values for each voxel of the anethesized
% scans, pre- and post-constrast. Second, we will calulate I_T pervoxel on
% the precontrast scans and that will be used in calculating all the
% other CBV values in all the other scans. Both of these will be output as
% .nii files for later analysis.

% f_B_vox=(I_post_vox - I_pre_vox)/(I_B_peak_post - I_B_peak_pre)
% Meth2 files will be focused on for now

[BloodFromPeak, BloodFromPeakStd, ROIave, ROIStds, BloodTQAve, BloodTQStd] =get_BloodValues(k)

modality='UTE3D';
model='rSD12';

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
    
    denom=BloodFromPeak(i,totscan)-BloodFromPeak(i,1);
    
    type='MAGNITUDE';
    
    scn_num=sprintf('%d', 1);
    file=strcat(Subject, '_UTEscan', scn_num, '_', type, '_IMAGE_CORRECTED_CROPPED_METH2');
    loadname=strcat(folder, '\', file, '.nii');
    PreConNii=special_load_nii(loadname);
    PreConImg=double(PreConNii.img);
    
    scn_num=sprintf('%d', totscan);
    file=strcat(Subject, '_UTEscan', scn_num, '_', type, '_IMAGE_CORRECTED_CROPPED_METH2');
    loadname=strcat(folder, '\', file, '.nii');
    PostConNii=special_load_nii(loadname);
    PostConImg=double(PostConNii.img);
    
    CBVImg=(PostConImg-PreConImg)./denom;
    
    CBVNii=PostConNii;
    CBVNii.img=CBVImg;
    
    folder='SD12_RAT_CBV';
    file=strcat(Subject, '_CBV_from_UTEscan', scn_num, '_', type, '_IMAGE_CORRECTED_CROPPED_METH2');
    savename=strcat(folder, '\', file, '.nii');
    save_nii(CBVNii, savename);
    
    for x=1:1:200
        for y=1:1:200
            for z=1:1:200
                denom=(1-CBVImg(x,y,z));
                I_Timg(x,y,z)=(CBVImg(x,y,z)-CBVImg(x,y,z)*BloodFromPeak(i,totscan))/denom;
            end
        end
    end
    
    ITNii=CBVNii;
    ITNii.img=I_Timg;
    
    folder='SD12_RAT_IT';
    file=strcat(Subject, '_IT_from_UTEscan', scn_num, '_', type, '_IMAGE_CORRECTED_CROPPED_METH2');
    savename=strcat(folder, '\', file, '.nii');
    save_nii(ITNii, savename);
    
end

%% Generate Cap Map for last scan

modality='UTE3D';
model='rSD12';

cutoff=.25;

for i=1:1:12
    
    an_num=sprintf('%d', i);
    folder='SD12_RAT_CBV';
    Subject=strcat(model, '_', an_num, '_', modality);
    
    if i==7
        totscan=7;
    elseif i==12
        totscan=6;
    else
        totscan=5;
    end
    
    scn_num=sprintf('%d', totscan);
    type='MAGNITUDE';
    
    file=strcat(Subject, '_CBV_from_UTEscan', scn_num, '_', type, '_IMAGE_CORRECTED_CROPPED_METH2');
    loadname=strcat(folder, '\', file, '.nii');
    CBVNii=special_load_nii(loadname);
    CBVImg=double(CBVNii.img);
    
    CapMapImg=CBVImg;
    CapMapImg(CapMapImg<=cutoff)=0;
    CapMapImg(CapMapImg>cutoff)=1;
    
    CapMapNii=CBVNii;
    CapMapNii.img=CapMapImg;
    
    folder='Cap_MAP_from_CBV';
    file=strcat('map_', Subject, '_Caps_CBV_from_UTEscan', scn_num, '_', type, '_IMAGE_CORRECTED_CROPPED_METH2');
    savename=strcat(folder, '\', file, '.nii');
    save_nii(CapMapNii, savename);
    
end

%% Use the I_T value from the anesthetized to generate CBV for the rest

[BloodFromPeak, BloodFromPeakStd, ~, ~] =get_BloodValues(3);

modality='UTE3D';
model='rSD12';

cutoff=.25;

for i=1:1:12
    if i==7
        totscan=7;
    elseif i==12
        totscan=6;
    else
        totscan=5;
    end
    
    an_num=sprintf('%d', i);
    Subject=strcat(model, '_', an_num, '_', modality);
    
    for j=2:1:totscan-1
        
        denom=BloodFromPeak(i,j)-BloodFromPeak(i,1);
        
        type='MAGNITUDE';
        folder='SD12_RAT_EXTRACTED_CORRECTED_CROPPED_ALIGNED_ABS';
        
        scn_num=sprintf('%d', 1);
        file=strcat(Subject, '_UTEscan', scn_num, '_', type, '_IMAGE_CORRECTED_CROPPED_METH2');
        loadname=strcat(folder, '\', file, '.nii');
        PreConNii=special_load_nii(loadname);
        PreConImg=double(PreConNii.img);
        
        scn_num=sprintf('%d', j);
        file=strcat(Subject, '_UTEscan', scn_num, '_', type, '_IMAGE_CORRECTED_CROPPED_METH2');
        loadname=strcat(folder, '\', file, '.nii');
        PostConNii=special_load_nii(loadname);
        PostConImg=double(PostConNii.img);
        
        folder='SD12_RAT_CBV';
        tot_num=sprintf('%d', totscan);
        file=strcat(Subject, '_CBV_from_UTEscan', tot_num, '_', type, '_IMAGE_CORRECTED_CROPPED_METH2');
        loadname=strcat(folder, '\', file, '.nii');
        CBVAneNii=special_load_nii(loadname);
        CBVAneImg=double(CBVAneNii.img);
        
        folder='SD12_RAT_IT';
        file=strcat(Subject, '_IT_from_UTEscan', tot_num, '_', type, '_IMAGE_CORRECTED_CROPPED_METH2');
        loadname=strcat(folder, '\', file, '.nii');
        ITNii=special_load_nii(loadname);
        I_Timg=double(ITNii.img);
        
        for x=1:1:200
            for y=1:1:200
                for z=1:1:200
                    denom=BloodFromPeak(i,totscan)-I_Timg(x,y,z);
                    deltaI=PostConImg(x,y,z)-PreConImg(x,y,z);
                    blahblah=CBVAneImg(x,y,z)*(BloodFromPeak(i,1) - I_Timg(x,y,z));
                    CBVImg(x,y,z)=(deltaI+blahblah)/denom;
                end
            end
        end
        
        
        CBVNii=PostConNii;
        CBVNii.img=CBVImg;
        
        folder='SD12_RAT_CBV';
        file=strcat(Subject, '_CBV_from_UTEscan', scn_num, '_', type, '_IMAGE_CORRECTED_CROPPED_METH2');
        savename=strcat(folder, '\', file, '.nii');
        save_nii(CBVNii, savename);
        
        CapMapImg=CBVImg;
        CapMapImg(CapMapImg<=cutoff)=0;
        CapMapImg(CapMapImg>cutoff)=1;
        
        CapMapNii=CBVNii;
        CapMapNii.img=CapMapImg;
        
        folder='Cap_MAP_from_CBV';
        file=strcat('map_', Subject, '_Caps_CBV_from_UTEscan', scn_num, '_', type, '_IMAGE_CORRECTED_CROPPED_METH2');
        savename=strcat(folder, '\', file, '.nii');
        save_nii(CapMapNii, savename);
        
        
    end
end

%% Next, we want to use those CBV values to look for differences in one way.
% Here we will focus on completing a "horizontal" analysis where we combine
% all of the statisitics for each animal to look for over all differences
% between scans. All of this initial analysis will use only the 59 region
% atlas.

% First, registering the CBV averages and stds on the Atlas

modality='UTE3D';
model='rSD12';
TotRegions=174; %either 59, 106 or 174

capmaskcrop=1; %0 means do not use, 1 means do use it

reg_num=sprintf('%d', TotRegions);

for i=1:1:12
    an_num=sprintf('%d', i);
    folder1='SD12_RAT_CBV';
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
    
    j=totscan;
    
    scn_num=sprintf('%d', j);
    
    type='MAGNITUDE';
    
    file=strcat(Subject, '_CBV_from_UTEscan', scn_num, '_', type, '_IMAGE_CORRECTED_CROPPED_METH2');
    
    loadname=strcat(folder1, '\', file, '.nii');
    CBVNii=load_nii(loadname);
    CBVImg=double(CBVNii.img);
    
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
    
    for n=1:1:TotRegions
        
        % select region
        ROI=ATLASimg;
        ROI(ROI~=n)=0;
        ROI(ROI~=0)=1;
        
        ROI=ROI.*CapMapImg;
        
        Data=CBVImg.*ROI;
        
        Data(isnan(Data))=0; %WTF NANS
        Data=nonzeros(Data);
        
        CBVMedian(i,n)=median(Data);
        CBVAve(i,n)=mean(Data);
        CBV_error(i,n)=std(Data);
        
    end  
    
end

%%

r_num=sprintf('%d', TotRegions);
if capmaskcrop==1
    filename=strcat('Statistics_SD12_CBV_',r_num,'_redoFromCBVniis_capmaskcrop.csv');
else
    filename=strcat('Statistics_SD12_CBV_',r_num,'_redoFromCBVniis.csv');
end

if exist(filename, 'file')
    fprintf('Already saved. \n');
    M_STAT= csvread(filename);
else
    
    [M, M_STAT] =get_StatMatrix_v2(TotRegions, CBV);
    
    csvwrite(filename,M_STAT);
    fprintf('Saved new Excel \n%s', filename);
    
end




%% Next, we use those CBV values to look for differences the other way
% Here we will focus on completing a "vertical" analysis where we look
% first at the differences between each individual animal and then look for
% that to be significant


