function [FigureMatrix] =get_RefinedFigure(FigureMatrix)
s=size(FigureMatrix);
FigureMatrix(isnan(FigureMatrix))=0;

emptyspace=10;
counter=emptyspace;
deleted=0;

% if s(2)>s(1)
    for i=1:1:s(2)
        
        c=sum(FigureMatrix(:,i-deleted));
        if c==0 && counter~=0
            counter=counter-1;
        elseif c~=0
            counter=emptyspace;
        else
            FigureMatrix(:,i-deleted)=[];
            deleted=deleted+1;
        end  
    end
    
% elseif s(1)>s(2)
    deleted=0;
    for i=1:1:s(1)
        c=sum(FigureMatrix(i-deleted,:));
        if c==0 && counter~=0
            counter=counter-1;
        elseif c~=0
            counter=emptyspace;
        else
            FigureMatrix(i-deleted,:)=[];
            deleted=deleted+1;
        end
    end
    
    
% end

FigureMatrix(FigureMatrix==0)=NaN;
end



