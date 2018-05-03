% Craft new Atlases from a vecmap (174x1 vector with assigned values)
current_map='map_Rat_Atlas.nii';
MapNii=special_load_nii(current_map);
AtlasImage=MapNii.img;
NewAtlas=zeros(size(AtlasImage));
[a temp]=size(Vector);
AtlasSize=sprintf('%d',a);
for j=1:1:174
    Temp=AtlasImage;
    Temp(Temp~=j)=0;
    Temp(Temp==j)=vecmap(j);
    NewAtlas=NewAtlas + Temp;
end
MapNii.img=NewAtlas;
saveName='map_Rat_Atlas59.nii';
save_nii(MapNii,saveName)
