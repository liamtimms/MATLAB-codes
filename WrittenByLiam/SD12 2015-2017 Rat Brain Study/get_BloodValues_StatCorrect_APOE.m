%% Version 4 from BloodValues.m moved to a function for ease of use and memory concerns

function [ROIave, ROIStds] =get_BloodValues_StatCorrect_APOE()

k=3;
mask=zeros(200,200,200);
mask(:,:,50:100)=1;

BloodFromPeak=0; BloodFromPeakStd=0; ROIave=0; ROIStds=0;


Stds=get_RealAndImaginaryStds_APOE();

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
        
        
        n=0;
        for j=1:totscan-1:totscan
            
            n=n+1;
            
            if j==1
                ROI_scn_num=sprintf('%d', 2);
            else
                ROI_scn_num=sprintf('%d', j);
            end
            
            file=strcat(Subject, '_UTEscan', ROI_scn_num, '_MAGNITUDE_IMAGE_CORRECTED_CROPPED_METH2');
            
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

end
