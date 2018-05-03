for i=1:1:12
    s1=sprintf('%d',i);
    ScanName=strcat('map_rSD12_',s1,'_Rat_ANAT_scaled','.nii');
M=load_nii(ScanName);
N=load_nii(strcat('rSD12_',s1,'_Rat_ANAT_scaled.nii'));
M.hdr=N.hdr;
save_nii(M,strcat('map_rSD12_',s1,'_Rat_ANAT_scaled_hdr_fixed','.nii'));

Z=double(M.img);
Z(Z>1)=1;
M.img=Z;
save_nii(M,strcat('map_rSD12_',s1,'_Rat_ANAT_scaled_MASK','.nii'));

end