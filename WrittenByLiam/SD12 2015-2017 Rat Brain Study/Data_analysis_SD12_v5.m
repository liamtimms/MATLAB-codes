% % % % % % % %   SD12 Data Processing  % % % % % % % %
% % % % % %  Codi Gharagouzloo 01-15-16 % % % % % % % %
% % % % % % % % % % % % % % % % % % % % % % % % % % % %

%% PART 1: Find the blood values
% Here the program will find blood intensity values for both a blood
% phantom and in living rat vivo using previously drawn ROIs


clc
clear
close all

% See previous versions and

%% PART 2: Find the Cp and CBV values on a region by region basis
% This code assumes that you have already lined up the Rat Brain Atlas for
% each scan and assumes that you are using the one created here at NEU

modality='UTE3D';
model='rSD12';
TotRegions=59; %either 59, 106 or 174
reg_num=sprintf('%d', TotRegions);
precon_num=sprintf('%d', 1);

for i=1:1:12  
    an_num=sprintf('%d', i);
    folder1='SD12_RAT_EXTRACTED_CORRECTED_CROPPED_ALIGNED_ABS';
    folder2='Atlas_Map_Files';
    Subject=strcat(model, '_', an_num, '_', modality); 
    if i==7
        totscan=7;
    elseif i==12
        totscan=6;
    else
        totscan=5;
    end
    
    scn_num=sprintf('%d', totscan); 
    file=strcat('map_', Subject, '_UTEscan', scn_num, '_MAGNITUDE_IMAGE_', reg_num ,'_REGION');
    loadname=strcat(folder2, '\', file, '.nii');
    ATLASNii=load_nii(loadname);
    ATLASimg=double(ATLASNii.img);
    
    for j=2:1:totscan
        scn_num=sprintf('%d', j);
        
        for k=1:1:3
            clear type
            
            l=0;
            if k==1
                type='REAL';
            elseif k==2
                type='IMAGINARY';
            elseif k==3
                type='MAGNITUDE';
                l=1;
            end
            
            file=strcat(Subject, '_UTEscan', precon_num, '_', type, '_IMAGE_CORRECTED_CROPPED');
            if l==0
                file=strcat(file, '_ABS');
            elseif l==1
                file=strcat(file, '_METH2');
            end
            loadname=strcat(folder1, '\', file, '.nii');
            PreConNii=load_nii(loadname);
            PreConImage=double(PreConNii.img);
            
            file=strcat(Subject, '_UTEscan', scn_num, '_', type, '_IMAGE_CORRECTED_CROPPED');
            if l==0
                file=strcat(file, '_ABS');
            elseif l==1
                file=strcat(file, '_METH2');
            end
            loadname=strcat(folder1, '\', file, '.nii');
            PostConNii=load_nii(loadname);
            PostConImage=double(PostConNii.img);
            
            
            for n=1:1:TotRegions
                ROI=ATLASimg;
                ROI(ROI~=n)=0;
                ROI(ROI~=0)=1;
                
                %[I_peak_pre(i,j,k,n), I_avg_pre(i,j,k,n), I_std_pre(i,j,k,n)] =get_Ipeak_Iavg_v2(PreConImage, ROI);
                %[I_peak_post(i,j,k,n), I_avg_post(i,j,k,n), I_std_post(i,j,k,n)] =get_Ipeak_Iavg_v2(PostConImage, ROI);
                
                [I_peak, I_peak_std, I_avg, I_std] =get_Ipeak_Iavg_v2(PreConImage, ROI);
                I_peak_pre(i,j,k,n)=I_peak;
                I_peak_std_pre(i,j,k,n)=I_peak_std;
                I_avg_pre(i,j,k,n)=I_avg;
                I_std_pre(i,j,k,n)=I_std;
                
                [I_peak, I_peak_std, I_avg, I_std] =get_Ipeak_Iavg_v2(PostConImage, ROI);
                I_peak_post(i,j,k,n)=I_peak;
                I_peak_std_post(i,j,k,n)=I_peak_std;
                I_avg_post(i,j,k,n)=I_avg;
                I_std_post(i,j,k,n)=I_std;
                
                
            end
            
        end
    end
    
    fprintf('Animal %d done /n',i)
end


%%


TotRegions=59; %either 59, 106 or 174

for i=1:1:12
    
    
    if i==7
        totscan=7;
    elseif i==12
        totscan=6;
    else
        totscan=5;
    end
    
    
    for j=2:1:totscan
        
        for n=1:1:TotRegions
            % FORMULA: CBV = (I2-I1) / (I_doped_blood - I_blood_precontrast)
            
            %             Cp(i) = (I_postcon-I_precon)/(Ib(j,1)-Ib(j,2))*100;
            %             if isnan(Cp(i))
            %                 fprintf('Scan %d of animal %d, region %d Cp value is NaN\n', j, k, i)
            %             end
            %
            %             I_precon = I1_avg; %we use the average values to find total CBV
            %             I_postcon= I2_avg;
            %             CBV(i) = (I_postcon-I_precon)/(Ib(j,1)-Ib(j,2))*100;
            %             CBV_std(i) = (I2_std)/(Ib(j,1)-Ib(j,2))*100;
            %
            %             if isnan(CBV(i))
            %                 fprintf('Scan %d of animal %d, region %d CBV value is NaN\n', j, k, i)
            %             end
            
            
            denom=BloodFromPeak(i,j,3)-BloodFromPeak(i,1,3);
            
            num=I_peak_post(i,j,3,n) - I_peak_pre(i,j,3,n);
            Cp(i,j,n) =(num/denom)*100;
            Cp_error(i,j,n)=Cp(i,j,n)*((I_peak_std_post(i,j,3,n)^2 + I_peak_std_pre(i,j,1,n)^2)/num^2 + (BloodFromPeakStd(i,j,3)^2 + BloodFromPeakStd(i,1,3)^2)/denom^2)^2;
            
            
            num=I_avg_post(i,j,3,n) - I_avg_pre(i,j,3,n);
            CBV(i,j,n)=(num/denom)*100;
            CBV_error(i,j,n)=CBV(i,j,n)*((I_std_post(i,j,3,n)^2 + I_std_pre(i,j,1,n)^2)/num^2 + (BloodFromPeakStd(i,j,3)^2 + BloodFromPeakStd(i,1,3)^2)/denom^2)^2;
            
            
        end
        
    end
end


%%

alpha=0.05;

M1=zeros(TotRegions,12);M2=zeros(TotRegions,12);M3=zeros(TotRegions,12);M4=zeros(TotRegions,12);
Study='_CBV';

for i=1:1:12
    anNum=sprintf('%d',i);
    %     CurrentAn=csvread(strcat('SD12_',anNum,Study,'.csv')); % Awake 1
    %     M1(:,i)=CurrentAn(:,1);
    %     M2(:,i)=CurrentAn(:,2);
    %     M3(:,i)=CurrentAn(:,3);
    %     M4(:,i)=CurrentAn(:,4);
    
    if i==7
        M1(:,i)=CBV(i,4,:);
        M2(:,i)=CBV(i,5,:);
        M3(:,i)=CBV(i,6,:);
        M4(:,i)=CBV(i,7,:);
    elseif i==12
        M1(:,i)=CBV(i,3,:);
        M2(:,i)=CBV(i,4,:);
        M3(:,i)=CBV(i,5,:);
        M4(:,i)=CBV(i,6,:);
    else
        M1(:,i)=CBV(i,2,:);
        M2(:,i)=CBV(i,3,:);
        M3(:,i)=CBV(i,4,:);
        M4(:,i)=CBV(i,5,:);
    end
    
end

for j=1:1:TotRegions
    
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
csvwrite(strcat('Statistics_SD12_retry',Study,'.csv'),M_STAT)

%%
alpha=0.05;

M1=zeros(TotRegions,12);M2=zeros(TotRegions,12);M3=zeros(TotRegions,12);M4=zeros(TotRegions,12);
Study='_Cp';
for i=1:1:12
    anNum=sprintf('%d',i);
    %     CurrentAn=csvread(strcat('SD12_',anNum,Study,'.csv')); % Awake 1
    %     M1(:,i)=CurrentAn(:,1);
    %     M2(:,i)=CurrentAn(:,2);
    %     M3(:,i)=CurrentAn(:,3);
    %     M4(:,i)=CurrentAn(:,4);
    
    if i==7
        M1(:,i)=Cp(i,4,:);
        M2(:,i)=Cp(i,5,:);
        M3(:,i)=Cp(i,6,:);
        M4(:,i)=Cp(i,7,:);
    elseif i==12
        M1(:,i)=Cp(i,3,:);
        M2(:,i)=Cp(i,4,:);
        M3(:,i)=Cp(i,5,:);
        M4(:,i)=Cp(i,6,:);
    else
        M1(:,i)=Cp(i,2,:);
        M2(:,i)=Cp(i,3,:);
        M3(:,i)=Cp(i,4,:);
        M4(:,i)=Cp(i,5,:);
    end
    
end

for j=1:1:TotRegions
    
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
csvwrite(strcat('Statistics_SD12_retry',Study,'.csv'),M_STAT)

