% % % % % % % %   SD12 Data Best Quant  % % % % % % % %
% % % % % % % %    Liam Timms 3/15/16   % % % % % % % %
% % % % % % % % % % % % % % % % % % % % % % % % % % % %


modality='UTE3D';
model='rSD12';
TotRegions=59; %either 59, 106 or 174

capmaskcrop=0; %0 means do not use, 1 means do use it

reg_num=sprintf('%d', TotRegions);
j=1;

for q=.25:.05:.75
    
    
    for i=1:1:12
        an_num=sprintf('%d', i);
        folder1='SD12_RAT_CBV_REDO';
        folder2='Atlas_Map_Files';
        folder3='Cap_MAP_from_CBV_REDO';
        Subject=strcat(model, '_', an_num, '_', modality);
        
        if i==7
            totscan=7;
        elseif i==12
            totscan=6;
        else
            totscan=5;
        end
        
        type='MAGNITUDE';
        scn_num=sprintf('%d', totscan);
        file=strcat('map_', Subject, '_UTEscan', scn_num, '_MAGNITUDE_IMAGE_', reg_num ,'_REGION');
        loadname=strcat(folder2, '\', file, '.nii');
        ATLASNii=load_nii(loadname);
        ATLASimg=double(ATLASNii.img);
        
        if capmaskcrop==1
            CapMapImg =get_SummedCapMap(i, Subject, type, folder3);
        else
            CapMapImg=zeros(200,200,200);
        end
        
        %invert CapMap
        CapMapImg(CapMapImg~=0)=1;
        CapMapImg=CapMapImg-1;
        CapMapImg(CapMapImg<0)=1;
        
        scn_num=sprintf('%d', totscan);
        
        
        
        file=strcat(Subject, '_CBV_from_UTEscan', scn_num, '_', type, '_IMAGE_CORRECTED_CROPPED_METH2');
        
        loadname=strcat(folder1, '\', file, '.nii');
        CBVNii=load_nii(loadname);
        CBVImg=double(CBVNii.img);
        
        for n=1:1:TotRegions+1
            
            % select region
            ROI=ATLASimg;
            
            if n<(TotRegions+1)
                ROI(ROI~=n)=0;
            end
            
            ROI(ROI~=0)=1;
            
            ROI=ROI.*CapMapImg;
            
            Data=CBVImg.*ROI;
            
            Data(isnan(Data))=0; %WTF NANS
            Data=nonzeros(Data);
            
            
            result=quantile(Data,[q]);

            CBVQ(i,j,n)=result;
            
            %             CBV_error(i,j,n)=std(Data);
            
        end
        
    end
    
    j=j+1;
end