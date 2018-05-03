%% this cell clears the work space so that there is no confusion
clear
clc
close all

%% Globally useful variables for this run
model='SD12';
N_elements=200;

%% Cell to scale the files and save them

%This cell is now broken + redundant with Codi's extraction code

for i=1:1:12
    
    type='Blood';
    an_num=sprintf('%d', i);
    Subject=strcat(model,'_', an_num,'_', type);
    n=i*7;
    RG=RGslope(n,1);
    slope=RGslope(n,2);
    
    
    %Scale the UTE, save it and then give the mask (ROI file) the same hdr
    %and save that too
    dim=.15;
    modality='UTE';
    reco='complex';
    filename=strcat(Subject,'_', modality, '_', reco, '.nii');
    
    if i==4
        filename=strcat(Subject,'_', modality, '_', reco, '_2.nii');
    end
    
    Raw_Data=load_nii(filename);
    Raw_image=double(Raw_Data.img);
    [RealImage, ImaginaryImage] =SplitComplex(Raw_image, N_elements);
    
    Raw_Data.hdr.dime.dim=[4 200 200 200 1 1 1 1]; %this is poorly written come back to it
    RealData=Raw_Data;
    ImaginaryData=Raw_Data;
    RealData.img=RealImage;
    ImaginaryData.img=ImaginaryImage;
    
    Scaled_Real=ScalingSD12(RealData, RG, slope, dim);
    Scaled_Imaginary=ScalingSD12(ImaginaryData, RG, slope, dim);
    
    savename=strcat(Subject,'_', modality, '_real_scaled.nii');
    save_nii(Scaled_Real, savename);
    
    savename=strcat(Subject,'_', modality, '_imaginary_scaled.nii');
    save_nii(Scaled_Imaginary, savename);
    
%     save_nii(Scaled_Data, savename);
%     Scaled_Data.img=Raw_ROI;
%     savename=strcat(Subject,'_', modality, '_mask_scaled.nii');
%     save_nii(Scaled_Data, savename);
    
%     %Scale the anatomy and save it
%     dim=0.3;
%     modality='ANAT';
% %     [Raw_Data, Raw_image, Raw_ROI] = loadMRIandROI(Subject, modality);
%     filename=strcat(Subject,'_', modality, '.nii');
%     Raw_Data=load_nii(filename);
%     Raw_image=double(Raw_Data.img);
%     Scaled_Data =ScalingSD12(Raw_Data, RG, slope, dim);
%     savename=strcat(Subject,'_', modality, '_scaled.nii');
%     save_nii(Scaled_Data, savename);    


end
%% Cell to load the scaled data and analyze it

%use 1 region, 3 dimensions to see x, y, z averages+standard deviations
%use 174 regions, 1 dimension to see region by region average+standard
%deviations

N_regions=1;
N_dimensions=3;
N_elements=200;
dimension=3 %this means we look along z in particular



for i=8:1:12

%     model='SD12';
%     type='Blood';
    type='Blood';
    an_num=sprintf('%d', i);
    modality='UTE';
%     folder=strcat(model, '_', num);
%     Subject=strcat(folder, '\scaled_NIFTIs\', folder,'_', type);
% 
%     Subject=strcat(folder, '\scaled_NIFTIs\', folder,'_', type)
%     [Scaled_Data, Scaled_image, Raw_ROI] = loadMRIandROI(Subject, modality);
% 
% 
%     [Averages, Stdevs, Ns, Object]=Inhomogeneity_Characterization_working(N_regions, N_dimensions, N_elements, Scaled_image, Raw_ROI);

%     
%     ObjectNii=Scaled_Data;
%     ObjectNii.img=Object;
%     view_nii(ObjectNii)
    part='real';
    Subject=strcat(model, '_', an_num, '_', type, '_', modality);
    filename=strcat(Subject, '_', part, '_scaled.nii')
    Raw_Data=load_nii(filename);
    Image=double(Raw_Data.img);
    
    Image=abs(Image);
    
    filename=strcat(Subject,'_', part, '_scaled-label.nii');
    Raw_ROI=load_nii(filename);
    ROI=double(Raw_ROI.img);
    
    [Averages, Stdevs, Weights, Ns, A, W] =Inhomogeneity_Characterization_SD12(Image, ROI, dimension);
    Average_AbsVal_Normalized_AlongZ_R(i,:)=A(:);
    Weight_Ave_Norm_AlongZ_R(i,:)=W(:);
    
    %uses same ROI
    part='imaginary';
    Subject=strcat(model, '_', an_num, '_', type, '_', modality);
    filename=strcat(Subject, '_', part, '_scaled.nii')
    Raw_Data=load_nii(filename);
    Image=double(Raw_Data.img); 
    
    Image=abs(Image);
    
    filename=strcat(Subject,'_', part, '_scaled-label.nii');
    Raw_ROI=load_nii(filename);
    ROI=double(Raw_ROI.img);

    [Averages, Stdevs, Weights, Ns, A, W] =Inhomogeneity_Characterization_SD12(Image, ROI, dimension);
    Average_AbsVal_Normalized_AlongZ_I(i,:)=A(:);
    Weight_Ave_Norm_AlongZ_I(i,:)=W(:);
end

%%

for i=1:1:200
    A(i)=mean(Average_Z(:,i));
    S(i)=std(Average_Z(:,i));
end

%%

for i=1:1:12
    for j=1:1:200
    Average_Intensity(i,j)=sqrt((Average_Z_R(i,j))^2 + (Average_Z_I(i,j))^2);
    end  
    
end

for i=1:1:12

    Normalized_Average_Z_R(i,:)=Average_Z_R(i,:)/Average_Z_R(i,100);
%     NormAveZreduced(i,:)=Normalized_Average_Z(i,:);
    WeightAveZ_R(i,:)= (Stdev_Z_R(i,:)).^-2;
    Normalized_Average_Z_I(i,:)=Average_Z_I(i,:)/Average_Z_I(i,100);
%     NormAveZreduced(i,:)=Normalized_Average_Z(i,:);
    WeightAveZ_I(i,:)= (Stdev_Z_I(i,:)).^-2;  
    Normalized_Average_Intensity(i,:)=Average_Intensity(i,:)/Average_Intensity(i,100);
end

%for i=9:1:12
%     n=i-6;
%     NormAveZreduced(n,:)=Normalized_Average_Z(i,:);
%     WeightAveZ(n,:)= (Stdev_Z(i,:)).^-2;
% end

%%
for i=1:1:12
    for j=1:1:200
    Z(i,j)=j;
    end
end
%%

% Load the data for x, y, and yfit
load fitdata x y yfit

% Create a scatter plot of the original x and y data
figure
scatter(x, y, 'k')

% Plot yfit
line(x, yfit, 'Color', 'k', 'LineStyle', '-', 'LineWidth', 2)

% Plot upper and lower bounds, calculated as 0.3 from yfit
line(x, yfit + 0.3, 'Color', 'r', 'LineStyle', '--', 'LineWidth', 2)
line(x, yfit - 0.3, 'Color', 'r', 'LineStyle', '--', 'LineWidth', 2)

% Add a legend and axis labels
legend('Data', 'Fit', 'Lower/Upper Bounds', 'Location', 'NorthWest')
xlabel('X')
ylabel('Noisy')


%%

modality='UTE';


for i=12:1:12
    
    type='Rat';
    an_num=sprintf('%d', i);
    folder=strcat(model, '_', an_num);
    newfolder='corrected_NIFTIs';
    
%     mkdir(folder, newfolder);
    
    Subject=strcat(folder, '\scaled_NIFTIs\', folder,'_', type);
    
    for j=6:1:6
        scan=sprintf('%d', j);
        filename=strcat(Subject,'_',modality,scan,'_scaled.nii');
        CorrectedData = Inhomogeneity_Correction(filename);
        savename=strcat(folder, '\corrected_NIFTIs\', folder,'_', type,'_', modality,scan,'_scaled_corrected.nii');
        save_nii(CorrectedData, savename);
    end
    
    type='blood';
    Subject=strcat(folder, '\scaled_NIFTIs\', folder,'_', type);
    filename=strcat(Subject,'_',modality,'_scaled.nii');
    CorrectedData = Inhomogeneity_Correction(filename);
    savename=strcat(folder, '\corrected_NIFTIs\', folder,'_', type,'_', modality,'_scaled_corrected.nii');
    save_nii(CorrectedData, savename);

    
end





