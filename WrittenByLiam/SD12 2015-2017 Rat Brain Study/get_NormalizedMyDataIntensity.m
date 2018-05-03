function [myDataRaw_Normalized] =get_NormalizedMyDataIntensity(myDataRaw, BloodVector)

[a, b, c]=size(myDataRaw);
[ab, bb]=size(BloodVector);

if ab==a && bb==b
    
    for j=1:1:b
        for i=1:1:a
            
            factor=BloodVector(i,j);
            
            for k=1:1:c
                % select region
                Data=cell2mat(myDataRaw(i,j,k)); 
                myDataRaw_Normalized{i,j,k}=Data/factor;
            end
        end
    end
    
else
    fprintf('unequal number of blood values for scans');
end


end