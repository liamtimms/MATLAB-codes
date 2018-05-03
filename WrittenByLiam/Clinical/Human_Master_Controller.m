% % % % % % % %  Human Master Controller  % % % % % % %
% % % % % % % %    Liam Timms 10/25/17    % % % % % % %
% % % % % % % % % % % % % % % % % % % % % % % % % % % %

% Clean workspace
clear
clc
close all

%%
NumPatients=2;
root_path='G:\My Drive\MRI common\Ongoing Research\Clinic\Clinical Patients\ClinicalPatient_Analysis_v2'
subfolders={'Precon','Postcon','Blood'};
ss=size(subfolders);

for i=1:1:NumPatients
    pat_num=sprintf('%d', i-1);
    subject=strcat('Patient_',pat_num);
    for j=1:ss(1)
        
        session=subfolders{j};
        path=strcat(root_path, '\', subject, '\', session);
        DICOM_folder=strcat(path,'DICOM');
        Nii_folder=strcat(path,'NIFTI');
        dicm2nii(DICOM_folder,  Nii_folder, 0)
        dicm2nii_custom(DICOM_folder,  Nii_folder, 0);
        
        h=load(stccat(Nii_folder, '\dcmHeaders.mat'));
        hdr_cells=struct2cell(h);
        sss=size(hdr_cells);
        %%need to implement b1+ and gibbs fix here
        
        clearvars ScanTypes;
        ScanTypes=[];
        n=0;
        for k=1:sss(1)
            ScanType=hdr_cells{k,1}.ProtocolName;
            if ~any(strcmp(ScanTypes,ScanType))
                n=n+1;
                ScanTypes{n,1}=ScanType;
            end
        end
        
        for l=1:n
            ScanType=ScanTypes{n,1};
            clearvars FileNames;
            FileNames=[];
            for k=1:sss(1)
                ScanType2=hdr_cells{k,1}.ProtocolName;
                if strcmp(ScanType,ScanType2)
                    NiiFile=hdr_cells{k,1}.NiftiName;
                    FileName=strcat(Nii_folder, '\', 'NiiFile');
                    FileNames= [FileNames; FileName];
                end
            end
            
            % P = spm_realign(P,flags)
            flags.quality=95;
            flags.fwhm=3;
            flags.sep=2;
            flags.interp=7;
            P = spm_realign(FileNames,flags);
            
            clearvars flags
            flags.sep=[6 3 2];
            x = spm_coreg(VG,VF,flags)
            
        end
        
        j
    end
    i
end

%  s = h.myFuncSeries; % field name is the same as nii file name
%  spm_ms = (0.5 - s.SliceTiming) * s.RepetitionTime;
%  [~, spm_order] = sort(-s.SliceTiming);