function [myDataRaw] =get_myDataRaw(NumScans, NumAns, NumReg)

modality='UTE3D';
model='rSD12';
reg_num=sprintf('%d', NumReg);
folder1='SD12_RAT_CBV_REDO';
folder2='Atlas_Map_Files_test';

for j=1:1:NumAns
    an_num=sprintf('%d', j);
    Subject=strcat(model, '_', an_num, '_', modality);
    type='MAGNITUDE';

    file=strcat('map_', Subject, '_MAGNITUDE_IMAGE_', reg_num ,'_REGION');
    loadname=strcat(folder2, '\', file, '.nii');
    ATLASNii=load_nii(loadname);
    ATLASimg=double(ATLASNii.img);
    
    for i=1:1:NumScans
        scn_num=sprintf('%d', i);
        file=strcat(Subject, '_CBV_from_', scn_num, '_', type, '_IMAGE_CORRECTED_CROPPED_METH2');
        loadname=strcat(folder1, '\', file, '.nii');
        CBVNii=special_load_nii(loadname);
        CBVImg=double(CBVNii.img);
        
        
        for k=1:1:NumReg+1
            % select region
            ROI=ATLASimg;
            
            if k<(NumReg+1)
                ROI(ROI~=k)=0;
            end
            
            ROI(ROI~=0)=1;
            Data=CBVImg.*ROI;
            Data(isnan(Data))=0; %WTF NANS
            Data=nonzeros(Data);
            
            myDataRaw{i,j,k}=Data;
        end
    end
end

end