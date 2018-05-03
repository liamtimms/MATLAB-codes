function [myDataRaw] =get_CircuitsGrouped(myDataRaw, Circuit)

[a b c]=size(myDataRaw);

s=size(Circuit);
CircuitData=myDataRaw(1,1,Circuit(1));

for i=1:1:a
    for j=1:1:b
        
        CircuitData=cell2mat(myDataRaw(i,j,Circuit(1)));
        for n=2:1:s(1)
            data=cell2mat(myDataRaw(i,j,Circuit(n)));
            CircuitData=[CircuitData; data];
        end
        
        k=c+1;
        myDataRaw{i,j,k}=CircuitData;
        
        clear CircuitData
    end
end


end