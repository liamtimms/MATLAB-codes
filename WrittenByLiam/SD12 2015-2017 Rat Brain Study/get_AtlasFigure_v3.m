% % % % % % % SD12 Atlas Figure Crafting  % % % % % % %
% % % % % % % %    Liam Timms 8/24/16    % % % % % % % %
% % % % % % % % % % % % % % % % % % % % % % % % % % % %

% Expanded from previous version to include both vertical and horizontal

function [FigureMatrix] =get_AtlasFigure_v3(AtlasImg, slices, direction, layout)

s=size(slices);
s2=size(AtlasImg);

if strcmp(layout, 'vertical')
    s=size(slices);
    Spacing=zeros(s2(1),20);
    
    if strcmp(direction,'axial')
        FigureMatrix=AtlasImg(:,:,slices(s(2)));
    elseif strcmp(direction,'coronal')
        FigureMatrix(:,:)=AtlasImg(:,slices(s(2)),:);
        FigureMatrix=[FigureMatrix Spacing];
    end
    
    for i=s(2)-1:-1:1
        
        if strcmp(direction,'axial')
            CurrentSlice=AtlasImg(:,:,slices(i));
        elseif strcmp(direction,'coronal')
            CurrentSlice(:,:)=AtlasImg(:,slices(i),:);
        end
        
        FigureMatrix=[FigureMatrix CurrentSlice];
        FigureMatrix=[FigureMatrix Spacing];
        
    end
    
elseif strcmp(layout, 'horizontal')
    
    Spacing=zeros(20,s2(1));
    
    if strcmp(direction,'axial')
        FigureMatrix=AtlasImg(:,:,slices(1));
    elseif strcmp(direction,'coronal')
        Spacing=zeros(20,s2(3));
        FigureMatrix(:,:)=AtlasImg(:,slices(1),:);
        FigureMatrix=[FigureMatrix; Spacing];
    end
    
    for i=2:1:s(2)
        
        if strcmp(direction,'axial')
            CurrentSlice=AtlasImg(:,:,slices(i));
        elseif strcmp(direction,'coronal')
            CurrentSlice(:,:)=AtlasImg(:,slices(i),:);
        end
        
        FigureMatrix=[FigureMatrix; CurrentSlice];
        FigureMatrix=[FigureMatrix; Spacing];
        
    end

end

FigureMatrix(FigureMatrix==0)=NaN;
[FigureMatrix] =get_RefinedFigure(FigureMatrix);

end