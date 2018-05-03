%  Mean for real and imaginary with ROI
clear
clc
close all

UTE1_Intensity=zeros(12,2);
for i=1:1:12
    i
    anNum=sprintf('%d',i);
   loadnameROI=strcat('SD12_',anNum,'_Rat_ANAT_scaled-label.nii');
   loadnameUTE1_R=strcat('SD12_',anNum,'_UTE3D_UTEscan1_REAL_IMAGE.nii');
   loadnameUTE1_I=strcat('SD12_',anNum,'_UTE3D_UTEscan1_IMAGINARY_IMAGE.nii');
   
   Mask=load_nii(loadnameROI);
   Mask=double(Mask.img);
   Mask(Mask~=0)=1;
   
   UTER=load_nii(loadnameUTE1_R);
   UTER=abs(double(UTER.img));
   UTER=Mask.*UTER;
   UTER=nonzeros(UTER);
   
   UTEI=load_nii(loadnameUTE1_I);
   UTEI=abs(double(UTEI.img));
   UTEI=Mask.*UTEI;   
   UTEI=nonzeros(UTEI);
   
    UTE1_Intensity(i,1)=sqrt(mean(UTER)^2+mean(UTEI)^2);
   UTE1_Intensity(i,2)=(std(UTER)+std(UTEI))/2;
   
    
end

%% Make ATLAS Mask for Capillaries from Anesthetized Scans
clear
clc
close all
CUTOFF_VAL=zeros(12,1);
%%
scanNum='5';

for i=1:1:1
    anNum=sprintf('%d',i);
    
loadname=strcat('map_rSD12_',anNum,'_UTE3D_UTEscan',scanNum,'_MAGNITUDE_IMAGE_174_REGION.nii'); %load reigstered atlas
MAP=load_nii(loadname);
MAP_IMG=double(MAP.img);
MAP_IMG(MAP_IMG>0)=1;

loadname=strcat('rSD12_',anNum,'_UTE3D_UTEscan',scanNum,'_MAGNITUDE_IMAGE.nii'); %load ANES scan
ANES=load_nii(loadname);
ANES_IMG=double(ANES.img);

loadname=strcat('rSD12_',anNum,'_UTE3D_UTEscan1_MAGNITUDE_IMAGE.nii'); %load ANES scan
PRECON=load_nii(loadname);
PRECON_IMG=double(PRECON.img);


DIFF_IMG=(ANES_IMG-PRECON_IMG);
for z=1:1:200
    for j=1:1:200
        for k=1:1:200
            if PRECON_IMG(z,j,k)~=0
                DIFF_IMG(z,j,k)=DIFF_IMG(z,j,k)/PRECON_IMG(z,j,k)*100;
            end
        end
    end
end


DIFF_IMG(DIFF_IMG>CUTOFF_VAL(i,1))=0;
DIFF_IMG=MAP_IMG.*DIFF_IMG;
DIFF_IMG(DIFF_IMG>0)=1;
PRECON.img=DIFF_IMG;
view_nii(PRECON)

% 
% ANES.img=DIFF_IMG;
% 
% 
% savename=strcat('capillary_map_',anNum,'.nii');
% save_nii(ANES,savename);


end

%% Show histogram of intensity in precontrast images
clear
clc
close all
scanNum='5';

for i=9:1:9
anNum=sprintf('%d',i);
loadnameUTE1=strcat('rSD12_',anNum,'_UTE3D_UTEscan1_MAGNITUDE_IMAGE.nii');
M=load_nii(loadnameUTE1);
M_IMG=double(M.img);

loadname=strcat('map_rSD12_',anNum,'_UTE3D_UTEscan',scanNum,'_MAGNITUDE_IMAGE_174_REGION.nii'); %load reigstered atlas
MAP=load_nii(loadname);
MAP_IMG=double(MAP.img);
MAP_IMG(MAP_IMG>0)=1;

M_IMG=M_IMG.*MAP_IMG;
M_vals=nonzeros(M_IMG);

figure
hist(M_vals,1000)
end



