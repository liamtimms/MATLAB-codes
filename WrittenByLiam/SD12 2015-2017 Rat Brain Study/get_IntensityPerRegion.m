%% Adapted from Data_analysis_SD12_v5.m

function [I_avg_pre, I_std_pre, I_avg_post, I_std_post, I_peak_pre, I_peak_std_pre, I_peak_post, I_peak_std_post] =get_IntensityPerRegion(TotRegions, k, peakget)

if peakget~=0 && peakget~=1
    fprintf('Do you want me to get the peak or nah? \n')
end

modality='UTE3D';
model='rSD12';
%TotRegions=59; %either 59, 106 or 174

reg_num=sprintf('%d', TotRegions);
precon_num=sprintf('%d', 1);

for i=1:1:12
    an_num=sprintf('%d', i);
    folder1='SD12_RAT_EXTRACTED_CORRECTED_CROPPED_ALIGNED_ABS';
    folder2='Atlas_Map_Files';
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
    
    for j=2:1:totscan
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
        
        file=strcat(Subject, '_UTEscan', precon_num, '_', type, '_IMAGE_CORRECTED_CROPPED');
        if l==0
            file=strcat(file, '_ABS');
        elseif l==1
            file=strcat(file, '_METH2');
        end
        loadname=strcat(folder1, '\', file, '.nii');
        PreConNii=load_nii(loadname);
        PreConImage=double(PreConNii.img);
        
        file=strcat(Subject, '_UTEscan', scn_num, '_', type, '_IMAGE_CORRECTED_CROPPED');
        if l==0
            file=strcat(file, '_ABS');
        elseif l==1
            file=strcat(file, '_METH2');
        end
        loadname=strcat(folder1, '\', file, '.nii');
        PostConNii=load_nii(loadname);
        PostConImage=double(PostConNii.img);
        
        
        for n=1:1:TotRegions
            ROI=ATLASimg;
            ROI(ROI~=n)=0;
            ROI(ROI~=0)=1;
            
            %[I_peak_pre(i,j,k,n), I_avg_pre(i,j,k,n), I_std_pre(i,j,k,n)] =get_Ipeak_Iavg_v2(PreConImage, ROI);
            %[I_peak_post(i,j,k,n), I_avg_post(i,j,k,n), I_std_post(i,j,k,n)] =get_Ipeak_Iavg_v2(PostConImage, ROI);
            
            if peakget==1
                [I_peak, I_peak_std, I_avg, I_std] =get_Ipeak_Iavg_v2(PreConImage, ROI);
                I_peak_pre(i,j,n)=I_peak;
                I_peak_std_pre(i,j,n)=I_peak_std;
                I_avg_pre(i,j,n)=I_avg;
                I_std_pre(i,j,n)=I_std;
                
                [I_peak, I_peak_std, I_avg, I_std] =get_Ipeak_Iavg_v2(PostConImage, ROI);
                I_peak_post(i,j,n)=I_peak;
                I_peak_std_post(i,j,n)=I_peak_std;
                I_avg_post(i,j,n)=I_avg;
                I_std_post(i,j,n)=I_std;
                
            elseif peakget==0
                
                Data=PreConImage.*ROI;
                Data(isnan(Data))=0; %WTF NANS
                Data=nonzeros(Data);
                
                I_peak=0;
                I_peak_std=0;
                I_avg=mean(Data(:,1));
                I_std=std(Data(:,1));
                I_peak_pre(i,j,n)=I_peak;
                I_peak_std_pre(i,j,n)=I_peak_std;
                I_avg_pre(i,j,n)=I_avg;
                I_std_pre(i,j,n)=I_std; 
                
                Data=PostConImage.*ROI;
                Data(isnan(Data))=0; %WTF NANS
                Data=nonzeros(Data);
                
                I_peak=0;
                I_peak_std=0;
                I_avg=mean(Data(:,1));
                I_std=std(Data(:,1));
                I_peak_post(i,j,n)=I_peak;
                I_peak_std_post(i,j,n)=I_peak_std;
                I_avg_post(i,j,n)=I_avg;
                I_std_post(i,j,n)=I_std;
                
            else
                fprintf('Do you want me to get the peak or nah? \n')
            end
            
            
        end
        
        %         end
    end
    
    fprintf('Animal %d done \n',i)
end
