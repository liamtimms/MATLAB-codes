% % % % % % % %   SD12 Data Processing  % % % % % % % %
% % % % % % % % % %  Liam Timms 3/3/16 % % % % % % % %
% % % % % % % % % % % % % % % % % % % % % % % % % % % %

%%

clc
clear
close all


%% Uses Magnitude Meth2 

k=3;

[BloodFromPeak, BloodFromPeakStd, ROIave, ROIStds] =get_BloodValues(k);
folder='SD12_Results_Mag_Meth2\';

for t=1:1:3
    if t==1
        TotRegions=59; %either 59, 106 or 174
    elseif t==2
        TotRegions=106;
    elseif t==3
        TotRegions=174;
    end
    
    r_num=sprintf('%d', TotRegions);
    filename=strcat(folder, 'Statistics_SD12_CBV_',r_num,'.csv');
    
    if exist(filename, 'file')
        fprintf('Already saved. \n');
        M_STAT= csvread(filename);
        
    else
        peakget=0; %0 means it will not find the peak of the gaussian fit to the intensities, 1 means it will
        [I_avg_pre, I_std_pre, I_avg_post, I_std_post, I_peak_pre, I_peak_std_pre, I_peak_post, I_peak_std_post] =get_IntensityPerRegion(TotRegions, k, peakget)
        
        %CBV calculation is too simple to warrant a whole seperate function
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
                    
                    denom=BloodFromPeak(i,j)-BloodFromPeak(i,1);
                    
                    %             num=I_peak_post(i,j,3,n) - I_peak_pre(i,j,3,n);
                    %             Cp(i,j,n) =(num/denom)*100;
                    %             Cp_error(i,j,n)=Cp(i,j,n)*((I_peak_std_post(i,j,3,n)^2 + I_peak_std_pre(i,j,1,n)^2)/num^2 + (BloodFromPeakStd(i,j,3)^2 + BloodFromPeakStd(i,1,3)^2)/denom^2)^2;
                    %
                    num=I_avg_post(i,j,n) - I_avg_pre(i,j,n);
                    CBV(i,j,n)=(num/denom)*100;
                    CBV_error(i,j,n)=CBV(i,j,n)*((I_std_post(i,j,n)^2 + I_std_pre(i,j,n)^2)/num^2 + (BloodFromPeakStd(i,j)^2 + BloodFromPeakStd(i,1)^2)/denom^2)^2;
                    
                end
                
            end
        end
        
        [M_STAT] =get_StatMatrix_v2(TotRegions, CBV)
        
        csvwrite(filename,M_STAT);
        fprintf('Saved new Excel \n%s', filename);
    end
    
    
    for w=1:1:6
        StatSummary(t,w)=sum(M_STAT(:,14+w));
    end
    
    
end

%% Real and Imaginary Split Recombined on region by region basis (Mag meth 3 in a sense)

folder='SD12_Results_ComplexRegions\';

% for k=1:1:2
%     [BloodFromPeak, BloodFromPeakStd, ROIave, ROIStds] =get_BloodValues(k);
%     Blood(:,:,k);
% end
[BloodFromPeak_r, BloodFromPeakStd_r, ROIave_r, ROIStds_r] =get_BloodValues(1);
[BloodFromPeak_i, BloodFromPeakStd_i, ROIave_i, ROIStds_i] =get_BloodValues(2);

BloodFromPeak=(BloodFromPeak_r.^2 + BloodFromPeak_i.^2).^(1/2);

for t=1:1:3
    if t==1
        TotRegions=59; %either 59, 106 or 174
    elseif t==2
        TotRegions=106;
    elseif t==3
        TotRegions=174;
    end
    
    r_num=sprintf('%d', TotRegions);
    filename=strcat(folder, 'Statistics_SD12_CBV_ComplexRecomb_',r_num,'.csv');
    if exist(filename, 'file')
        fprintf('Already saved. \n');
        M_STAT= csvread(filename);
    else
        peakget=0;
        %         for k=1:1:2
        %              %0 means it will not find the peak of the gaussian fit to the intensities, 1 means it will
        % %             [I_avg_pre, I_std_pre, I_avg_post, I_std_post, I_peak_pre, I_peak_std_pre, I_peak_post, I_peak_std_post] =get_IntensityPerRegion(TotRegions, k, peakget);
        % %             I_a_pr(:,:,:,k)=I_avg_pre;
        % %             I_s_pr(:,:,:,k)=I_std_pre;
        % %             I_a_po(:,:,:,k)=I_avg_post;
        % %             I_s_po(:,:,:,k)=I_std_post;
        %         end
        
        [I_avg_pre_r, I_std_pre_r, I_avg_post_r, I_std_post_r, I_peak_pre_r, I_peak_std_pre_r, I_peak_post_r, I_peak_std_post_r] =get_IntensityPerRegion(TotRegions, 1, peakget);
        [I_avg_pre_i, I_std_pre_i, I_avg_post_i, I_std_post_i, I_peak_pre_i, I_peak_std_pre_i, I_peak_post_i, I_peak_std_post_i] =get_IntensityPerRegion(TotRegions, 2, peakget);
        
        I_avg_pre=(I_avg_pre_r.^2 + I_avg_pre_i.^2).^(1/2);
        I_avg_post=(I_avg_post_r.^2 + I_avg_post_i.^2).^(1/2);
        
        %CBV calculation is too simple to warrant a whole seperate function
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
                    
                    denom=BloodFromPeak(i,j)-BloodFromPeak(i,1);
                    
                    %             num=I_peak_post(i,j,3,n) - I_peak_pre(i,j,3,n);
                    %             Cp(i,j,n) =(num/denom)*100;
                    %             Cp_error(i,j,n)=Cp(i,j,n)*((I_peak_std_post(i,j,3,n)^2 + I_peak_std_pre(i,j,1,n)^2)/num^2 + (BloodFromPeakStd(i,j,3)^2 + BloodFromPeakStd(i,1,3)^2)/denom^2)^2;
                    %
                    num=I_avg_post(i,j,n) - I_avg_pre(i,j,n);
                    CBV(i,j,n)=(num/denom)*100;
%                     CBV_error(i,j,n)=CBV(i,j,n)*((I_std_post(i,j,n)^2 + I_std_pre(i,j,n)^2)/num^2 + (BloodFromPeakStd(i,j)^2 + BloodFromPeakStd(i,1)^2)/denom^2)^2;
                end
            end
        end
        
        M_STAT = get_StatMatrix_v2(TotRegions, CBV);
        csvwrite(filename,M_STAT);
        fprintf('Saved new Excel \n%s', filename);
        
    end   
    
    for w=1:1:6
        StatSummary(t,w)=sum(M_STAT(:,14+w));
    end
        
end

%% 

k=3;

[BloodFromPeak, BloodFromPeakStd, ROIave, ROIStds] =get_BloodValues(k);
folder='SD12_Results_Mag_Meth2_StatCorrect\';

for t=1:1:3
    if t==1
        TotRegions=59; %either 59, 106 or 174
    elseif t==2
        TotRegions=106;
    elseif t==3
        TotRegions=174;
    end
    
    r_num=sprintf('%d', TotRegions);
    filename=strcat(folder, 'Statistics_SD12_CBV_',r_num,'.csv');
    
    if exist(filename, 'file')
        fprintf('Already saved. \n');
        M_STAT= csvread(filename);
        
    else
        peakget=0; %0 means it will not find the peak of the gaussian fit to the intensities, 1 means it will
        [I_avg_pre, I_std_pre, I_avg_post, I_std_post, I_peak_pre, I_peak_std_pre, I_peak_post, I_peak_std_post] =get_IntensityPerRegion(TotRegions, k, peakget)
        
        %CBV calculation is too simple to warrant a whole seperate function
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
                    
                    denom=BloodFromPeak(i,j)-BloodFromPeak(i,1);
                    
                    %             num=I_peak_post(i,j,3,n) - I_peak_pre(i,j,3,n);
                    %             Cp(i,j,n) =(num/denom)*100;
                    %             Cp_error(i,j,n)=Cp(i,j,n)*((I_peak_std_post(i,j,3,n)^2 + I_peak_std_pre(i,j,1,n)^2)/num^2 + (BloodFromPeakStd(i,j,3)^2 + BloodFromPeakStd(i,1,3)^2)/denom^2)^2;
                    %
                    num=I_avg_post(i,j,n) - I_avg_pre(i,j,n);
                    CBV(i,j,n)=(num/denom)*100;
                    CBV_error(i,j,n)=CBV(i,j,n)*((I_std_post(i,j,n)^2 + I_std_pre(i,j,n)^2)/num^2 + (BloodFromPeakStd(i,j)^2 + BloodFromPeakStd(i,1)^2)/denom^2)^2;
                    
                end
                
            end
        end
        
        [M_STAT] =get_StatMatrix_v2(TotRegions, CBV)
        
        csvwrite(filename,M_STAT);
        fprintf('Saved new Excel \n%s', filename);
    end
    
    
    for w=1:1:6
        StatSummary(t,w)=sum(M_STAT(:,14+w));
    end
    
    
end


