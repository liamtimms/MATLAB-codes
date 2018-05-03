function [Stds] =get_RealAndImaginaryStds_APOE()

modality='UTE3D';

mask=zeros(200,200,200);
mask(:,:,50:100)=1;

modality='UTE3D';
model='APOE';

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
        
        for n=1:1:2
            for k=1:1:2
               
                type='IMAGINARY';
                scn_num=sprintf('%d', 1);
                file=strcat(Subject, '_UTEscan', scn_num, '_', type, '_IMAGE_CORRECTED_CROPPED');
                loadname=strcat(folder, '\', file, '-label.nii');
                ROINii=load_nii(loadname);
                ROI=double(ROINii.img);
                ROI(ROI>0)=1;
                ROI(ROI~=1)=NaN;
                
                if k==1
                    type='REAL';
                elseif k==2
                    type='IMAGINARY';
                elseif k==3
                    type='MAGNITUDE';
                    l=1;
                end

                scn_num=sprintf('%d', n);
                 
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
    
end
