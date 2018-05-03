ROINii=load_nii('SD12_4_Blood_UTE3D_UTEscan1_IMAGINARY_IMAGE_CORRECTED_ABS-label.nii');
ROI=double(ROINii.img);
RealCANii=load_nii('SD12_4_Blood_UTE3D_UTEscan1_REAL_IMAGE_CORRECTED_ABS.nii');
% view_nii(RealNii)
ImagCANii=load_nii('SD12_4_Blood_UTE3D_UTEscan1_IMAGINARY_IMAGE_CORRECTED_ABS.nii');
% view_nii(ImagNii)

RealONii=load_nii('SD12_4_Blood_UTE3D_UTEscan1_REAL_IMAGE.nii');
% view_nii(RealNii)
ImagONii=load_nii('SD12_4_Blood_UTE3D_UTEscan1_IMAGINARY_IMAGE.nii');
% view_nii(ImagNii)

modality='UTE3D';
model='SD12';

for i=1:1:12
    
    %type='Blood';
    an_num=sprintf('%d', i);
    folder1='SD12_BLOOD_EXTRACTED_CORRECTED';
    folder2=folder1;
    Subject=strcat(model, '_', an_num, '_Blood_', modality);
    
    
    cropper=zeros(200,200,200);
    for i=30:1:170
        cropper(:,:,i)=1;
    end
    
    RealCAObj=double(RealCANii.img).*ROI;
    ImagCAObj=double(ImagCANii.img).*ROI;
    RealOObj=double(RealONii.img).*ROI;
    ImagOObj=double(ImagONii.img).*ROI;
    
    RealCAObj=RealCAObj.*cropper;
    ImagCAObj=ImagCAObj.*cropper;
    RealOObj=abs(RealOObj.*cropper);
    ImagOObj=abs(ImagOObj.*cropper);
    
    
    A_R_CA=mean(nonzeros(RealCAObj))
    Std_R_CA=std(nonzeros(RealCAObj))
    
    A_I=mean(nonzeros(ImagCAObj))
    Std_I_CA=std(nonzeros(ImagCAObj))
    
    for i=1:1:200
        Aves(i,1)=mean(nonzeros(RealCAObj(:,:,i)));
        Aves(i,2)=mean(nonzeros(ImagCAObj(:,:,i)));
        Stds(i,1)=std(nonzeros(RealCAObj(:,:,i)));
        Stds(i,2)=std(nonzeros(ImagCAObj(:,:,i)));
        
        Aves(i,3)=mean(nonzeros(RealOObj(:,:,i)));
        Aves(i,4)=mean(nonzeros(ImagOObj(:,:,i)));
        Stds(i,3)=std(nonzeros(RealOObj(:,:,i)));
        Stds(i,4)=std(nonzeros(ImagOObj(:,:,i)));
    end
    
    RealObjNii=RealCANii;
    RealObjNii.img=RealCAObj;
    % view_nii(RealObjNii)
    
    ImagObjNii=ImagCANii;
    ImagObjNii.img=ImagCAObj;
    % view_nii(ImagObjNii)
end

%%

for i=1:1:200
    z(i,1)=(i-100)*.15
end


%%

modality='UTE3D';
model='SD12';

cutoff=30;
mask=zeros(200,200,200);
for i=(1+cutoff):1:(200-cutoff)
    mask(:,:,i)=1;
end

%DataForHist=zeros(12,4,600000);
maxDat=0;
for i=1:1:12
    
    
    an_num=sprintf('%d', i);
    folder1='SD12_BLOOD_EXTRACTED_CORRECTED';
    folder2=folder1;
    Subject=strcat(model, '_', an_num, '_Blood_', modality);
    ROINii=load_nii(strcat(Subject, '_UTEscan1_IMAGINARY_IMAGE_CORRECTED_ABS-label.nii'));
    ROIImg=double(ROINii.img);
    ROIImg=ROIImg.*mask;
    
    if i==4
        totscan=2;
    else
        totscan=1;
    end
    
    for j=1:1:totscan
        scn_num=sprintf('%d', j);
        
        for k=1:1:4
            clear type
            if k==1
                type='REAL';
                l=0;
            elseif k==2
                type='IMAGINARY';
                l=0;
            elseif k==3
                type='MAGNITUDE';
                l=1;
            elseif k==4
                type='MAGNITUDE';
                l=2;
            end
            
            if l==0
                file=strcat(Subject, '_UTEscan', scn_num, '_', type, '_IMAGE_CORRECTED_ABS');
            elseif l==1
                file=strcat(Subject, '_UTEscan', scn_num, '_', type, '_IMAGE_CORRECTED');
            elseif l==2
                file=strcat(Subject, '_UTEscan', scn_num, '_', type, '_IMAGE_CORRECTED_CROPPED_METH2');
            end
            loadname=strcat(folder1, '\', file, '.nii');
            CurrentNii=load_nii(loadname);
            Image=double(CurrentNii.img);
            
            clear Data
            Image = Image.*ROIImg;
            Data=nonzeros(Image);
            Aves(i,k)=mean(Data);
            Stds(i,k)=std(Data);
           
            
            s=size(Data);
            
            [h,p,adstat,cv] = adtest(Data);
            if h>0
                i
                k
                histogram(Data)
                pause(1);
            end
            
            for m=1:1:s(1,1)
                DataForHist(i,k,m)=Data(m,1);
            end
            
            if s(1,1)>maxDat
                maxDat=s(1,1);
            end
            
            Data2=nonzeros(Image(:,:,100));
            
            AvesMid(i,k)=mean(Data2);
            
            
            
        end
    end
end
