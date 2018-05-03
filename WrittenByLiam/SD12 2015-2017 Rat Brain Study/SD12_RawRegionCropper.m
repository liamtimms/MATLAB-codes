

NumAns=4;
NumScans=5;
NumReg=174;

modality='UTE3D';
model='rSD12';
reg_num=sprintf('%d', NumReg);
folder1='SD12_RAT_EXTRACTED_CORRECTED_CROPPED_ALIGNED_MAGS_RENAMED';
folder2='Atlas_Map_Files';
folder3='SD12_RAT_SELECT_REGIONS';

SelectAns=[1 2 3 4 5 6 7 8 9 10];
SelectScans=[1 4];
SelectRegions=[52];
sa=size(SelectAns);
ss=size(SelectScans);
sr=size(SelectRegions);

for n=1:1:sa(2)
    j=SelectAns(n);
    an_num=sprintf('%d', j);
    Subject=strcat(model, '_', an_num, '_', modality);
    type='MAGNITUDE';
    
    file=strcat('map_', Subject, '_MAGNITUDE_IMAGE_', reg_num ,'_REGION');
    loadname=strcat(folder2, '\', file, '.nii');
    ATLASNii=load_nii(loadname);
    ATLASimg=double(ATLASNii.img);
    
    for m=1:1:ss(2)
        i=SelectScans(m);
        scn_num=sprintf('%d', i);
        file=strcat(Subject, '_UTEscan', scn_num, '_', type, '_IMAGE_CORRECTED_CROPPED_METH2');
        loadname=strcat(folder1, '\', file, '.nii');
        IntensityNii=special_load_nii(loadname);
        IntensityImg=double(IntensityNii.img);
        
        
        for l=1:1:sr(2)
            % select region
            k=SelectRegions(l);
            
            ROI=ATLASimg;
            
            if k<(NumReg+1)
                ROI(ROI~=k)=0;
            end
            
            ROI(ROI~=0)=1;
            CroppedImg=IntensityImg.*ROI;
            CroppedImg(CroppedImg==0)=NaN;
            CroppedNii=IntensityNii;
            CroppedNii.img=CroppedImg;
            %             view_nii(CroppedNii);
            
            rgn_num=sprintf('%d', k);
            
            
            file=strcat(Subject, '_UTEscan', scn_num, '_', type, '_Region_', rgn_num);
            savename=strcat(folder3, '\', file, '.nii');
            save_nii(CroppedNii, savename);
            
        end
    end
end