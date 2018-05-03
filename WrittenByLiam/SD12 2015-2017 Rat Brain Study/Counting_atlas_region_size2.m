clear

AtlasNii=load_nii('map_rSD12_1_UTE3D_UTEscan5_MAGNITUDE_IMAGE_59_REGION.nii');
A=double(AtlasNii.img);

ImageNii=load_nii('rSD12_1_UTE3D_UTEscan2_MAGNITUDE_IMAGE_CORRECTED.nii');
Image=double(ImageNii.img);
% view_nii(ImageNii)

Image(Image>0)=1;
Image(Image~=1)=0;

n=0;
for i=1:1:174
    
    Region=A;
    Region(Region~=i)=0;
    Region(Region~=0)=1;
    
    Overlap=Image.*Region;
    Nv(i)=sum(Overlap(:));
    if Nv(i)<5000 && Nv(i)~=0
        i
        n=n+1;
    end
    
    

end

n