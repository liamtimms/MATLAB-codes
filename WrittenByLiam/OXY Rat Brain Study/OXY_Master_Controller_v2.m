% % % % % % % %   OXY Master Controller   % % % % % % %
% % % % % % % %    Liam Timms 10/25/17    % % % % % % %
% % % % % % % % % % % % % % % % % % % % % % % % % % % %

% Clean workspace
clear
clc
close all
%%
model='OXY_QUTECE';
folderPre='PreAddiction';
folderPost='PostAddiction';
subfolder='Copy_of_EXTRACTED_RENAMED';

AnNumsPre=[1;2;4;5;8;9;10;11;12;13;14;15;16;17;18;19;20;21];
% AnNumsPost=[1;5;10;11;12;15;16;17;18;19;20;21]; % All of these are also in Pre
AnNumsPost=[1;5;10;11;15;16;17;18;19;20;21];
s=size(AnNumsPost);

pathPre=strcat(folderPre, '\', subfolder);
pathPost=strcat(folderPost, '\', subfolder);

%% Reslice to UTE scan resolution and BatchSetup
dim=0.1666666666666; %This is the resolution for the steady state UTE Scans

n=1;

for i=1:s(1)
    for j=1:2
        an_num=sprintf('%d', AnNumsPost(i,1));
        if j==1
            State='PRE';
            Path=pathPre;
        elseif j==2
            State='POST';
            Path=pathPost;
        end
        
        NumScans=1;
        modality='RARE'; %Anatomy image
        for k=1:NumScans
            scn_num=sprintf('%d', k);
            Subject=strcat(model, '_', State, '_R',an_num, '_', modality);
            file=strcat(Path, '\', Subject, 'scan', scn_num,'_MAGNITUDE_IMAGE.nii');
            InitialNii=load_nii(file);
            NewNii=InitialNii;
            NewNii.img=NewNii.img*100; %so that it can be used in the atlas fitting
            file=strcat(Path, '\', Subject, 'scan', scn_num,'_MAGNITUDE_IMAGE_x100.nii');
            save_nii(NewNii,file);
            ResliceSPMcontroller(file, dim, dim, dim)
            filelist1(1,1)={strcat(Path, '\r', Subject, 'scan', scn_num,'_MAGNITUDE_IMAGE_x100.nii,1')};
        end
        
        NumScans=2;
        modality='MSME'; %MSME images
        for k=1:NumScans
            scn_num=sprintf('%d', k);
            Subject=strcat(model, '_', State, '_R',an_num, '_', modality);
            file=strcat(Path, '\', Subject, 'scan', scn_num,'_MAGNITUDE_IMAGE.nii');
            InitialNii=load_nii(file);
            NewNii=InitialNii;
            save_nii(NewNii,file);
            ResliceSPMcontroller(file, dim, dim, dim)
            filelist1(k+1,1)={strcat(Path, '\r', Subject, 'scan', scn_num,'_MAGNITUDE_IMAGE.nii,1')};
        end
        
        matlabbatch{1}.spm.spatial.realign.estwrite.data = {
            filelist1(1,1)
            filelist1(2,1)
            filelist1(3,1)
            }';
        matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.quality = 0.99;
        matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.sep = 0.2;
        matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.fwhm = 0.3;
        matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.rtm = 1;
        matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.interp = 7;
        matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.wrap = [0 0 0];
        matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.weight = '';
        matlabbatch{1}.spm.spatial.realign.estwrite.roptions.which = [2 0];
        matlabbatch{1}.spm.spatial.realign.estwrite.roptions.interp = 0;
        matlabbatch{1}.spm.spatial.realign.estwrite.roptions.wrap = [0 0 0];
        matlabbatch{1}.spm.spatial.realign.estwrite.roptions.mask = 1;
        matlabbatch{1}.spm.spatial.realign.estwrite.roptions.prefix = 'ra_';
        
        spm('defaults','fmri');
        spm_jobman('initcfg');
        spm_jobman('run',matlabbatch);
        
        NumScans=4;
        modality='UTE3D';
        for k=1:NumScans
            scn_num=sprintf('%d', k);
            Subject=strcat(model, '_', State, '_R',an_num, '_', modality);
            filelist2(k,1)={strcat(Path, '\', Subject, 'scan', scn_num,'_MAGNITUDE_IMAGE.nii,1')};
        end
        
        Subject
        matlabbatch{1}.spm.spatial.realign.estwrite.data = {
            filelist2(1,1)
            filelist2(2,1)
            filelist2(3,1)
            filelist2(4,1)
            }';
        matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.quality = 0.99;
        matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.sep = 0.2;
        matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.fwhm = 0.3;
        matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.rtm = 1;
        matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.interp = 7;
        matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.wrap = [0 0 0];
        matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.weight = '';
        matlabbatch{1}.spm.spatial.realign.estwrite.roptions.which = [2 0];
        matlabbatch{1}.spm.spatial.realign.estwrite.roptions.interp = 0;
        matlabbatch{1}.spm.spatial.realign.estwrite.roptions.wrap = [0 0 0];
        matlabbatch{1}.spm.spatial.realign.estwrite.roptions.mask = 1;
        matlabbatch{1}.spm.spatial.realign.estwrite.roptions.prefix = 'ra_';
        
        spm('defaults','fmri');
        spm_jobman('initcfg');
        spm_jobman('run',matlabbatch);
    end
end

%% Motion Correct UTE Images

%loop over pre and post
%loop per animal
%loop per scan type
%initialize vars
%job_realign using BatchScriptTest_job as guide
%consider uses for batch_preproc improvments/errors
% List of open inputs
% nrun = X; % enter the number of runs here
% jobfile = {'E:\Backup And Sync\unshared research\BatchScriptTest_job.m'};
% jobs = repmat(jobfile, 1, nrun);
% inputs = cell(0, nrun);
% for crun = 1:nrun
% end
% spm('defaults', 'FMRI');
% spm_jobman('run', jobs, inputs{:});

% % SPM info
% b.spmDir = fileparts(which('spm'));         % path to SPM installation
%
% % Directory information
% dataDir = '/path/to/MRI/data/';
% b.curSubj = subjects{i};
% b.dataDir = strcat(dataDir,b.curSubj,'/');  % make data directory subject-specific
% b.funcRuns = {'epi_0001' 'epi_0002'};       % folders containing functional images
% b.anatT1 = 'mprage';                        % folder containing T1 structural
%
% % Call sub-function to run exceptions
% b = run_exceptions(b);


%% Fix atlas files

model='rOXY_QUTECE';
folderPre='PreAddiction';
folderPost='PostAddiction';
subfolder1='EXTRACTED_RENAMED_RESLICED';
subfolder2='MAP';

pathPre=strcat(folderPre, '\');
pathPost=strcat(folderPost, '\');

s=size(AnNumsPost);
for i=1:s(1)
    for j=1:2
        an_num=sprintf('%d', AnNumsPost(i,1));
        if j==1
            State='PRE';
            Path=pathPre;
        elseif j==2
            State='POST';
            Path=pathPost;
        end
        
        NumScans=1;
        modality='RARE'; %Anatomy image
        for k=1:NumScans
            scn_num=sprintf('%d', k);
            Subject=strcat(model, '_', State, '_R',an_num, '_', modality);
            file=strcat(Path, subfolder1, '\', Subject, 'scan', scn_num,'_MAGNITUDE_IMAGE_x100.nii');
            SourceNii=load_nii(file);
            
            file=strcat(Path, subfolder2, '\map_', Subject, 'scan', scn_num,'_MAGNITUDE_IMAGE_x100.nii');
            AtlasNii=load_nii(file);
            
            [NewAtlasNii] = AtlasFixer(AtlasNii, SourceNii);
            file=strcat(Path, subfolder2, '\FixedMap_', Subject, 'scan', scn_num,'_MAGNITUDE_IMAGE_x100.nii');
            save_nii(NewAtlasNii,file);
            
            testnii=SourceNii;
            ROI=double(NewAtlasNii.img);
            ROI(isnan(ROI))=0;
            ROI(ROI~=0)=1;
            testnii.img=double(SourceNii.img).*ROI;
            view_nii(testnii)
        end
    end
end


%% SCAN AVERAGER

model='rOXY_QUTECE';
folderPre='PreAddiction';
folderPost='PostAddiction';
subfolder='EXTRACTED_RENAMED_RESLICED_UTE_WORKING';
% subfolder2='MAP_FIXED';

pathPre=strcat(folderPre, '\', subfolder);
pathPost=strcat(folderPost, '\', subfolder);
for i=1:s(1)
    for j=1:2
        an_num=sprintf('%d', AnNumsPost(i,1));
        if j==1
            State='PRE';
            Path=pathPre;
        elseif j==2
            State='POST';
            Path=pathPost;
        end
        
        PreConImg=zeros(180,180,180);
        PostConImg=zeros(180,180,180);
        %         nPre=0;
        %         nPost=0;
        NumScans=4;
        modality='UTE3D'; %UTE IMAGES
        for k=1:NumScans
            scn_num=sprintf('%d', k);
            Subject=strcat(model, '_', State, '_R',an_num, '_', modality);
            
            file=strcat(Path, '\', Subject, 'scan', scn_num,'_MAGNITUDE_IMAGE.nii');
            UTENii=load_nii(file);
            UTEimg=double(UTENii.img);
            
            if k<3
                PreConImg=PreConImg+UTEimg;
                %                 nPre=nPre+1;
            elseif k>2
                PostConImg=PostConImg+UTEimg;
                %                 nPost=nPost+1;
            end
            
        end
        
        PreConNii=UTENii;
        PostConNii=UTENii;
        PreConNii.img=PreConImg/2;
        PostConNii.img=PostConImg/2;
        
        scn_num='PRE';
        file=strcat(Path, '\', Subject, 'scan', scn_num,'_MAGNITUDE_IMAGE.nii');
        save_nii(PreConNii,file);
        
        scn_num='POST';
        file=strcat(Path, '\', Subject, 'scan', scn_num,'_MAGNITUDE_IMAGE.nii');
        save_nii(PostConNii,file);
        
        DifferenceImg=PostConImg-PreConImg;
        DifferenceNii=UTENii;
        DifferenceNii.img=DifferenceImg;
        
        scn_num='DIFF';
        file=strcat(Path, '\', Subject, 'scan', scn_num,'_MAGNITUDE_IMAGE.nii');
        save_nii(DifferenceNii,file);
    end
    
end

%% Regional CBV Difference Extraction

AnNumsOxy=[1;5;10;11];
AnNumsCtrl=[15;16;17;18;19;20;21];

%%
model='rOXY_QUTECE';
folderPre='PreAddiction';
folderPost='PostAddiction';
subfolder1='RESLICED_V1\EXTRACTED_RENAMED_RESLICED_UTE_WORKING';
subfolder2='MAP_FIXED';
subfolder3='RESLICED_V1\BLOOD_LABELS';

pathPre=strcat(folderPre, '\');
pathPost=strcat(folderPost, '\');

NumReg=174;
for i=1:s(1)
    for j=1:2
        ANum=AnNumsPost(i,1);
        an_num=sprintf('%d', ANum);
        if j==1
            State='PRE';
            Path=pathPre;
        elseif j==2
            State='POST';
            Path=pathPost;
        end
        
        modality='UTE3D';
        scn_num='DIFF';
        Subject=strcat(model, '_', State, '_R',an_num, '_', modality);
        file= strcat(Path, subfolder1, '\', Subject, 'scan', scn_num,'_MAGNITUDE_IMAGE.nii');
        UTENii=load_nii(file);
        IntensityImg=double(UTENii.img);
        
        scn_num='POST';
        Subject=strcat(model, '_', State, '_R',an_num, '_', modality);
        file= strcat(Path, subfolder3, '\', Subject, 'scan', scn_num,'_MAGNITUDE_IMAGE-label.nii');
        BloodLabelNii=load_nii(file);
        BloodROI=double(BloodLabelNii.img);
        
        BloodROI(isnan(BloodROI))=0;
        BloodROI(BloodROI~=0)=1;
        Data=nonzeros(BloodROI.*IntensityImg);
        BloodData{ANum,j}=Data;
        BloodDiff=nanmean(Data);
        
        CBVImg=IntensityImg/BloodDiff;
        
        
        modality='RARE';
        scn_num='1';
        Subject=strcat(model, '_', State, '_R',an_num, '_', modality);
        file=strcat(Path, subfolder2, '\FixedMap_', Subject, 'scan', scn_num,'_MAGNITUDE_IMAGE_x100.nii');
        AtlasNii=load_nii(file);
        ATLASimg=double(AtlasNii.img);
        
        
        
        for k=1:1:NumReg+1
            % select region
            ROI=ATLASimg;
            
            if k<(NumReg+1)
                ROI(ROI~=k)=0;
            end
            
            ROI(ROI~=0)=1;
            Data=CBVImg.*ROI;
            Data(isnan(Data))=0;
            Data=reshape(Data,[],1);
            [xi,~,~] = find(Data~=0);
            Vals=nonzeros(Data);
            myData.Raw{ANum,j,k}=Vals;
            myData.Ave{ANum,j,k}=nanmean(Vals);
            
        end
    end
end

clearvars -except myData NumReg BloodData


%% Statistical Difference Analysis


%Animal changes over time
NumAns=21;
n=0;
for i=1:21
    for k=1:NumReg+1
        if ~isempty(myData.Ave{i,2,k}) && ~isempty(myData.Ave{i,1,k})
            DiffAvePrePost(i,k)=myData.Ave{i,2,k}-myData.Ave{i,1,k};
            PreOxyAve(i,k)=myData.Ave{i,1,k};
            PostOxyAve(i,k)=myData.Ave{i,2,k};
            DiffAvePrePost(i,k)=myData.Ave{i,2,k}-myData.Ave{i,1,k};
        else
            DiffAvePrePost(i,k)=NaN;
        end
    end
end

%%
OxyDiff=DiffAvePrePost(1:12,:);
CtrlDiff=DiffAvePrePost(12:21,:);

%%

for k=1:NumReg+1
    k
    [Diff_Ttest1(k), Diff_pVal1(k)]=ttest2(OxyDiff(:,k),CtrlDiff(:,k));
end

for k=1:NumReg+1
    k
    [Diff_Ttest2(k), Diff_pVal2(k)]=ttest2(PreOxyAve(1:12,k),PostOxyAve(1:12,k));
end


% MeanVals_IntDiff(1,i
%
% [a b c]=size(MeanVals_IntDiff)
% NumStates=a;
% NumAn=b;m
% NumReg=c;
% alpha=0.05;
% % s=sprintf('%d',NumReg-1);

% [MeanMean, MeanStd, Mean_Diff, Mean_Diff_Mean, Mean_Diff_Std, Mean_Diff_Ttest, Mean_Diff_pVal, Mean_Diff_2StdTest] =get_SD12_Functional_Animal_Analysis_v2(MeanVals_CBV, alpha, NumStates, NumAn, NumReg);

%Animal differences between groups