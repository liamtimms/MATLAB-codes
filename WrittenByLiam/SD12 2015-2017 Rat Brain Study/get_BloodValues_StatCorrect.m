%% Version 4 from BloodValues.m moved to a function for ease of use and memory concerns

function [ROIave, ROIStds] =get_BloodValues_StatCorrect()

k=3;
modality='UTE3D';
model='rSD12';
mask=zeros(200,200,200);
mask(:,:,50:100)=1;

BloodFromPeak=0; BloodFromPeakStd=0; ROIave=0; ROIStds=0;


Stds=get_RealAndImaginaryStds();

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
    
    
    n=0;
    for j=1:totscan-1:totscan
        
        n=n+1;
        
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
        
        stdforcorrection=(Stds(i,n,1)+Stds(i,n,2))/2;
        
        ROIave(i,j)=((mean(Data(:,1)))^2 - stdforcorrection^2)^(.5);
        ROIStds(i,j)=std(Data(:,1));
          
    end
end

end
