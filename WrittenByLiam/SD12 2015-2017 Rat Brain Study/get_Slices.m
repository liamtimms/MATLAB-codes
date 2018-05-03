function [Slices] =get_Slices(Image, direction, NumSlices, offset)

s=size(Image);
begining=max(s);
ending=0;

if strcmp('sagittal',direction)
    d=1;
elseif strcmp('coronal',direction)
    d=2;
elseif strcmp('axial',direction)
    d=3;
end


for i=1:1:s(d)
    
    if strcmp('sagittal',direction)
        data(:,:)=Image(i,:,:);
    elseif strcmp('coronal',direction)
        data(:,:)=Image(:,i,:);
    elseif strcmp('axial',direction)
        data(:,:)=Image(:,:,i);
    end
    
    data(isnan(data))=0;
    s2=size(nonzeros(data));
    
    if s2(1,1)~=0
        if i<begining
            begining=i;
        end
        
        if i>ending
            ending=i;
        end
        
    end
    
end

step=int64((ending-begining)/NumSlices);

n=1;
for i=(begining+offset):step:ending
    Slices(n)=i;
    n=n+1;
end


end