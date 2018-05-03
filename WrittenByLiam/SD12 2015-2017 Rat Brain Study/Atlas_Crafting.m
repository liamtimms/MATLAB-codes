% Craft new Atlases from a vecmap (174x1 vector with assigned values)
for i=1:1:12
    AnNum=sprintf('%d',i);
    current_map=strcat('APOE',AnNum,'_map_scaled.nii');
    MapNii=special_load_nii(current_map);
    AtlasImage=MapNii.img;
    NewAtlas=zeros(size(AtlasImage));
    [a temp]=size(unique(vecmap));
    AtlasSize=sprintf('%d',a);
    for j=1:1:174
        Temp=AtlasImage;
        Temp(Temp~=j)=0;
        Temp(Temp==j)=vecmap(j);
        NewAtlas=NewAtlas + Temp;
    end
    MapNii.img=NewAtlas;
    saveName=strcat('APOE',AnNum,'_',AtlasSize,'_Atlas.nii');
    save_nii(MapNii,char(saveName))
end