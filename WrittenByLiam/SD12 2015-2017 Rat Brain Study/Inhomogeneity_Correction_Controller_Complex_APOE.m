%% SD12 Real and Imaginary UTE Correction

modality='UTE3D';
model='APOE';


for i=1:1:23
    
    if i~=13
        type='Rat';
        an_num=sprintf('%d', i);
        
        if i==1 || i==2 || i==11 || i==12 || i==16
            Ses_num=sprintf('%d', 2);
        else
            Ses_num=sprintf('%d', 1);
        end
        
        folder1='APOE_RAT_EXTRACTED';
        folder2=strcat(folder1, '_CORRECTED');
        Subject=strcat(model, an_num, '_Scan',Ses_num, '_', modality);
        
        %     mkdir(folder, newfolder);
        for j=1:1:2
            scn_num=sprintf('%d', j);
            
            for k=1:1:3
                clear type
                if k==1
                    type='REAL';
                elseif k==2
                    type='IMAGINARY';
                elseif k==3
                    type='MAGNITUDE';
                end
                
                file=strcat(Subject, '_UTEscan', scn_num, '_', type, '_IMAGE');
                loadname=strcat(folder1, '\', file, '.nii');
                CurrentNii=load_nii(loadname);
                Image=double(CurrentNii.img);
                Image_Corrected = Inhomogeneity_Correction_complex(Image, k);
                
                CurrentNii.img=Image_Corrected;
                savename=strcat(folder2, '\', file, '_CORRECTED.nii');
                save_nii(CurrentNii, savename);
                
            end
            
            
        end
    end
    
end

%% Blood spliter and corrector

modality='UTE3D';
model='SD12';


for i=1:1:12
    
    %type='Rat';
    an_num=sprintf('%d', i);
    folder1='SD12_BLOOD_EXTRACTED';
    folder2=strcat(folder1, '_CORRECTED');
    Subject=strcat(model, '_', an_num, '_Blood_', modality);
    
    totscan=1;
    if i==4
        totscan=2;
    end
    
    %     mkdir(folder, newfolder);
    for j=1:1:totscan
        
        scn_num=sprintf('%d', j);
        
        for k=1:1:3
            l=0;
            clear type
            if k==1
                type='REAL';
                l=1;
            elseif k==2
                type='IMAGINARY';
                l=1;
            elseif k==3
                type='MAGNITUDE';
            end
            
            file=strcat(Subject, '_UTEscan', scn_num, '_', type, '_IMAGE');
            loadname=strcat(folder1, '\', file, '.nii');
            CurrentNii=load_nii(loadname);
            
            
            Image=double(CurrentNii.img);
            Image_Corrected = Inhomogeneity_Correction_complex(Image, k);
            
            CurrentNii.img=Image_Corrected;
            savename=strcat(folder2, '\', file, '_CORRECTED.nii');
            save_nii(CurrentNii, savename);
            
            if l==1
                Image_Abs=abs(Image_Corrected);
                CurrentNii.img=Image_Abs;
                savename=strcat(folder2, '\', file, '_CORRECTED_ABS.nii');
                save_nii(CurrentNii, savename);
            end
            
        end
        
    end
    
end



%% CROPPING

cutoff=30;
mask=zeros(200,200,200);
for i=(1+cutoff):1:(200-cutoff)
    mask(:,:,i)=1;
end


modality='UTE3D';
model='APOE';


for i=1:1:23
    
    if i~=13
        type='Rat';
        an_num=sprintf('%d', i);
        
        if i==1 || i==2 || i==11 || i==12 || i==16
            Ses_num=sprintf('%d', 2);
        else
            Ses_num=sprintf('%d', 1);
        end
        
        folder1='APOE_RAT_EXTRACTED_CORRECTED';
        folder2=strcat(folder1, '_CROPPED');
        Subject=strcat(model, an_num, '_Scan',Ses_num, '_', modality);
        totscan=2;
        
        %     mkdir(folder, newfolder);
        for j=1:1:totscan
            scn_num=sprintf('%d', j);
            
            for k=1:1:2
                clear type
                if k==1
                    type='REAL';
                elseif k==2
                    type='IMAGINARY';
                    %             elseif k==3
                    %                 type='MAGNITUDE';
                end
                
                file=strcat(Subject, '_UTEscan', scn_num, '_', type, '_IMAGE_CORRECTED');
                loadname=strcat(folder1, '\', file, '.nii');
                CurrentNii=load_nii(loadname);
                Image=double(CurrentNii.img);
                
                Image_Crop = Image.*mask;
                
                CurrentNii.img=Image_Crop;
                savename=strcat(folder2, '\', file, '_CROPPED.nii');
                save_nii(CurrentNii, savename);
                
            end
        end
    end
end

%% Absolute Values

modality='UTE3D';
model='rSD12';


for i=1:1:12
    
    type='Rat';
    an_num=sprintf('%d', i);
    folder1='SD12_RAT_EXTRACTED_CORRECTED_CROPPED_ALIGNED';
    folder2=strcat(folder1, '_ABS');
    Subject=strcat(model, '_', an_num, '_', modality);
    
    if i==7
        totscan=7;
    elseif i==12
        totscan=6;
    else
        totscan=5;
    end
    
    %     mkdir(folder, newfolder);
    for j=1:1:totscan
        scn_num=sprintf('%d', j);
        
        for k=1:1:2
            clear type
            if k==1
                type='REAL';
            elseif k==2
                type='IMAGINARY';
                %             elseif k==3
                %                 type='MAGNITUDE';
            end
            
            file=strcat(Subject, '_UTEscan', scn_num, '_', type, '_IMAGE_CORRECTED_CROPPED');
            loadname=strcat(folder1, '\', file, '.nii');
            CurrentNii=load_nii(loadname);
            Image=double(CurrentNii.img);
            
            Image_ABS = abs(Image);
            
            CurrentNii.img=Image_ABS;
            savename=strcat(folder2, '\', file, '_ABS.nii');
            save_nii(CurrentNii, savename);
        end
        
        
    end
    
end


%%

modality='UTE3D';
model='rSD12';

for i=1:1:12
    
    type='Rat';
    an_num=sprintf('%d', i);
    folder1='SD12_RAT_EXTRACTED_CORRECTED_CROPPED_ALIGNED_ABS';
    %     folder2=strcat(folder1, '_ABS');
    folder2=folder1;
    Subject=strcat(model, '_', an_num, '_', modality);
    
    if i==7
        totscan=7;
    elseif i==12
        totscan=6;
    else
        totscan=5;
    end
    
    %     mkdir(folder, newfolder);
    for j=1:1:totscan
        scn_num=sprintf('%d', j);
        
        type='REAL';
        file=strcat(Subject, '_UTEscan', scn_num, '_', type, '_IMAGE_CORRECTED_CROPPED_ABS');
        loadname=strcat(folder1, '\', file, '.nii');
        RealNii=load_nii(loadname);
        RealImage=double(RealNii.img);
        
        type='IMAGINARY';
        file=strcat(Subject, '_UTEscan', scn_num, '_', type, '_IMAGE_CORRECTED_CROPPED_ABS');
        loadname=strcat(folder1, '\', file, '.nii');
        ImagNii=load_nii(loadname);
        ImagImage=double(ImagNii.img);
        
        type='MAGNITUDE';
        file=strcat(Subject, '_UTEscan', scn_num, '_', type, '_IMAGE_CORRECTED_CROPPED');
        MagnImage=RealImage;
        
        for k=1:1:200
            for l=1:1:200
                for m=1:1:200
                    R=RealImage(k,l,m);
                    I=ImagImage(k,l,m);
                    MagnImage(k,l,m)=sqrt(R^2+I^2);
                end
            end
        end
        
        savename=strcat(folder1, '\', file, '_METH2.nii');
        MagnNii=RealNii;
        MagnNii.img=MagnImage;
        save_nii(MagnNii, savename);
        
    end
    
end


%% Create Magnitude Images based off of the corrected R and I images

cutoff=30;
mask=zeros(200,200,200);
for i=(1+cutoff):1:(200-cutoff)
    mask(:,:,i)=1;
end

modality='UTE3D';
model='APOE';

for i=1:1:23
    
    if i~=13
        type='Rat';
        an_num=sprintf('%d', i);
        
        if i==1 || i==2 || i==11 || i==12 || i==16
            Ses_num=sprintf('%d', 2);
        else
            Ses_num=sprintf('%d', 1);
        end
        
        folder1='APOE_RAT_EXTRACTED_CORRECTED';
        folder2=strcat(folder1, '_CROPPED');
        Subject=strcat(model, an_num, '_Scan',Ses_num, '_', modality);
        totscan=2;
        
        
        %     mkdir(folder, newfolder);
        for j=1:1:totscan
            scn_num=sprintf('%d', j);
            
            type='REAL';
            file=strcat(Subject, '_UTEscan', scn_num, '_', type, '_IMAGE_CORRECTED');
            loadname=strcat(folder1, '\', file, '.nii');
            RealNii=load_nii(loadname);
            RealImage=double(RealNii.img);
            
            type='IMAGINARY';
            file=strcat(Subject, '_UTEscan', scn_num, '_', type, '_IMAGE_CORRECTED');
            loadname=strcat(folder1, '\', file, '.nii');
            ImagNii=load_nii(loadname);
            ImagImage=double(ImagNii.img);
            
            type='MAGNITUDE';
            file=strcat(Subject, '_UTEscan', scn_num, '_', type, '_IMAGE_CORRECTED_CROPPED');
            MagnImage=RealImage;
            
            for k=1:1:200
                for l=1:1:200
                    for m=1:1:200
                        R=RealImage(k,l,m);
                        I=ImagImage(k,l,m);
                        MagnImage(k,l,m)=sqrt(R^2+I^2);
                    end
                end
            end
            
            MagnImage=MagnImage.*mask;
            
            savename=strcat(folder2, '\', file, '_METH2.nii');
            MagnNii=RealNii;
            MagnNii.img=MagnImage;
            save_nii(MagnNii, savename);
            
        end
    end
end

%% Create possible labels for the Meth2 Magn Images based off of the blood values of the dead rat heads


modality='UTE3D';
model='rSD12';

for i=1:1:12
    
    an_num=sprintf('%d', i);
    folder1='SD12_RAT_EXTRACTED_CORRECTED_CROPPED_ALIGNED_ABS';
    folder2=strcat(folder1);
    Subject=strcat(model, '_', an_num, '_', modality);
    
    if i==7
        totscan=7;
    elseif i==12
        totscan=6;
    else
        totscan=5;
    end
    
    %     mkdir(folder, newfolder);
    for j=totscan:1:totscan
        
        scn_num=sprintf('%d', j);
        
        fact=1;
        lower=Aves(i,4)-fact*Stds(i,4);
        upper=Aves(i,4)+1.5*Stds(i,4);
        
        type='MAGNITUDE';
        file=strcat(Subject, '_UTEscan', scn_num, '_', type, '_IMAGE_CORRECTED_CROPPED_METH2');
        loadname=strcat(folder1, '\', file, '.nii');
        MagnNii=load_nii(loadname);
        
        MagnImage=double(MagnNii.img);
        ROIimg=MagnImage;
        ROIimg(ROIimg<lower)=0;
        ROIimg(ROIimg>upper)=0;
        ROIimg(ROIimg~=0)=1;
        
        PotROINii=MagnNii;
        PotROINii.img=ROIimg;
        a=mean(nonzeros(ROIimg.*MagnImage));
        
        if (a-Aves(i,4))>Stds(i,4)
            i
            a-Aves(i,4)
        end
        
        savename=strcat(folder1, '\', file, '_PotLabel.nii');
        save_nii(PotROINii, savename);
        
    end
    
end

%% Highlight voxels which are around the blood value taken from the blood phantoms


modality='UTE3D';
model='rSD12';

for i=1:1:12
    
    an_num=sprintf('%d', i);
    folder1='SD12_RAT_EXTRACTED_CORRECTED_CROPPED_ALIGNED_ABS';
    folder2=strcat(folder1);
    Subject=strcat(model, '_', an_num, '_', modality);
    
    if i==7
        totscan=7;
    elseif i==12
        totscan=6;
    else
        totscan=5;
    end
    
    %     mkdir(folder, newfolder);
    for j=totscan:1:totscan
        
        scn_num=sprintf('%d', j);
        
        fact=1;
        lower=Aves(i,4)-fact*Stds(i,4);
        upper=Aves(i,4)+1.5*Stds(i,4);
        
        type='MAGNITUDE';
        file=strcat(Subject, '_UTEscan', scn_num, '_', type, '_IMAGE_CORRECTED_CROPPED_METH2');
        loadname=strcat(folder1, '\', file, '.nii');
        MagnNii=load_nii(loadname);
        
        MagnImage=double(MagnNii.img);
        ROIimg=MagnImage;
        ROIimg(ROIimg<lower)=0;
        ROIimg(ROIimg>upper)=0;
        ROIimg(ROIimg~=0)=1;
        
        PotROINii=MagnNii;
        PotROINii.img=ROIimg;
        a=mean(nonzeros(ROIimg.*MagnImage));
        
        if (a-Aves(i,4))>Stds(i,4)
            i
            a-Aves(i,4)
        end
        
        savename=strcat(folder1, '\', file, '_PotLabel.nii');
        save_nii(PotROINii, savename);
        
    end
    
end


