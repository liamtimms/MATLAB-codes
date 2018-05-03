function [Stds] =get_RealAndImaginaryStds()

modality='UTE3D';
model='rSD12';
mask=zeros(200,200,200);
mask(:,:,50:100)=1;

for i=1:1:12
    
    an_num=sprintf('%d', i);
    folder='SD12_RAT_EXTRACTED_CORRECTED_CROPPED_ALIGNED';
    Subject=strcat(model, '_', an_num, '_', modality);
    
    if i==7
        totscan=7;
    elseif i==12
        totscan=6;
    else
        totscan=5;
    end
    
    for n=1:1:2
        for k=1:1:2
            
            if k==1
                type='REAL';
            elseif k==2
                type='IMAGINARY';
            elseif k==3
                type='MAGNITUDE';
                l=1;
            end
            
            scn_num=sprintf('%d', totscan);
            file=strcat(Subject, '_UTEscan', scn_num, '_', type, '_IMAGE_CORRECTED_CROPPED');
            loadname=strcat(folder, '\', file, '-label.nii');
            ROINii=load_nii(loadname);
            ROI=double(ROINii.img);
            ROI(ROI>0)=1;
            ROI(ROI~=1)=NaN;
            
            if n==1
                scn_num=sprintf('%d', n);
            end
            
            file=strcat(Subject, '_UTEscan', scn_num, '_', type, '_IMAGE_CORRECTED_CROPPED');
            loadname=strcat(folder, '\', file, '.nii');
            CurrentNii=load_nii(loadname);
            Image=double(CurrentNii.img);
            
            Data=Image.*ROI;
            Data=reshape(Data, 1, []);
            
            Stds(i,n,k)=nanstd(Data(:,:,:));
            clear Data;
        end
    end
    
end
