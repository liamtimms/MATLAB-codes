function [NewAtlasNii] = AtlasFixer(AtlasNii, SourceNii)

%AtlasNii.hdr=SourceNii.hdr
AtlasImg=double(AtlasNii.img);

s=size(AtlasImg);
for i=1:s(3)
    Slice(:,:)=AtlasImg(:,:,i);
    Slice=rot90(Slice,2);
    NewAtlasImg(:,:,i)=Slice(:,:);
end

NewAtlasNii=SourceNii;
NewAtlasNii.img=NewAtlasImg;
end