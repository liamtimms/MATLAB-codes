modality='UTE3D';
model='rSD12';
TotRegions=59; %either 59, 106 or 174

capmaskcrop=0; %0 means do not use, 1 means do use it

reg_num=sprintf('%d', TotRegions);

for i=1:1:12
    an_num=sprintf('%d', i);
    folder1='SD12_RAT_CBV';
    folder2='Atlas_Map_Files';
    folder3='Cap_MAP_from_CBV';
    Subject=strcat(model, '_', an_num, '_', modality);
    
    if i==7
        totscan=7;
    elseif i==12
        totscan=6;
    else
        totscan=5;
    end
    if i==7
        skip=2;
    elseif i==12
        skip=1;
    else
        skip=0;
    end
    
    
    scn_num=sprintf('%d', totscan);
    file=strcat('map_', Subject, '_UTEscan', scn_num, '_MAGNITUDE_IMAGE_', reg_num ,'_REGION');
    loadname=strcat(folder2, '\', file, '.nii');
    ATLASNii=load_nii(loadname);
    ATLASimg=double(ATLASNii.img);
    
    for j=2:1:totscan
        scn_num=sprintf('%d', j);
        
        type='MAGNITUDE';
        
        file=strcat(Subject, '_CBV_from_UTEscan', scn_num, '_', type, '_IMAGE_CORRECTED_CROPPED_METH2');
        
        loadname=strcat(folder1, '\', file, '.nii');
        CBVNii=load_nii(loadname);
        CBVImg=double(CBVNii.img);
        
        if capmaskcrop==1
            
            file=strcat('map_' ,Subject, '_Caps_CBV_from_UTEscan', scn_num, '_', type, '_IMAGE_CORRECTED_CROPPED_METH2');
            loadname=strcat(folder3, '\', file, '.nii');
            CapMapNii=load_nii(loadname);
            CapMapImg=double(CapMapNii.img);
            
        else
            
            CapMapImg=zeros(200,200,200);
        end
        
        %invert CapMap
        CapMapImg(CapMapImg~=0)=1;
        CapMapImg=CapMapImg-1;
        CapMapImg(CapMapImg<0)=1;
        
        for n=1:1:TotRegions
            
            % select region
            ROI=ATLASimg;
            ROI(ROI~=n)=0;
            ROI(ROI~=0)=1;
            
            ROI=ROI.*CapMapImg;
            
            Data=CBVImg.*ROI;
            
            Data(isnan(Data))=0; %WTF NANS
            Data=nonzeros(Data);
            
            s=size(Data);
            for blah=1:1:s(1,1)
                DataPerRegion(j,n,blah)=Data(blah,1);
            end
            
        end
        
        for j=2:1:5
            M(i,j-1,:)=DataPerRegion(j+skip,:,:);
        end
        
    end
    
    
    alpha=0.05;

    
    for n=1:1:TotRegions
        
        [h1,p1]=ttest2(DataPerRegion(1,n,:),DataPerRegion(3,n,:),'alpha',alpha); % compare Awake1 vs. Awake2
        [h2,p2]=ttest2(DataPerRegion(1,n,:),DataPerRegion(2,n,:),'alpha',alpha); % compare Awake1 vs. CO2
        [h3,p3]=ttest2(DataPerRegion(1,n,:),DataPerRegion(4,n,:),'alpha',alpha); % compare Awake1 vs. Anesth
        [h4,p4]=ttest2(DataPerRegion(3,n,:),DataPerRegion(2,n,:),'alpha',alpha); % compare Awake2 vs. CO2
        [h5,p5]=ttest2(DataPerRegion(3,n,:),DataPerRegion(4,n,:),'alpha',alpha);% compare Awake2 vs. Anesth
        [h6,p6]=ttest2(DataPerRegion(2,n,:),DataPerRegion(4,n,:),'alpha',alpha); % compare CO2 vs. Anesth
        
        H(n,1)=h1;
        H(n,2)=h2;
        H(n,3)=h3;
        H(n,4)=h4;
        H(n,5)=h5;
        H(n,6)=h6;
        
        P(n,1)=p1;
        P(n,2)=p2;
        P(n,3)=p3;
        P(n,4)=p4;
        P(n,5)=p5;
        P(n,6)=p6;
        
    end
    
    
    
    
    for j=1:1:6
        STAT_Summary(i,j)=sum(H(:,j));
    end
    
    clear H P DataPerRegion
    
end



