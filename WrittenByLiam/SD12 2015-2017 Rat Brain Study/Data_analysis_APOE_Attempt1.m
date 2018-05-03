% % % % % % % %   APOE Data Processing  % % % % % % % %
% % % % % % % %    Liam Timms 3/20/16   % % % % % % % %
% % % % % % % % % % % % % % % % % % % % % % % % % % % %

% First we want to get CBV (f_B) values for each voxel of the anethesized
% scans, pre- and post-constrast. Second, we will calulate I_T pervoxel on
% the precontrast scans and that will be used in calculating all the
% other CBV values in all the other scans. Both of these will be output as
% .nii files for later analysis.

% f_B_vox=(I_post_vox - I_pre_vox)/(I_B_peak_post - I_B_peak_pre)
% Meth2 files will be focused on for now

% THIS FILE WAS ADAPTED FROM CompleteRevisit_BloodChanges_v3

[ROIave, ROIStds] =get_BloodValues_StatCorrect_APOE();

modality='UTE3D';
model='APOE';
cutoff=.25;

for i=1:1:23
    
    if i~=13
        
        an_num=sprintf('%d', i);
        
        if i==1 || i==2 || i==11 || i==12 || i==16
            Ses_num=sprintf('%d', 2);
        else
            Ses_num=sprintf('%d', 1);
        end
        
        folder='APOE_RAT_EXTRACTED_CORRECTED_CROPPED';
        Subject=strcat(model, an_num, '_Scan',Ses_num, '_', modality);
        totscan=2;
        
        denom=ROIave(i,totscan)-ROIave(i,1);
        
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
        
        folder='APOE_RAT_CBV';
        file=strcat(Subject, '_CBV_from_UTEscan', scn_num, '_', type, '_IMAGE_CORRECTED_CROPPED_METH2');
        savename=strcat(folder, '\', file, '.nii');
        save_nii(CBVNii, savename);
        
        for x=1:1:200
            for y=1:1:200
                for z=1:1:200
                    denom=(1-CBVImg(x,y,z));
                    I_Timg(x,y,z)=(CBVImg(x,y,z)-CBVImg(x,y,z)*ROIave(i,totscan))/denom;
                end
            end
        end
        
        ITNii=CBVNii;
        ITNii.img=I_Timg;
        
        folder='APOE_RAT_IT';
        file=strcat(Subject, '_IT_from_UTEscan', scn_num, '_', type, '_IMAGE_CORRECTED_CROPPED_METH2');
        savename=strcat(folder, '\', file, '.nii');
        save_nii(ITNii, savename);
        
        
        CapMapImg=CBVImg;
        CapMapImg(CapMapImg<=cutoff)=0;
        CapMapImg(CapMapImg>cutoff)=1;
        
        CapMapNii=CBVNii;
        CapMapNii.img=CapMapImg;
        
        folder='APOE_Cap_MAP_from_CBV';
        file=strcat('map_', Subject, '_Caps_CBV_from_UTEscan', scn_num, '_', type, '_IMAGE_CORRECTED_CROPPED_METH2');
        savename=strcat(folder, '\', file, '.nii');
        save_nii(CapMapNii, savename);
        
        i
    end
end

%%

% Next, we want to use those CBV values to look for differences in one way.
% Here we will focus on completing a "horizontal" analysis where we combine
% all of the statisitics for each animal to look for over all differences
% between scans. All of this initial analysis will use only the 59 region
% atlas.

% First, registering the CBV averages and stds on the Atlas

TotRegions=59; %either 59, 106 or 174

capmaskcrop=1; %0 means do not use, 1 means do use it

reg_num=sprintf('%d', TotRegions);

modality='UTE3D';
model='APOE';
cutoff=.25;
totscan=2;

for i=1:1:23
    
    if i~=13
        
        an_num=sprintf('%d', i);
        
        if i==1 || i==2 || i==11 || i==12 || i==16
            Ses_num=sprintf('%d', 2);
        else
            Ses_num=sprintf('%d', 1);
        end
        
        
        folder1='APOE_RAT_CBV';
        folder2='APOE_Atlas_Map_Files';
        folder3='APOE_Cap_MAP_from_CBV';
        Subject=strcat(model, an_num, '_Scan',Ses_num, '_', modality);
        
        
        type='MAGNITUDE';
        scn_num=sprintf('%d', totscan);
        file=strcat('APOE', an_num, '_', reg_num, '_Atlas');
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
                
                CBV(i,n)=mean(Data);
                CBV_error(i,n)=std(Data);
                
            end
            
        end
    end
    
end

%%

r_num=sprintf('%d', TotRegions);
if capmaskcrop==1
    filename=strcat('Statistics_APOE_CBV_',r_num,'FromCBVniis_Blood3_capmaskcrop.csv');
else
    filename=strcat('Statistics_APOE_CBV_',r_num,'FromCBVniis_Blood3.csv');
end

if exist(filename, 'file')
    fprintf('Already saved. \n');
    M_STAT= csvread(filename);
else
    
    [M, M_STAT] =get_StatMatrix_v2(TotRegions+1, CBV);
    
    csvwrite(filename,M_STAT);
    fprintf('Saved new Excel \n%s', filename);
    
end



%% Next, we have an indication that there may be something biomodal happening within the regions themselves

% To investigate that we ware going to look at histograms of the regions
% themselves

TotRegions=59; %either 59, 106 or 174

capmaskcrop=0; %0 means do not use, 1 means do use it

reg_num=sprintf('%d', TotRegions);

modality='UTE3D';
model='APOE';
totscan=2;

n1=1;
n2=1;
n3=1;
n4=1;

for i=1:1:23
    
    if i~=13
        
        an_num=sprintf('%d', i);
        
        if i==1 || i==2 || i==11 || i==12 || i==16
            Ses_num=sprintf('%d', 2);
        else
            Ses_num=sprintf('%d', 1);
        end
        
        
        folder1='APOE_RAT_CBV';
        folder2='APOE_Atlas_Map_Files';
        Subject=strcat(model, an_num, '_', modality);
        
        
        type='MAGNITUDE';
        scn_num=sprintf('%d', totscan);
        file=strcat('APOE', an_num, '_', reg_num, '_Atlas');
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
                
                if i<6
                    DataForWTM{n1,n}=Data;
                elseif i>6 && i<12
                    DataForWTF{n2,n}=Data;
                elseif i>11 && i<18
                    DataForAPOEM{n3,n}=Data;
                elseif i>17
                    DataForAPOEF{n4,n}=Data;
                end
            end
            
            if i<6
                n1=n1+1;
            elseif i>6 && i<12
                n2=n2+1;
            elseif i>11 && i<18
                n3=n3+1;
            elseif i>17
                n4=n4+1;
            end
            
        end
    end
    
end

%% Female histograms

for n=1:1:TotRegions+1
    DataForAPOEF_hist=0;
    DataForWTF_hist=0;
    for i=1:1:4
        newData=DataForAPOEF{i,n};
        newData=newData';
        DataForAPOEF_hist=[newData DataForAPOEF_hist];
        
        newData=DataForWTF{i,n};
        newData=newData';
        DataForWTF_hist=[newData DataForWTF_hist];
        i
    end
    
    figure
    hold on
    histogram(DataForAPOEF_hist)
    histogram(DataForWTF_hist)
    hold off
    %     clear DataForAPOEM_hist
    
end

%% Male Histograms

for n=1:1:TotRegions+1
    DataForAPOEM_hist=0;
    DataForWTM_hist=0;
    for i=1:1:4
        newData=DataForAPOEM{i,n};
        newData=newData';
        DataForAPOEM_hist=[newData DataForAPOEM_hist];
        
        newData=DataForWTM{i,n};
        newData=newData';
        DataForWTM_hist=[newData DataForWTM_hist];
        i
    end
    
    figure
    hold on
    histogram(DataForAPOEM_hist)
    histogram(DataForWTM_hist)
    hold off
    %     clear DataForAPOEM_hist
    
end

%% 

for n=1:1:TotRegions+1
    DataForWTF_hist=0;
    DataForWTM_hist=0;
    for i=1:1:4
        newData=DataForWTF{i,n};
        newData=newData';
        DataForWTF_hist=[newData DataForWTF_hist];
        
        newData=DataForWTM{i,n};
        newData=newData';
        DataForWTM_hist=[newData DataForWTM_hist];
        i
    end
    
    figure
    hold on
    histogram(DataForWTF_hist)
    histogram(DataForWTM_hist)
    hold off
    %     clear DataForAPOEM_hist
    
end

%%

for n=1:1:TotRegions+1
    DataForAPOF_hist=0;
    DataForWTF_hist=0;
    for i=1:1:4
        newData=DataForAPOEF{i,n};
        S1=size(newData);
        
        newData=DataForWTF{i,n};
        S2=size(newData);
        diff(i,n)=S1(1,1)-S2(1,1);

    end

end