function [Averages, Stdevs, Ns] =Inhomogeneity_Characterization(N_regions, N_dimensions, N_elements, image, ROI)

Averages=zeros(N_regions, N_elements, N_dimensions);
Stdevs=zeros(N_regions, N_elements, N_dimensions);
Ns=zeros(N_regions, N_elements, N_dimensions);

%this section is actually many many for-loops  expressed in a very
%succint way

% RegionMapAve=Data;
% RegionMapStd=Data;
% RegionAverages=ROI;
% RegionStdevs=ROI;

if N_regions==1 && N_dimensions==3 
    relevant_ROI=ROI;
    relevant_ROI(relevant_ROI>0)=1.0;
    Object=image.*relevant_ROI;
    for j=1:1:N_elements
        Averages(N_regions, j, 1)=mean(nonzeros(Object(j,:,:)));
        Averages(N_regions, j, 2)=mean(nonzeros(Object(:,j,:)));
        Averages(N_regions, j, 3)=mean(nonzeros(Object(:,:,j)));
        Stdevs(N_regions, j, 1)=std(nonzeros(Object(j,:,:)));
        Stdevs(N_regions, j, 2)=std(nonzeros(Object(:,j,:)));
        Stdevs(N_regions, j, 3)=std(nonzeros(Object(:,:,j)));
        Ns(N_regions, j, 1)=sum(nonzeros(relevant_ROI(j,:,:)));
        Ns(N_regions, j, 2)=sum(nonzeros(relevant_ROI(:,j,:)));
        Ns(N_regions, j, 3)=sum(nonzeros(relevant_ROI(:,:,j)));
    end
    

            
elseif N_regions==174


    if N_dimensions==1
        for i=1:1:N_regions
            relevant_ROI=ROI;
            relevant_ROI(relevant_ROI==i)=1;
            relevant_ROI(relevant_ROI~=1)=0;
            Object=image.*relevant_ROI;
            Averages(i,1, N_dimensions)=mean(nonzeros(Object));
            Stdevs(i,1, N_dimensions)=std(nonzeros(Object));
            Ns(i, 1, N_dimensions)=sum(nonzeros(relevant_ROI));

        end

        for i=1:1:N_regions
            RegionAverages(RegionAverages==i)=Averages(i,1,1);
            RegionStdevs(RegionStdevs==i)=Stdevs(i,1,1);
        end
%         RegionMapAve.img=RegionAverages;
%         RegionMapStd.img=RegionStdevs;


    elseif N_dimensions==3
        for i=1:1:N_regions
            relevant_ROI=ROI;
            relevant_ROI(relevant_ROI==i)=1;
            relevant_ROI(relevant_ROI~=1)=0;
            Object=image.*relevant_ROI;
            for j=1:1:N_elements
                Averages(N_regions, j, 1)=mean(nonzeros(Object(j,:,:)));
                Averages(N_regions, j, 2)=mean(nonzeros(Object(:,j,:)));
                Averages(N_regions, j, 3)=mean(nonzeros(Object(:,:,j)));
                Stdevs(N_regions, j, 1)=std(nonzeros(Object(j,:,:)));
                Stdevs(N_regions, j, 2)=std(nonzeros(Object(:,j,:)));
                Stdevs(N_regions, j, 3)=std(nonzeros(Object(:,:,j)));       
            end
                    
        end
    end

end
