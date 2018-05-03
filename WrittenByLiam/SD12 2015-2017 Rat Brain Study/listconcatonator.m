m=1;
new='';
for i=1:1:174
    n=vector(i);
    if n==m
        new=strcat(new,{', '},names(i))
    elseif n~=m
        list(n)=new;
        new=names(i);
        m=m+1;
    end

end