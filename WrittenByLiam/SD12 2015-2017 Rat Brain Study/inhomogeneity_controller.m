%% this cell clears the work space so that there is no confusion
clear
clc
close all

%% Globally useful variables for this run
model='SD12';
% type='Blood';

%% Cell to scale the files and save them

for i=1:1:12

    num=sprintf('%d', i);
    Subject=strcat(model,'_', num,'_', type);
    n=i*6;
    RG=RGslope(n,1);
    slope=RGslope(n,2);
    
    %Scale the UTE, save it and then give the mask (ROI file) the same hdr
    %and save that too
    dim=.15;
    modality='UTE';
%     [Raw_Data, Raw_image, Raw_ROI] = loadMRIandROI(Subject, modality);
    filename=strcat(Subject,'_', modality, '.nii');
    Raw_Data=load_nii(filename);
    Raw_image=double(Raw_Data.img);
    Scaled_Data =ScalingSD12(Raw_Data, RG, slope, dim); %are we doing the same thing for this? Maybe not
    savename=strcat(Subject,'_', modality, '_scaled.nii');
    save_nii(Scaled_Data, savename);
    
%     save_nii(Scaled_Data, savename);
%     Scaled_Data.img=Raw_ROI;
%     savename=strcat(Subject,'_', modality, '_mask_scaled.nii');
%     save_nii(Scaled_Data, savename);
    
    %Scale the anatomy and save it
    dim=0.3;
    modality='ANAT';
%     [Raw_Data, Raw_image, Raw_ROI] = loadMRIandROI(Subject, modality);
    filename=strcat(Subject,'_', modality, '.nii');
    Raw_Data=load_nii(filename);
    Raw_image=double(Raw_Data.img);
    Scaled_Data =ScalingSD12(Raw_Data, RG, slope, dim);
    savename=strcat(Subject,'_', modality, '_scaled.nii');
    save_nii(Scaled_Data, savename);
    


end
%% Cell to load the scaled data and analyze it

%use 1 region, 3 dimensions to see x, y, z averages+standard deviations
%use 174 regions, 1 dimension to see region by region average+standard
%deviations

N_regions=1;
%N_regions=174;
%N_FAs=3;
N_dimensions=3;
%N_dimensions=1;
N_elements=200;                                       



for i=8:1:12

%     model='SD12';
%     type='Blood';
    type='Blood';
    num=sprintf('%d', i);
    modality='UTE_scaled';
    folder=strcat(model, '_', num);
    Subject=strcat(folder, '\scaled_NIFTIs\', folder,'_', type);
    [Scaled_Data, Scaled_image, Raw_ROI] = loadMRIandROI(Subject, modality);
    [Averages, Stdevs, Ns, Object]=Inhomogeneity_Characterization_working(N_regions, N_dimensions, N_elements, Scaled_image, Raw_ROI);
    Average_Z(i,:)=Averages(1, :, 3);
    Stdev_Z(i, :)=Stdevs(1,:,3);
    N_Z(i, :)=Ns(1,:,3);
    
    ObjectNii=Scaled_Data;
    ObjectNii.img=Object;
    view_nii(ObjectNii)
    
%     view_nii(Scaled_Data)

    
%     Normalized_Average_Z(i,:)=Average_Z(i,:)/Average_Z(i,100);
%     for j=1:1:3
%         k=100;
%         x=Averages(i,k,j);
%         while isnan(x)
%             k=k+k*(-1)^k
%             x=Averages(i,k,j);
%         end
%         Normalized_Averages(i,:,j)=Averages(i,:,j)/Averages(i,k,j);  
%     end
    
end

%%

for i=1:1:200
    A(i)=mean(Average_Z(:,i));
    S(i)=std(Average_Z(:,i));
end

%%

for i=1:1:11
    Normalized_Average_Z(i,:)=Average_Z(i,:)/Average_Z(i,100);
    NormAveZreduced(i,:)=Normalized_Average_Z(i,:);
    WeightAveZ(i,:)= (Stdev_Z(i,:)).^-2;
end

%for i=9:1:12
%     n=i-6;
%     NormAveZreduced(n,:)=Normalized_Average_Z(i,:);
%     WeightAveZ(n,:)= (Stdev_Z(i,:)).^-2;
% end

%%
for i=1:1:11
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
    num=sprintf('%d', i);
    folder=strcat(model, '_', num);
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





