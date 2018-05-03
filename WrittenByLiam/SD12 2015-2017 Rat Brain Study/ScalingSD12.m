function [Scaled_Data] =ScalingSD12(Raw_Data, RG, slope, dim)
Scaled_Data=Raw_Data;
Scaled_Data.hdr.dime.pixdim=[0 dim dim dim 0 0 0 0];
factor=slope/RG;
Scaled_Data.img=double(Scaled_Data.img).*factor;
end 