%%
clear all
clc

%%

% midVal=zeros(200,12);
% stdVal=zeros(200,12);

for i=1:1:6
    
s1=sprintf('%d',i);
loadName1=strcat('SD12_',s1,'_blood_UTE_scaled_corrected.nii');
loadName2=strcat('SD12_',s1,'_Blood_UTE_scaled-label.nii');
M=load_nii(loadName1);
N=load_nii(loadName2);

Z=double(M.img);P=double(N.img);P(P>1)=1;
Z=Z.*P;

for j=1:1:200
   aveVal(j,i)=mean(nonzeros(Z(:,:,j)));
   stdVal(j,i)=std(nonzeros(Z(:,:,j)));    
end

midVal(i)=aveVal(100, i);

end
%%

csvwrite('IBvaluesAtMid.csv',midVal')