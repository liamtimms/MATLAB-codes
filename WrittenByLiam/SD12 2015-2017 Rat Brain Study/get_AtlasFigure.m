% % % % % % % SD12 Atlas Figure Crafting  % % % % % % %
% % % % % % % %    Liam Timms 6/7/16    % % % % % % % %
% % % % % % % % % % % % % % % % % % % % % % % % % % % %

%This might replace Functional_Figure_Crafting but will be more specialized

function [FigureMatrix] =get_AtlasFigure(AtlasImg, slices, direction)

s=size(slices);
Spacing=zeros(256,20);

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

FigureMatrix(FigureMatrix==0)=NaN;
[FigureMatrix] =get_RefinedFigure(FigureMatrix);

end