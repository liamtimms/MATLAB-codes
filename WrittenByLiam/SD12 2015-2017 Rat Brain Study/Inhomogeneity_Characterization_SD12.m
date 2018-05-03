function [Averages, Stdevs, Weights, Ns, Average_Normalized_AlongDim, Weight_Ave_Norm_AlongDim] =Inhomogeneity_Characterization_SD12(image, ROI, dimension)

N_elements=200;
N_dimensions=3;

Averages=zeros(N_elements, N_dimensions);
Stdevs=zeros(N_elements, N_dimensions);
Ns=zeros(N_elements, N_dimensions);

relevant_ROI=ROI;
relevant_ROI(relevant_ROI>0)=1;
Object=image.*relevant_ROI;


for j=1:1:200
    Averages(j, 1)=mean(nonzeros(Object(j,:,:)));
    Averages(j, 2)=mean(nonzeros(Object(:,j,:)));
    Averages(j, 3)=mean(nonzeros(Object(:,:,j)));
    Stdevs(j, 1)=std(nonzeros(Object(j,:,:)));
    Stdevs(j, 2)=std(nonzeros(Object(:,j,:)));
    Stdevs(j, 3)=std(nonzeros(Object(:,:,j)));
    Ns(j, 1)=sum(nonzeros(relevant_ROI(j,:,:)));
    Ns(j, 2)=sum(nonzeros(relevant_ROI(:,j,:)));
    Ns(j, 3)=sum(nonzeros(relevant_ROI(:,:,j)));
end

Weights = (Stdevs).^-2;

Average_Normalized_AlongDim(:) =Averages(:, dimension)/Averages(100, dimension);
blah=(Stdevs(100, dimension)/Averages(100, dimension))^2;  

for i=1:1:200
    Weight_Ave_Norm_AlongDim (i) = 1/(Average_Normalized_AlongDim(i)^2 * ( (Stdevs(i, dimension)/Averages(i, dimension))^2 + blah));
end    

end