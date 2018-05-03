map=double(atlas.img);
n=0;

for i=1:1:174
   region=map;
   region(region~=i)=0;
   region(region==i)=1;
   
   
   
   x(i)=sum(region(:));
   
   if x(i)<1000
       i
       x;
       n=n+1;
   end
    
end

n