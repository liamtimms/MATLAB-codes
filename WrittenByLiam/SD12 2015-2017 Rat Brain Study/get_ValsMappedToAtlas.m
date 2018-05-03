function [NewAtlasNii] =get_ValsMappedToAtlas(Vector)

% Adapted from "Atlas Crafting Generic v2"
AtlasNii=special_load_nii('map_Rat_Atlas_68_REGION.nii');
AtlasImg=double(AtlasNii.img);

NewAtlasNii=AtlasNii;
% NewAtlasImg=zeros(size(AtlasImg));
NewAtlasImg=AtlasImg;

[NumOfRegions temp]=size(Vector);

if temp~=1
    fprintf('Check data structure');
end

AtlasSize=sprintf('%d',NumOfRegions);

for i=1:1:NumOfRegions
%     Temp=AtlasImg;
%     Temp(Temp~=i)=0;
%     Temp(Temp==i)=Vector(i);
%     NewAtlasImg=NewAtlasImg + Temp; 
      NewAtlasImg(NewAtlasImg==i)=Vector(i);
end

NewAtlasNii.img=NewAtlasImg;

end