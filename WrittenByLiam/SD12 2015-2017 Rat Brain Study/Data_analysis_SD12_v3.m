% % % % % % % %   SD12 Data Processing  % % % % % % % % 
% % % % % %  Codi Gharagouzloo 01-15-16 % % % % % % % %
% % % % % % % % % % % % % % % % % % % % % % % % % % % %

%% PART 1: Find the blood values
% Here the program will find blood intensity values for both a blood
% phantom and in living rat vivo using previously drawn ROIs


clc
clear
close all

%% P1.I: The Blood Values
% Blood values are found in two different ways; looking at the whole ROI
% and also looking at just the middle slice along Z of the image.

 for i=1:1:12
       
     if i~=7 %Animal 7's phantom was not very useful
         
         an_Num=sprintf('%d', i);
         fileTypeNII='.nii';
         loadname=strcat('SD12_',an_Num,'_blood_UTE_scaled_corrected',fileTypeNII);
         RawData = load_nii(loadname);
         image=double(RawData.img);
         Map=load_nii(strcat('SD12_',an_Num,'_blood_UTE_scaled-label.nii'));
         workingMap=double(Map.img);
         image=image.*workingMap;
         
         data=nonzeros(image);
         I_avgWhole = mean(data);
         I_stdWhole = std(data);
         
         data=nonzeros(image(:,:,100));
         I_avgMid = mean(data);
         I_stdMid = std(data);
         
         %store these blood values at the end of IBvalues which we will
         %fill in with in vivo values as well. 
         IBvalues(9,1,i)=I_avgWhole;
         IBvalues(9,2,i)=I_stdWhole;
         IBvalues(10,1,i)=I_avgMid;
         IBvalues(10,2,i)=I_stdMid;
         
     end
             

 end
 
 %% P1.II: The in Living Vivo Values
 % In vivo values are determined based off of an ROI which is common to all
 % of the scans 
 
 for i=1:1:12
     
     %Hard coded exceptions based on our data situation
     if i==7
         finish=7;
     elseif i==12
         finish=6;
     else
         finish=5;
     end
     
     % the actual bulk of the work begins here
     
       an_Num=sprintf('%d', i); 
       fileTypeNII='.nii';
       
       Map=load_nii(strcat('rSD12_',an_Num,'_Rat_UTE2_scaled_corrected-label.nii'));
       workingMap=double(Map.img);
       for j=3:1:finish
       scanNum=sprintf('%d',j);
       loadnameMap=strcat('rSD12_',an_Num,'_Rat_UTE',scanNum,'_scaled_corrected-label.nii');
       Map=load_nii(loadnameMap);
       Map=double(Map.img);
       workingMap=Map.*workingMap;
       end
             
       size(nonzeros(workingMap))
       
       for j=1:1:finish
           scn_Num=sprintf('%d', j);
           loadname=strcat('rSD12_',an_Num,'_Rat_UTE', scn_Num,'_scaled_corrected',fileTypeNII);
           RawData = load_nii(loadname);
           image=double(RawData.img);
           image=image.*workingMap;
           data=nonzeros(image);
           
           I_avg = mean(data);I_std= std(data);
           IBvalues(j,1,i)=I_avg; 
           IBvalues(j,2,i)=I_std;
       end
       
       
 end
 
%  csvwrite(savename,IBvalues); 

%% PART 2: Find the Cp and CBV values on a region by region basis
% This code assumes that you have already lined up the Rat Brain Atlas for
% each scan and assumes that you are using the one created here at NEU


%% Part 2.I: Create the Object for Data storage during processing
% Initialize myData Object for recording data. Size is set by the number of
% animals. PostScan matrix corresponds to the number of post contrast scans
% for each individual animal. LoadNames contains cells of character arrays
% that correspond to files which follow specific naming conventions. 
clear
clc
close all

myData.NumofAn = 12;
myData.PostScans = [4 4 4 4 4 4 6 4 4 4 4 5];
myData.loadNames = cell(myData.NumofAn, max(myData.PostScans));   

    for i=1:1:myData.NumofAn
        an_Num=sprintf('%d', i);
        
            for j=1:1:(myData.PostScans(i)+1)
                UTE_Num=sprintf('%d', j);
                 myData.loadNames(i,j)=cellstr(strcat('rSD12_',an_Num,'_Rat_UTE',UTE_Num,'_scaled_corrected.nii'));
            end
            
    end
    
%% P2.II: Machinery to calculate and store the Cp and CBV values
% This code cycles through each animal, each animal's post contrast scans,
% and each of the 174 regions capilary density and cerebral blood volume
% values. 

for k=1:1:myData.NumofAn
       
	an_Num=sprintf('%d', k); % Prepare Animal Number (1-12)
	
    % Input Blood Intensity Values for CBV Measurement
	csvFile = strcat('Ib_vals_',an_Num,'.csv');
	Ib = csvread(csvFile);
    
    loadname= char(myData.loadNames(k,1));
    PreCon = load_nii(loadname);
    loadnameMap = strcat('rSD12_',an_Num,'_Rat_ATLAS.nii'); 
    AlignedAtlas = load_nii(loadnameMap);
    
        for j=1:1:myData.PostScans(k)
            clear loadname PostCon Mask PreConImg PostConImg 
            clear I1_peak I1_avg I2_peak I2_avg I_precon I_postcon

            loadname= char(myData.loadNames(k,j+1));
            PostCon = load_nii(loadname);
                 
       
                % Scan through ATLAS 174 regions per animal
                for i = 1:1:174

                % Make mask of intensity=1 at ROI to select one region
                Mask = double(AlignedAtlas.img);
                Mask(Mask~=i) = 0;
                Mask(Mask==i) = 1;
    
                PreConImg = double(PreCon.img);
                PostConImg= double(PostCon.img);
    
                [I1_peak,I1_avg,I1_std] = get_Ipeak_Iavg(PreConImg, Mask);
                [I2_peak,I2_avg,I2_std] = get_Ipeak_Iavg(PostConImg,Mask);

                % FORMULA: CBV = (I2-I1) / (I_doped_blood - I_blood_precontrast)
                I_precon = I1_peak; %we use the peak values to find capilary density
                I_postcon= I2_peak;
                Cp(i) = (I_postcon-I_precon)/(Ib(j,1)-Ib(j,2))*100;
                if isnan(Cp(i))
                    fprintf('Scan %d of animal %d, region %d Cp value is NaN\n', j, k, i)
                end
                
                I_precon = I1_avg; %we use the average values to find total CBV
                I_postcon= I2_avg;
                CBV(i) = (I_postcon-I_precon)/(Ib(j,1)-Ib(j,2))*100;
                CBV_std(i) = (I2_std)/(Ib(j,1)-Ib(j,2))*100;
                
                if isnan(CBV(i))
                    fprintf('Scan %d of animal %d, region %d CBV value is NaN\n', j, k, i)
                end
                
                end
                
                
           myData.Cp(k,j,:) = Cp(:); % Postcon, animal, all data
           myData.CBV(k,j,:)= CBV(:);
           myData.CBV_std(k,j,:)= CBV_std(:);
           fprintf('Scan %d of animal %d complete\n', j, k)                    
        end
       
       
end


% Set NaN values to 0. NaN happens when peak is not found (i.e. small 
% region)

% myData.Cp(isnan(myData.Cp))=0;
% myData.CBV(isnan(myData.CBV))=0;

%% P2.III: Save the data for later analysis

clear savename
% savename='SD12_myDataObject.mat';
% save(savename, myData); %saves the raw object holding all possible relevant data

for i=1:1:12 % myData.NumofAn
        clear DataCurrent
    an_Num=sprintf('%d', i);   
    savename=strcat('SD12_',an_Num,'_Cp.csv');
    DataCurrent(:,:)=myData.Cp(i,:,:);
    DataCurrent=DataCurrent';
    csvwrite(savename,DataCurrent);
        clear DataCurrent
    DataCurrent(:,:)=myData.CBV(i,:,:);
    savename=strcat('SD12_',an_Num,'_CBV.csv');
    DataCurrent=DataCurrent';
    csvwrite(savename,DataCurrent);        
        clear DataCurrent
    DataCurrent(:,:)=myData.CBV_std(i,:,:);
    savename=strcat('SD12_',an_Num,'_CBV_std.csv');
    DataCurrent=DataCurrent';
    csvwrite(savename,DataCurrent); 
end

%% Part 3: Analyze Data Statistically
% Collect and do Simple Statistics on all UTE Data. DO NOT CLEAR ALL UNLESS
% you have saved the myData object and can reload it!

clearvars('-except', 'myData')
clc
close all

%%
% Collect and do Simple Statistics on all UTE Data. I was using this when I
% had one Excel file/animal. You will have to adapt it and do whatever
% statistics you want. M1-M4 were different groups, for example in this
% case it would be Awake1, CO2, Awake2, Anesthetized

clc
clear
alpha=0.07;
Study='_CBV';

M1=zeros(174,12);M2=zeros(174,12);M3=zeros(174,12);M4=zeros(174,12);

for i=1:1:12
    anNum=sprintf('%d',i);
    CurrentAn=csvread(strcat('SD12_',anNum,Study,'.csv')); % Awake 1
    M1(:,i)=CurrentAn(:,1);
    M2(:,i)=CurrentAn(:,2);
    M3(:,i)=CurrentAn(:,3);
    M4(:,i)=CurrentAn(:,4);
end
 
    M_STAT=zeros(174,20);

	for j=1:1:174
         M_STAT(j,1)= mean(nonzeros(M1(j,:))); % column 1-8 are m,s for grp 1-4
         M_STAT(j,2)= std(nonzeros(M1(j,:))); % 
         M_STAT(j,3)= mean(nonzeros(M2(j,:)));
         M_STAT(j,4)= std(nonzeros(M2(j,:)));     
         M_STAT(j,5)= mean(nonzeros(M3(j,:)));
         M_STAT(j,6)= std(nonzeros(M3(j,:)));        
         M_STAT(j,7)= mean(nonzeros(M4(j,:)));
         M_STAT(j,8)= std(nonzeros(M4(j,:))); 
         
         x1=M1(j,:); y1=M3(j,:); % compare Awake1 vs. Awake2
         x2=M1(j,:); y2=M2(j,:); % compare Awake1 vs. CO2
         x3=M1(j,:); y3=M4(j,:); % compare Awake1 vs. Anesth
         x4=M3(j,:); y4=M2(j,:); % compare Awake2 vs. CO2
         x5=M3(j,:); y5=M4(j,:); % compare Awake2 vs. Anesth
         x6=M2(j,:); y6=M4(j,:); % compare CO2 vs. Anesth
         
         % Perform t-test per region for 4 comparisons
         [h1,p1]=ttest2(x1,y1,'alpha',alpha);
         [h2,p2]=ttest2(x2,y2,'alpha',alpha);
         [h3,p3]=ttest2(x3,y3,'alpha',alpha);
         [h4,p4]=ttest2(x4,y4,'alpha',alpha);
         [h5,p5]=ttest2(x5,y5,'alpha',alpha);
         [h6,p6]=ttest2(x6,y6,'alpha',alpha);
         
         
         M_STAT(j,9)=p1;      %M_STAT columns 9-12 are p-values for comparisons
         M_STAT(j,10)=p2;
         M_STAT(j,11)=p3;
         M_STAT(j,12)=p4;
         M_STAT(j,13)=p5;
         M_STAT(j,14)=p6;
         
         M_STAT(j,15)=h1; %M_STAT columns 9-12 are 1s or 0s for same/ notsame
         M_STAT(j,16)=h2;
         M_STAT(j,17)=h3;
         M_STAT(j,18)=h4;     
         M_STAT(j,19)=h5;
         M_STAT(j,20)=h6; 
         
     
	end
 idx = find(isnan(M_STAT));
if(~isempty(idx))
    M_STAT(idx) = 0;
end
%  csvwrite(strcat('Statistics_SD12',Study,'.csv'),M_STAT)
 
 
%% Part 3: View Analyzed Data in 3D Atlas
%% 
% Initialize a matrix that you will fill with your means for each region
    Y=zeros(174,1);
%%
% Run this once Y is filled. It will bring up the 3D slider window to view
% the means per region in the Atlas

 ATLAS=load_nii('map_Rat_Atlas.nii');
 Z=double(ATLAS.img);
 for i=1:1:174
%  Z(Z==i)=M_STAT(i,6)*(M_STAT(i,1)-M_STAT(i,3));
Z(Z==i)=(Y(i,1));
 end
 ATLAS.img=Z;
 view_nii(ATLAS)
 
%% CREATE REDUCED ATLASES
% Run this once Y is filled. It will bring up the 3D slider window to view
% the means per region in the Atlas

for i=12:1:12
    magscan='6';
    anNum=sprintf('%d',i);
     ATLAS=load_nii(strcat('map_rSD12_',anNum,'_UTE3D_UTEscan',magscan,'_MAGNITUDE_IMAGE.nii'));
     Z=double(ATLAS.img);
         for j=1:1:174
         Z(Z==j)=(Y(j,1));
         end
     ATLAS.img=Z;
     save_nii(ATLAS,strcat('map_rSD12_',anNum,'_UTE3D_UTEscan',magscan,'_MAGNITUDE_IMAGE_59_REGION.nii'))
end











