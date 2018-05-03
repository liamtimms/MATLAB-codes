N=load_nii('map_rSD12_1_UTE3D_UTEscan5_MAGNITUDE_IMAGE_59_REGION.nii');
A=double(N.img);

M=load_nii('rSD12_1_UTE3D_UTEscan2_MAGNITUDE_IMAGE_CORRECTED.nii');
Z=double(M.img);
view_nii(M)

Z(Z>0)=1;

Count_map=zeros(174,1);

for i=1:1:174
   
   P=A;
   P(P~=i)=0;
   P(P==i)=1;
   
   F=Z;
   x=F.*P;
   Count_map(i,1)=size(nonzeros(x));   
%    
%    figure
%    pause(1)
%    hist(nonzeros(F))

end