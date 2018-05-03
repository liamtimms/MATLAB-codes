function [SummedCapMapImg] =get_SummedCapMap(i, Subject, type, folder)

if i==7
    totscan=7;
elseif i==12
    totscan=6;
else
    totscan=5;
end

skip=totscan-5;
SummedCapMapImg=zeros(200,200,200);

for j=(2+skip):1:(5+skip)
    
    scn_num=sprintf('%d', j);
    file=strcat('map_' ,Subject, '_Caps_CBV_from_UTEscan', scn_num, '_', type, '_IMAGE_CORRECTED_CROPPED_METH2');
    loadname=strcat(folder, '\', file, '.nii');
    CapMapNii=load_nii(loadname);
    CapMapImg=double(CapMapNii.img);
    SummedCapMapImg=CapMapImg+SummedCapMapImg;
    
end

SummedCapMapImg(SummedCapMapImg~=0)=1;

end