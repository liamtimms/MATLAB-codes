% % % % % % % %   SD12 Data Processing  % % % % % % % % 
% % % % % %  Codi Gharagouzloo 01-15-16 % % % % % % % %
% % % % % % % % % % % % % % % % % % % % % % % % % % % %

%% PART 1: GET capillary density per region following peak not mean of CBV

% Initialize Matrix for recording data. X has 174 rows for collecting the
% CBV value right now and 12 columns, one for each rat. You will want to
% extend this to at least a (174,4-7,12) for collecting data from the 4-7
% post-contrast UTE scans per animal. Right now it's just setup for the
% first postcontrast scan
Cp=zeros(174,5,12);
CBV=zeros(174,5,12);


% Data processing repeated for 'k' different animals
for k=1:1:12
       
	an_Num=sprintf('%d', k); % Prepare Animal Number (1-12)
       
	% Input Blood Intensity Values for CBV Measurement
	csvFile=strcat('Ib_vals_',an_Num,'.csv');
	Ib=csvread(csvFile);
               
	fileTypeNII='.nii';       
    loadname1=strcat('rSD12_',an_Num,'_Rat_UTE1_scaled_corrected',fileTypeNII);M1 = load_nii(loadname1);
    loadname2=strcat('rSD12_',an_Num,'_Rat_UTE2_scaled_corrected',fileTypeNII);M2 = load_nii(loadname2);
    loadname3=strcat('rSD12_',an_Num,'_Rat_UTE3_scaled_corrected',fileTypeNII);M3 = load_nii(loadname3);
    loadname4=strcat('rSD12_',an_Num,'_Rat_UTE4_scaled_corrected',fileTypeNII);M4 = load_nii(loadname4);
    loadname5=strcat('rSD12_',an_Num,'_Rat_UTE5_scaled_corrected',fileTypeNII);M5 = load_nii(loadname5);
       
    loadnameMap=strcat('rSD12_',an_Num,'_Rat_ATLAS',fileTypeNII);N1 = load_nii(loadnameMap);
       
    savename1=strcat('rSD12_',an_Num,'_Cp','.csv'); % For Excel OUtput File
    savename2=strcat('rSD12_',an_Num,'_CBV','.csv'); % For Excel OUtput File

        % Scan through ATLAS 174 regions per animal
        for i = 1:1:174

        % Make mask of intensity=1 at ROI to select one region
        Z_Mask = double(N1.img);
        Z_Mask(Z_Mask<i) = 0;
        Z_Mask(Z_Mask>i) = 0;
        Z_Mask(Z_Mask==i) = 1;
    
        Z1 =double(M1.img);
        Z2=double(M2.img);
        Z3=double(M3.img);
        Z4=double(M4.img);
        Z5=double(M5.img);
    
        [I1_peak,I1_avg]=get_Ipeak_Iavg(Z1,Z_Mask);
        [I2_peak,I2_avg]=get_Ipeak_Iavg(Z2,Z_Mask);
        [I3_peak,I3_avg]=get_Ipeak_Iavg(Z3,Z_Mask);
        [I4_peak,I4_avg]=get_Ipeak_Iavg(Z4,Z_Mask);
        [I5_peak,I5_avg]=get_Ipeak_Iavg(Z5,Z_Mask);
    

        % FORMULA: CBV = (I2-I1) / (I_doped_blood - I_blood_precontrast)
        I_precon=I1_peak;
        Cp(i,1) = (I2_peak-I_precon)/(Ib(1,1)-Ib(1,2))*100;
        Cp(i,2) = (I3_peak-I_precon)/(Ib(2,1)-Ib(2,2))*100;
        Cp(i,3) = (I4_peak-I_precon)/(Ib(3,1)-Ib(3,2))*100;
        Cp(i,4) = (I5_peak-I_precon)/(Ib(4,1)-Ib(4,2))*100;

        I_precon=I1_avg;
        CBV(i,1) = (I2_avg-I_precon)/(Ib(1,1)-Ib(1,2))*100;
        CBV(i,2) = (I3_avg-I_precon)/(Ib(2,1)-Ib(2,2))*100;
        CBV(i,3) = (I4_avg-I_precon)/(Ib(3,1)-Ib(3,2))*100;
        CBV(i,4) = (I5_avg-I_precon)/(Ib(4,1)-Ib(4,2))*100;
       
        % Set NaN values to 0. NaN happens when peak is not found (i.e. small
        % region)
        idx = find(isnan(Cp));
        if(~isempty(idx))
        Cp(idx) = 0;
        end    

        idx = find(isnan(CBV));
        if(~isempty(idx))
        CBV(idx) = 0;
        end    

        % Write Excel File with Data
        csvwrite(savename1,Cp); 
        csvwrite(savename2,CBV); 

        end

end






%% Part 2: Analyze Data Statistically
% Collect and do Simple Statistics on all UTE Data. I was using this when I
% had one Excel file/animal. You will have to adapt it and do whatever
% statistics you want. M1-M4 were different groups, for example in this
% case it would be Awake1, CO2, Awake2, Anesthetized

clc
clear

Study='_Cp';

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
         [h1,p1]=ttest2(x1,y1);
         [h2,p2]=ttest2(x2,y2);
         [h3,p3]=ttest2(x3,y3);
         [h4,p4]=ttest2(x4,y4);
         [h5,p5]=ttest2(x5,y5);
         [h6,p46]=ttest2(x6,y6);
         
         
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
         M_STAT(j,19)=h3;
         M_STAT(j,20)=h4; 
         
     
	end
 idx = find(isnan(M_STAT));
if(~isempty(idx))
    M_STAT(idx) = 0;
end
 csvwrite(strcat('Statistics_SD12',Study,'.csv'),M_STAT)
 
 
 
 
 
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
 
 %%
 Ib=csvread('IBvaluesAtMid.csv');
 
 for i=1:1:5
       
       an_Num=sprintf('%d', i); % nice trick combined with strcat command
       fileTypeNII='.nii';
       for j=2:1:5
           scn_Num=sprintf('%d', j);
           loadname=strcat('rSD12_',an_Num,'_Rat_UTE', scn_Num,'_scaled_corrected',fileTypeNII);RawData = load_nii(loadname);
           loadnameMap=strcat('rSD12_',an_Num,'_Rat_UTE', '2','_scaled_corrected-label',fileTypeNII); RawROI = load_nii(loadnameMap);
           image=double(RawData.img);
           mask=double(RawROI.img);
           maskworking=mask;
           size(nonzeros(maskworking))
           
           
           loadnameMap=strcat('rSD12_',an_Num,'_Rat_UTE', '3','_scaled_corrected-label',fileTypeNII); RawROI = load_nii(loadnameMap);
           mask=double(RawROI.img);
           maskworking=maskworking.*mask;
           size(nonzeros(maskworking))
           
           loadnameMap=strcat('rSD12_',an_Num,'_Rat_UTE', '4','_scaled_corrected-label',fileTypeNII); RawROI = load_nii(loadnameMap);
           mask=double(RawROI.img);
           maskworking=maskworking.*mask;
           size(nonzeros(maskworking))
           
           loadnameMap=strcat('rSD12_',an_Num,'_Rat_UTE', '5','_scaled_corrected-label',fileTypeNII); RawROI = load_nii(loadnameMap);
           mask=double(RawROI.img);
           maskworking=maskworking.*mask;
           size(nonzeros(maskworking))
           
%            RawROI.img=

           
           [I_peak, I_avg, I_std] = get_Ipeak_Iavg(image, maskworking);
           IBvalues(j,1,i)=I_avg;
           IBvalues(j,2,i)=I_std;
       end

 end
 
%  savename=
%  csvwrite(savename,IBvalues); 

%% Get_IB Values Per Image with Common Mask
clc
clear
close all

%%

%start=2;
 
 for i=1:1:12
     
     if i==7
         finish=7;
     elseif i==12
         finish=6;
     else
         finish=5;
     end
       
       an_Num=sprintf('%d', i); % nice trick combined with strcat command
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
 
%  savename=
%  csvwrite(savename,IBvalues); 

%%

 for i=1:1:12
       
     if i~=7 
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
         
         %store these blood values at the end of IBvalues from  above
         IBvalues(9,1,i)=I_avgWhole;
         IBvalues(9,2,i)=I_stdWhole;
         IBvalues(10,1,i)=I_avgMid;
         IBvalues(10,2,i)=I_stdMid;
     end
             

 end
 


 
