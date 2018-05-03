function [Raw_Data, Raw_image, Raw_ROI] =loadMRIandROI(Subject, modality)
    filename=strcat(Subject,'_', modality, '.nii');
    Raw_Data=load_nii(filename);
    Raw_image=double(Raw_Data.img); %extracts the raw data we are considering
    filename=strcat(Subject,'_UTE_scaled-label.nii');
%     filename=strcat(Subject,'_mask3.nii');
    Raw_ROI=load_nii(filename);
    Raw_ROI=double(Raw_ROI.img); %loads the "Region Of Interest" mask
end 