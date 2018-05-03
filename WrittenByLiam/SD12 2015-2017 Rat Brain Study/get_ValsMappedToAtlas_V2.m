function [NewAtlasNii] =get_ValsMappedToAtlas_V2(Vector)

[NumOfRegions, temp]=size(Vector);
s=sprintf('%d',NumOfRegions-1);
loadname=strcat('map_Rat_Atlas_', s, '_REGION.nii');
AtlasNii=special_load_nii(loadname);
AtlasImg=double(AtlasNii.img);

NewAtlasNii=AtlasNii;
NewAtlasImg=zeros(size(AtlasImg));
% NewAtlasImg=AtlasImg;


if temp~=1
    fprintf('Check data structure');
end


for i=1:1:NumOfRegions
    Temp=AtlasImg;
    Temp(Temp~=i)=0;
    Temp(Temp==i)=Vector(i);
    NewAtlasImg=NewAtlasImg + Temp; 
%       NewAtlasImg(NewAtlasImg==i)=Vector(i);
end

NewAtlasImg(NewAtlasImg==0)=NaN;
NewAtlasNii.img=NewAtlasImg;

end