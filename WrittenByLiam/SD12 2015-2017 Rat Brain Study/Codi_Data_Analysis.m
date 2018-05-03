% Initialize Object
% CODI: 'I:\Google Drive\Ju Codi Share New
% JU: 'I:\Google Drive\Ju Codi Share New
% LIAM: 'E:\Documents\Liam Timms Codi Share
clearvars -except banana
clc
% close all

% % % Initiate by designating which animals will be used by number
% FolderPrefix='PC3';
% AnPrefix='PC3';
% AnPrefix2='PC3';
FK.currentAn=[1 2 3 4 5 6 7 8 9 10 11 12];
FK.ScanNums=[1 2 3 4 5;1 2 3 4 5;1 2 3 4 5;1 2 3 4 5;1 2 3 4 5;1 2 3 4 5; 3 4 5 6 7; 1 2 3 4 5; 1 2 3 4 5; 1 2 3 4 5; 1 2 3 4 5; 2 3 4 5 6];
FK.NumScans=[5 5 5 5 5 5 5 5 5 5 5 5];

myData.NumofAn = length(FK.currentAn); % Number of animals used total

myData.ScanNums=zeros(myData.NumofAn,5);
for i=1:1:myData.NumofAn
    anNum=FK.currentAn(i);
    myData.ScanNums(i,:) = FK.ScanNums(anNum,:); % File name scan number for all animal scans
    myData.NumScans(i) = FK.NumScans(anNum); % Number of scans per animal
end

myData.AnNums=FK.currentAn;

myData.CorMagNames = cell(myData.NumofAn, max(myData.NumScans));


for i=1:1:myData.NumofAn
    An_Num=sprintf('%d', myData.AnNums(i));
    
    for j=1:1:(myData.NumScans(i))
        ScanNum=sprintf('%d', myData.ScanNums(i,j));
        
        % Corrected MAGNITUDE Images
        myData.CorMagNames(i,j)=...
            cellstr(strcat('I:\Google Drive\Liam Timms Codi Share\SD12 Brain Study\SD12_COMPLEX_Analysis\SD12_RAT_EXTRACTED_CORRECTED_CROPPED_ALIGNED_ABS\rSD12_',An_Num,'_UTE3D_UTEscan',ScanNum,'_MAGNITUDE_IMAGE_CORRECTED_CROPPED_METH2.nii'));
        
        % Corrected REAL Images
        myData.CorRealNames(i,j)=...
            cellstr(strcat('I:\Google Drive\Liam Timms Codi Share\SD12 Brain Study\SD12_COMPLEX_Analysis\SD12_RAT_EXTRACTED_CORRECTED_CROPPED_ALIGNED_ABS\rSD12_',An_Num,'_UTE3D_UTEscan',ScanNum,'_REAL_IMAGE__CORRECTED_CROPPED.nii'));
        
        % Corrected IMAGINARY Images
        myData.CorImagNames(i,j)=...
            cellstr(strcat('I:\Google Drive\Liam Timms Codi Share\SD12 Brain Study\SD12_COMPLEX_Analysis\SD12_RAT_EXTRACTED_CORRECTED_CROPPED_ALIGNED_ABS\rSD12_',An_Num,'_UTE3D_UTEscan',ScanNum,'_IMAGINARY_IMAGE__CORRECTED_CROPPED.nii'));
        
        % Atlases
        myData.Atlas174Names(i,j)=...
            cellstr(strcat('I:\Google Drive\Liam Timms Codi Share\SD12 Brain Study\SD12_COMPLEX_Analysis\Atlas_Map_Files\map_rSD12_',An_Num,'_UTE3D_UTEscan',sprintf('%d',max(FK.ScanNums(str2double(An_Num),:))),'_MAGNITUDE_IMAGE_174_REGION.nii'));
        myData.Atlas106Names(i,j)=...
            cellstr(strcat('I:\Google Drive\Liam Timms Codi Share\SD12 Brain Study\SD12_COMPLEX_Analysis\Atlas_Map_Files\map_rSD12_',An_Num,'_UTE3D_UTEscan',sprintf('%d',max(FK.ScanNums(str2double(An_Num),:))),'_MAGNITUDE_IMAGE_106_REGION.nii'));
        myData.Atlas59Names(i,j)=...
            cellstr(strcat('I:\Google Drive\Liam Timms Codi Share\SD12 Brain Study\SD12_COMPLEX_Analysis\Atlas_Map_Files\map_rSD12_',An_Num,'_UTE3D_UTEscan',sprintf('%d',max(FK.ScanNums(str2double(An_Num),:))),'_MAGNITUDE_IMAGE_59_REGION.nii'));
        
        % CBV Calculated Images
        myData.CBVNames(i,j)=...
            cellstr(strcat('I:\Google Drive\Liam Timms Codi Share\SD12 Brain Study\SD12_COMPLEX_Analysis\SD12_RAT_CBV\rSD12_',An_Num,'_UTE3D_CBV_from_UTEscan',ScanNum,'_MAGNITUDE_IMAGE_CORRECTED_CROPPED_METH2.nii'));
        % CBV Calculated Images (Time-corrected)
        myData.tcCBVNames(i,j)=...
            cellstr(strcat('I:\Google Drive\Liam Timms Codi Share\SD12 Brain Study\SD12_COMPLEX_Analysis\SD12_RAT_CBV_REDO\rSD12_',An_Num,'_UTE3D_CBV_from_UTEscan',ScanNum,'_MAGNITUDE_IMAGE_CORRECTED_CROPPED_METH2.nii'));
        
         % CBV APOE Images
        myData.CBVAPOENames(i,j)=...
            cellstr(strcat('I:\Google Drive\Liam Timms Codi Share\SD12 Brain Study\SD12_COMPLEX_Analysis\SD12_RAT_CBV\rSD12_',An_Num,'_UTE3D_CBV_from_UTEscan',ScanNum,'_MAGNITUDE_IMAGE_CORRECTED_CROPPED_METH2.nii'));
        
    end
    
end


%% Generate Atlas Data For Anesthetized Using CBV Images
% (MxNxP) M=animal, N=region, P=Specific Analysis

pathAPOEcbv='I:\Google Drive\Liam Timms Codi Share\SD12 Brain Study\APOE_COMPLEX_Analysis\APOE_RAT_CBV\';
pathAPOEatlas='I:\Google Drive\Liam Timms Codi Share\SD12 Brain Study\APOE_COMPLEX_Analysis\APOE_Atlas_Map_Files\';

OutMatrix=zeros(1);
for i=1:1:27
    i
    QuantVal=0.25+0.025*(i-1);
    for j=1:1:23
        if j~=13
            AnNum=sprintf('%d',j);
            CBVData= special_load_nii(strcat(pathAPOEcbv,'APOE',AnNum,'_UTE3D_CBV_from_UTEscan2_MAGNITUDE_IMAGE_CORRECTED_CROPPED_METH2.nii'));
            AtlasData=special_load_nii(strcat(pathAPOEatlas,'APOE',AnNum,'_59_Atlas.nii'));
            
            TempAtlas=AtlasData.img;
            TempCBV=CBVData.img;
            
            TempAtlas(TempAtlas>0)=1;
            TempCBV=nonzeros(TempCBV.*TempAtlas);
            
            OutMatrix(j,i)=quantile(TempCBV,QuantVal);
            
        end
    end
    
end
save('Whole_brain_APOEdata.mat','OutMatrix')



for z=2:1:5
    z
    OutMatrix=zeros(1);
    for i=1:1:27
        i
        QuantVal=0.25+0.025*(i-1);
        for j=1:1:myData.NumofAn
            CBVData= special_load_nii(myData.tcCBVNames(j,z));
            AtlasData=special_load_nii(myData.Atlas59Names(j,z));
            NumRegions = max(max(max(AtlasData.img)));
            
            for k=1:1:NumRegions
                
                TempAtlas=AtlasData.img;
                TempCBV=CBVData.img;
                
                TempAtlas(TempAtlas~=k)=0;
                TempAtlas(TempAtlas>0)=1;
                TempCBV=nonzeros(TempCBV.*TempAtlas);
                
                OutMatrix(j,k,i)=quantile(TempCBV,QuantVal);
                
            end
            
        end
        
    end
    save(char(strcat('59reg_TimeCalc_Scan',sprintf('%d',z),'.mat')),'OutMatrix')
end

for z=2:1:5
    z
    OutMatrix=zeros(1);
    for i=1:1:27
        i
        QuantVal=0.25+0.025*(i-1);
        for j=1:1:myData.NumofAn
            CBVData= special_load_nii(myData.tcCBVNames(j,z));
            AtlasData=special_load_nii(myData.Atlas106Names(j,z));
            NumRegions = max(max(max(AtlasData.img)));
            
            for k=1:1:NumRegions
                
                TempAtlas=AtlasData.img;
                TempCBV=CBVData.img;
                
                TempAtlas(TempAtlas~=k)=0;
                TempAtlas(TempAtlas>0)=1;
                TempCBV=nonzeros(TempCBV.*TempAtlas);
                
                OutMatrix(j,k,i)=quantile(TempCBV,QuantVal);
                
            end
            
        end
        
    end
    save(char(strcat('106reg_TimeCalc_Scan',sprintf('%d',z),'.mat')),'OutMatrix')
end

for z=2:1:5
    z
    OutMatrix=zeros(1);
    for i=1:1:27
        i
        QuantVal=0.25+0.025*(i-1);
        for j=1:1:myData.NumofAn
            CBVData= special_load_nii(myData.tcCBVNames(j,z));
            AtlasData=special_load_nii(myData.Atlas174Names(j,z));
            NumRegions = max(max(max(AtlasData.img)));
            
            for k=1:1:NumRegions
                
                TempAtlas=AtlasData.img;
                TempCBV=CBVData.img;
                
                TempAtlas(TempAtlas~=k)=0;
                TempAtlas(TempAtlas>0)=1;
                TempCBV=nonzeros(TempCBV.*TempAtlas);
                
                OutMatrix(j,k,i)=quantile(TempCBV,QuantVal);
                
            end
            
        end
        
    end
    save(char(strcat('174reg_TimeCalc_Scan',sprintf('%d',z),'.mat')),'OutMatrix')
end

for z=2:1:5
    z
    OutMatrix=zeros(1);
    for i=1:1:27
        i
        QuantVal=0.25+0.025*(i-1);
        for j=1:1:myData.NumofAn
            CBVData= special_load_nii(myData.CBVNames(j,z));
            AtlasData=special_load_nii(myData.Atlas174Names(j,z));
            NumRegions = max(max(max(AtlasData.img)));
            
            for k=1:1:NumRegions
                
                TempAtlas=AtlasData.img;
                TempCBV=CBVData.img;
                
                TempAtlas(TempAtlas~=k)=0;
                TempAtlas(TempAtlas>0)=1;
                TempCBV=nonzeros(TempCBV.*TempAtlas);
                
                OutMatrix(j,k,i)=quantile(TempCBV,QuantVal);
                
            end
            
        end
        
    end
    save(char(strcat('174reg_Measured_Scan',sprintf('%d',z),'.mat')),'OutMatrix')
end

for z=2:1:5
    z
    OutMatrix=zeros(1);
    for i=1:1:27
        i
        QuantVal=0.25+0.025*(i-1);
        for j=1:1:myData.NumofAn
            CBVData= special_load_nii(myData.CBVNames(j,z));
            AtlasData=special_load_nii(myData.Atlas106Names(j,z));
            NumRegions = max(max(max(AtlasData.img)));
            
            for k=1:1:NumRegions
                
                TempAtlas=AtlasData.img;
                TempCBV=CBVData.img;
                
                TempAtlas(TempAtlas~=k)=0;
                TempAtlas(TempAtlas>0)=1;
                TempCBV=nonzeros(TempCBV.*TempAtlas);
                
                OutMatrix(j,k,i)=quantile(TempCBV,QuantVal);
                
            end
            
        end
        
    end
    save(char(strcat('106reg_Measured_Scan',sprintf('%d',z),'.mat')),'OutMatrix')
end

%% Generate Atlas Data For Anesthetized Using CBV Images whole brain
% (MxNxP) M=animal, N=region, P=Specific Analysis

for z=2:1:5
    z
    OutMatrix=zeros(1);
    for i=1:1:27
        i
        QuantVal=0.25+0.025*(i-1);
        for j=1:1:myData.NumofAn
            CBVData= special_load_nii(myData.CBVNames(j,z));
            AtlasData=special_load_nii(myData.Atlas59Names(j,z));                                  
            
            TempAtlas=AtlasData.img;
            TempCBV=CBVData.img;            
            
            TempAtlas(TempAtlas>0)=1;
            TempCBV=nonzeros(TempCBV.*TempAtlas);
            
            OutMatrix(j,i)=quantile(TempCBV,QuantVal);
                        
            
        end
        
    end
    save(char(strcat('Whole_brain_Scan',sprintf('%d',z),'.mat')),'OutMatrix')
end

%%
load('Whole_brain_Scan5.mat');Out5=OutMatrix;
load('Whole_brain_Scan4.mat');Out4=OutMatrix;
load('Whole_brain_Scan3.mat');Out3=OutMatrix;
load('Whole_brain_Scan2.mat');Out2=OutMatrix;

diff1=(Out2-Out3)./Out2.*100;diff1=mean(diff1);
diff2=(Out3-Out4)./Out3.*100;diff2=mean(diff2);
diff3=(Out4-Out5)./Out4.*100;diff3=mean(diff3);

hold on
plot(diff1,'r*')
plot(diff2,'b*')
plot(diff3,'g*')
hold off
%% 
close all
load('Scan5.mat');Out5=OutMatrix;
load('Scan4.mat');Out4=OutMatrix;
load('Scan3.mat');Out3=OutMatrix;
load('Scan2.mat');Out2=OutMatrix;

CBV5=mean(Out5);CBV5=squeeze(CBV5);
CBV4=mean(Out4);CBV4=squeeze(CBV4);
CBV3=mean(Out3);CBV3=squeeze(CBV3);
CBV2=mean(Out2);CBV2=squeeze(CBV2);

for i=1:1:59
figure  
plot(CBV5(i,:),'*')
end
%%
close all
clear
clc
load('59reg_TimeCalc_Scan2.mat');Out2=OutMatrix;
load('59reg_TimeCalc_Scan3.mat');Out3=OutMatrix;
load('59reg_TimeCalc_Scan4.mat');Out4=OutMatrix;
load('59reg_TimeCalc_Scan5.mat');Out5=OutMatrix;

diff1=(Out2-Out4)./Out4.*100;diff1=mean(diff1);
diff2=(Out3-Out4)./Out4.*100;diff2=mean(diff2);
diff3=(Out5-Out4)./Out4.*100;diff3=mean(diff3);

std1=diff1.*sqrt((std(Out2,1).^2+std(Out4,1).^2)./(mean(Out2,1)-mean(Out4,1)).^2+(std(Out4,1)./mean(Out4,1)).^2);           
std2=diff2.*sqrt((std(Out3,1).^2+std(Out4,1).^2)./(mean(Out3,1)-mean(Out4,1)).^2+(std(Out4,1)./mean(Out4,1)).^2);   
std3=diff3.*sqrt((std(Out5,1).^2+std(Out5,1).^2)./(mean(Out2,1)-mean(Out4,1)).^2+(std(Out4,1)./mean(Out4,1)).^2);   

diff1=squeeze(diff1);std1=squeeze(std1);
diff2=squeeze(diff2);std2=squeeze(std2);
diff3=squeeze(diff3);std3=squeeze(std3);

currentDiff1=diff1(:,10);
currentDiff2=diff2(:,10);
currentDiff3=diff3(:,10);
currentStd1=std1(:,10);
currentStd2=std2(:,10);
currentStd3=std3(:,10);

Current_OutMatrix=[currentDiff1 currentStd1 currentDiff2 currentStd2 currentDiff3 currentStd3];

%%
close all
clear
clc
load('59reg_TimeCalc_Scan2.mat');Out2=OutMatrix;
load('59reg_TimeCalc_Scan3.mat');Out3=OutMatrix;
load('59reg_TimeCalc_Scan4.mat');Out4=OutMatrix;
load('59reg_TimeCalc_Scan5.mat');Out5=OutMatrix;

diff1=(Out2-Out4);std1=std(diff1,1);mean1=mean(diff1);
diff2=(Out3-Out4);std2=std(diff2,1);mean2=mean(diff2);
diff3=(Out5-Out4);std3=std(diff3,1);mean3=mean(diff3);

mean1=squeeze(mean1);std1=squeeze(std1);
mean2=squeeze(mean2);std2=squeeze(std2);
mean3=squeeze(mean3);std3=squeeze(std3);

currentmean1=mean1(:,10);
currentmean2=mean2(:,10);
currentmean3=mean3(:,10);
currentStd1=std1(:,10);
currentStd2=std2(:,10);
currentStd3=std3(:,10);

Current_OutMatrix=[currentmean1 currentStd1 currentmean2 currentStd2 currentmean3 currentStd3].*100;

%%
currentDiff1=diff1(:,10);
currentDiff2=diff2(:,10);
currentDiff3=diff3(:,10);
currentStd1=std1(:,10);
currentStd2=std2(:,10);
currentStd3=std3(:,10);

Current_OutMatrix=[currentDiff1 currentStd1 currentDiff2 currentStd2 currentDiff3 currentStd3];

%%
close all
clear
clc
load('59reg_TimeCalc_Scan2.mat');Out2=OutMatrix;
load('59reg_TimeCalc_Scan3.mat');Out3=OutMatrix;
load('59reg_TimeCalc_Scan4.mat');Out4=OutMatrix;
load('59reg_TimeCalc_Scan5.mat');Out5=OutMatrix;

diff1=(Out2-Out4)./Out4;mean1=squeeze(mean(diff1,1));std1=squeeze(std(diff1,1));
diff2=(Out3-Out4)./Out4;mean2=squeeze(mean(diff2,1));std2=squeeze(std(diff2,1));
diff3=(Out5-Out4)./Out4;mean3=squeeze(mean(diff3,1));std3=squeeze(std(diff3,1));
quartile=10;

Current_OutMatrix=[mean1(:,10) std1(:,10) mean2(:,10) std2(:,10) mean3(:,10) std3(:,10)];
animalnums=[1 2 3 4 5 6 7 8 9 10 11 12];
[temp,a]=size(animalnums);
% for i=1:1:59
i=5
    figure
    hold on
    for j=1:1:a
        j
        plot(squeeze(diff1(animalnums(j),i,:)),'b*')
        plot(squeeze(diff2(animalnums(j),i,:)),'r*')
        plot(squeeze(diff3(animalnums(j),i,:)),'g*')
    end
% end

%%

M=special_load_nii(myData.Atlas59Names(1,1));


%%% for i=1:1:59
%    [a(i) temp]=size(M.img(M.img==i)); 
% end


for i=1:1:59
figure  
plot(diff1(zz(i,2),:),'*')
end
%% Generate Atlas Data For APOE
% (MxNxP) M=animal, N=region, P=Specific Analysis
clear
clc
pathAPOEcbv='E:\Documents\Liam Timms Codi Share\APOEpos Analysis\APOE_RAT_CBV\';
pathAPOEatlas='E:\Documents\Liam Timms Codi Share\APOEpos Analysis\APOE_Atlas_Map_Files\';

OutMatrix=zeros(1);
for i=1:1:27
    i
    QuantVal=0.25+0.025*(i-1);
    for j=1:1:23
        if j~=13
            AnNum=sprintf('%d',j);
            CBVData= special_load_nii(strcat(pathAPOEcbv,'APOE',AnNum,'_UTE3D_CBV_from_UTEscan2_MAGNITUDE_IMAGE_CORRECTED_CROPPED_METH2.nii'));
            AtlasData=special_load_nii(strcat(pathAPOEatlas,'APOE',AnNum,'_59_Atlas.nii'));
            NumRegions = max(max(max(AtlasData.img)));
            
            for k=1:1:NumRegions
                
                TempAtlas=AtlasData.img;
                TempCBV=CBVData.img;
                
                TempAtlas(TempAtlas~=k)=0;
                TempAtlas(TempAtlas>0)=1;
                TempCBV=nonzeros(TempCBV.*TempAtlas);
                
                OutMatrix(j,k,i)=quantile(TempCBV,QuantVal);
                
            end
        end
    end
    
end
save(char(strcat('APOE_data.mat')),'OutMatrix')

%%

m=mean(OutMatrix,1);
s=std(OutMatrix,1);
coefvar=s./m;
size(coefvar)

%%

cat=Out3-Out5;
cat=mean(cat);
plot(cat,'*')
%%
for i=1:1:59
    figure
banana=coefvar(1,42,:);
plot(squeeze(banana),'*')
end

%%
figure
hold on
plot(banana1,'*')
