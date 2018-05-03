% Take CBV brain Files and organize them into 1D matricies per region
clear
clc
close all
% my Data is organized by (AnType, AnimalNum, Region)
AnimalTypes=2;
myData.AnimalNum=cell(1,AnimalTypes);
myData.AnimalNum(1,1)={[7 8 9 10 11]};
myData.AnimalNum(1,2)={[18 19 20 21 22 23]};

totalAnimals=[];
for i=1:1:AnimalTypes
    [temp totalAnimals(i)]=size(cell2mat(myData.AnimalNum(1,i)));
end

myData.NII=cell(AnimalTypes,max(totalAnimals));
RegionNums=175
myDataRaw=cell(AnimalTypes,max(totalAnimals),RegionNums);

for i=1:1:AnimalTypes
    for j=1:1:totalAnimals(i)
        temp=cell2mat(myData.AnimalNum(1,i));
        AnNum=sprintf('%d',temp(j));
        myData.NII(i,j)={strcat('I:\Google Drive\Liam Timms Codi Share\APOEneg Analysis\APOE_COMPLEX_Analysis\APOE_RAT_CBV\APOE',AnNum,'_UTE3D_CBV_from_UTEscan2_MAGNITUDE_IMAGE_CORRECTED_CROPPED_METH2.nii')};
        myData.NII_174atlas(i,j)={strcat('I:\Google Drive\Liam Timms Codi Share\APOEneg Analysis\APOE_COMPLEX_Analysis\APOE_Atlas_Map_Files\APOE',AnNum,'_59_Atlas.nii')};
        for k=1:1:RegionNums
            currentNII=special_load_nii(char(myData.NII(i,j)));
            currentATLAS=special_load_nii(char(myData.NII_174atlas(i,j)));
            NII=currentNII.img;
            ATLAS=currentATLAS.img;
            if k==RegionNums
                ATLAS(ATLAS>1)=1;
            else
                ATLAS(ATLAS~=k)=0;
                ATLAS(ATLAS==k)=1;
            end
            NII=NII.*ATLAS;
            myDataRaw(i,j,k)=nonzeros(NII);
            
        end
    end
end


%% Create and initate the object
clear
clc
close all

load('myDataRaw106.mat')
% myDataRaw is a 4x12x175 cell array with
% (sober1,CO2,sober2,anes)x(animal num)x(region number)
% mydataSmooth=cell(size(myDataRaw));
[a b c]=size(myDataRaw);
resolution=0.001;
filtsize=3;

% ----Squish all animals into one concatenated representative animal -----
% myDataRawSmushed is 4x175 cell array with all animals counted
myDataRawSmushed=cell(a,c);
for i=1:1:a
    for j=1:1:c
        for k=1:1:b
            myDataRawSmushed(i,j)={[cell2mat(myDataRawSmushed(i,j)); cell2mat(myDataRaw(i,k,j))]};
        end
    end
end

% ----- Generate Histogram for finding Mode with Gauss Fit -----
% mydataHist and mydataHistSmooth are 4x12x175(countsXbins)cell arrays
mydataHist=cell(size(myDataRaw));
mydataHistSmooth=cell(size(myDataRaw));
for i=1:1:a
    for j=1:1:b
        for k=1:1:c
            maxVal=max(cell2mat(myDataRaw(i,j,k)));
            minVal=min(cell2mat(myDataRaw(i,j,k)));
            nbins=(maxVal-minVal)/resolution;
            [histCounts,histBins]=hist(reshape(cell2mat(myDataRaw(i,j,k)),[],1),nbins);
            mydataHist(i,j,k)={[histCounts;histBins]'};
            mydataHistSmooth(i,j,k)={[medfilt1(histCounts,filtsize);histBins]'};
        end
    end
end

% mydataSmooth is a 4x12x175 cell array with of Raw smoothed
mydataHistSmushed=cell(size(myDataRawSmushed));
mydataHistSmoothSmushed=cell(size(myDataRawSmushed));

for i=1:1:a
    for k=1:1:c
        maxVal=max(cell2mat(myDataRawSmushed(i,k)));
        minVal=min(cell2mat(myDataRawSmushed(i,k)));
        nbins=(maxVal-minVal)/resolution;
        [histCounts,histBins]=hist(reshape(cell2mat(myDataRawSmushed(i,k)),[],1),nbins);
        mydataHistSmushed(i,k)={[histCounts;histBins]'};
        mydataHistSmoothSmushed(i,k)={[medfilt1(histCounts,filtsize);histBins]'};
    end
    
end
%% Get Mode for each rat and region individually
ModeVals=zeros(size(myDataRaw));
currentData=mydataHistSmooth;
banana=0
for i=1:1:a
    i
    for j=1:1:b
        
        for k=1:1:c
            clearvars temp X
            temp=cell2mat(currentData(i,j,k));
            if isempty(temp)
                banana=1+banana
            else
                X(:,1)=temp(:,2);
                X(:,2)=temp(:,1);
                
                [M,I]=max(X(:,2));
                signal=X;
                center=X(I,1);
                window=0.1;
                NumPeaks=1;
                peakshape=0;
                extra=0;
                NumTrials=5;
                
                [~,GOF,~,~,~,xi,yi]=peakfit(signal,center,window,NumPeaks,peakshape,extra,NumTrials);
                peak=0;
                
                [M,I]=max(yi);
                ModeVals(i,j,k)=xi(I);
            end
            
        end
    end
end


%% Get mode for grouped
close all
ModeOfData=[];
currentData=mydataHistSmoothSmushed;
banana=0
for i=1:1:a
    for k=1:1:c
        clearvars temp X
        temp=cell2mat(currentData(i,k));
        if isempty(temp)
            banana=1+banana
        else
%             figure
            X(:,1)=temp(:,2);
            X(:,2)=temp(:,1);
            plot(X)
%         figure
            [M,I]=max(X(:,2));
            signal=X;
            center=X(I,1);
            window=0.1;
            NumPeaks=1;
            peakshape=0;
            extra=0;
            NumTrials=5;
            
            [~,GOF,~,~,~,xi,yi]=peakfit(signal,center,window,NumPeaks,peakshape,extra,NumTrials);
            peak=0;
            
            
            [M,I]=max(yi);
            ModeOfData(i,k)=xi(I);
        end
        
    end
end

%% Get mean and std for Modes
clear
clc
close all
load('ModeVals59_all.mat')

[a,b,c]=size(ModeVals);
outputmatrix=zeros(a,c,2);
for i=1:1:a
    for j=1:1:c
        
        outputmatrix(i,j,1)=mean(ModeVals(i,:,j));
        outputmatrix(i,j,2)=std(ModeVals(i,:,j));
        
    end
end
output_anes=outputmatrix(3,:,:);
output_anes=squeeze(output_anes);
% output_anes(:,3)=output_anes(:,2)./output_anes(:,1).*100;


%% Fix matrix
[a,b]=size(matrix);
myMatrix=[];
banana=matrix(1,:);
skip=0;
for i=2:1:a
    if isempty(banana)
        banana=matrix(i,:);
        skip=1;
    end
    
    if skip==0
        if cell2mat(matrix(i,1))==cell2mat(matrix(i-1,1))
            
            banana(1,2)=strcat(banana(1,2),', ',matrix(i,2));
                       
        else
            myMatrix=[myMatrix; banana];
            banana=[];
        end
    end
    skip=0;
end




%% Plot normalized histograms
close all

for i=1:1:174
    
    temp=cell2mat(mydataHistSmoothSmushed(1,i));
    X_vals=temp(:,1);
    Y_vals=temp(:,2);
    figure
    plot(Y_vals,X_vals,'*')
end
%%
clearvars Y
    load ModeVals59;
    [a,b]=size(ModeOfData);
    Y=((ModeOfData(2,1:b)-ModeOfData(3,1:b))./ModeOfData(3,1:b))'*100;
%     Y=ModeOfData(3,1:b)';
    
    %%
%     Y=ModeOfData(4,1:b)'*100;
    %%./(ModeOfData(3,1:174))'.*100;
    maximality=30;
    Y(Y>maximality)=maximality;
    Y(Y<-maximality)=-maximality;

% Run this once Y is filled. It will bring up the 3D slider window to view
% the means per region in the Atlas

 ATLAS=load_nii('map_Rat_Atlas59.nii');
 Z=double(ATLAS.img);
 for i=1:1:b
%  Z(Z==i)=M_STAT(i,6)*(M_STAT(i,1)-M_STAT(i,3));
Z(Z==i)=(Y(i,1));
 end
 ATLAS.img=Z;
 view_nii(ATLAS)


%%

