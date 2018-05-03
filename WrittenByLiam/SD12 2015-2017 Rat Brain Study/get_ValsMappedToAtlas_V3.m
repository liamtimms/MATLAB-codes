function [NewAtlasNii] =get_ValsMappedToAtlas_V3(Vector, NumOfRegions, blahblahblah)

s=sprintf('%d',NumOfRegions);
loadname=strcat('map_Rat_Atlas_', s, '_REGION.nii');
AtlasNii=load_nii(loadname);
AtlasImg=double(AtlasNii.img);

NewAtlasNii=blahblahblah;
% NewAtlasNii.hdr.dime.bitpix=32;
% NewAtlasNii.hdr.dime.datatype=16;
NewAtlasImg=zeros(size(AtlasImg));
% NewAtlasImg=AtlasImg;

% 
% if temp~=1
%     fprintf('Check data structure');
% end


for i=1:1:NumOfRegions
    Temp=AtlasImg;
    Temp(Temp~=i)=0;
    Temp(Temp==i)=Vector(i)*100;
    NewAtlasImg=NewAtlasImg + Temp; 
%       NewAtlasImg(NewAtlasImg==i)=Vector(i);
end

NewAtlasImg(NewAtlasImg==0)=NaN;
NewAtlasNii.img=NewAtlasImg;

end