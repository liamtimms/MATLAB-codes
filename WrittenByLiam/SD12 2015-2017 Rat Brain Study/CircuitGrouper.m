[a b c]=size(myDataRaw);

s=size(Circuit3);
CircuitData=myDataRaw(1,1,Circuit3(1));


for i=1:1:a
    for j=1:1:b
        
        CircuitData=cell2mat(myDataRaw(i,j,Circuit3(1)));
        for n=2:1:s(1)
            data=cell2mat(myDataRaw(i,j,Circuit3(n)));
            CircuitData=[CircuitData; data];
        end
        
        k=c+1;
        myDataRaw{i,j,k}=CircuitData;
        
        clear CircuitData
    end
end

[a b c]=size(myDataRaw);