for j=1:1:6
iter=1;
allpos=0;
while allpos==0 && iter<10

    NumReg=174;
modality='UTE3D';
model='rSD12';
reg_num=sprintf('%d', NumReg);
folder1='SD12_RAT_CBV_REDO';
folder2='Atlas_Map_Files';


    an_num=sprintf('%d', j);
    Subject=strcat(model, '_', an_num, '_', modality);
    type='MAGNITUDE';

    file=strcat('map_', Subject, '_MAGNITUDE_IMAGE_', reg_num ,'_REGION');
    loadname=strcat(folder2, '\', file, '.nii');
    ATLASNii=load_nii(loadname);
    ATLASimg=double(ATLASNii.img);
    
    for i=2:1:2
        scn_num=sprintf('%d', i);
        file=strcat(Subject, '_CBV_from_', scn_num, '_', type, '_IMAGE_CORRECTED_CROPPED_METH2');
        loadname=strcat(folder1, '\', file, '.nii');
        CBVNii=special_load_nii(loadname);
        CBVImg=double(CBVNii.img);
        
        
%         for k=1:1:NumReg+1
            % select region
            ROI=ATLASimg;
            
%             if k<(NumReg+1)
%                 ROI(ROI~=k)=0;
%             end
            
            ROI(ROI~=0)=1;
            Data=CBVImg.*ROI;
            Data(Data==0)=NaN;
            
            
%             im=Data;
            s=size(Data);
            ny=s(2)/iter;nx=s(1)/iter;nz=s(3)/iter; %% desired output dimensions
%             y=linspace(1,s(2),ny);
%             x=linspace(1,s(1),nx);
%             z=linspace(1,s(3),nz));
%             imOut=interp3(im,x,y,z);
%             imOut=interp3(im,iter);
            
            new_size=[nx ny nz];
            mat=Data;
            
            mat_rs = resize(mat, new_size);
            
            imOut=mat_rs;
            imOut(imOut>0)=0;
            imOut(isnan(imOut))=0;
            Tot=sum(nonzeros(imOut));
            Total(j,iter)=Tot;
            if Tot==0
                allpos=1;
            else
                iter=iter+1;
            end
            
            temp=smooth3(Data)
%             Data(isnan(Data))=0; %WTF NANS
%             Data=nonzeros(Data);
            
%             myDataRaw{i,j,k}=Data;
    end
        
end
    Final(j)=iter;

end
