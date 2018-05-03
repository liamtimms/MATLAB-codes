% % % % % % %  High Level Data Processing % % % % % % %
% % % % % % % %    Liam Timms 3/23/16   % % % % % % % %
% % % % % % % % % % % % % % % % % % % % % % % % % % % %


%% This doesn't really work.
% type='Measured';
type='TimeCalc';
n=1;

for i=1:1:4
    
    if i==1
        TotRegions=59;
    elseif i==2
        TotRegions=106;
    elseif i==3
        TotRegions=174;
    end
    
    reg_num=sprintf('%d', TotRegions);
    
    for j=2:1:5
        scn_num=sprintf('%d', j);
        name=strcat(reg_num, 'reg_', type, '_Scan', scn_num);
        DataObject1.Names{i,j}=name;
        DataObject1.Data{i,j}=load(strcat(name,'.mat'));
    end
    
end


%% Stability Analysis
i=1; %1 for 59 reg analysis

if i==1
    TotRegions=59;
elseif i==2
    TotRegions=106;
elseif i==3
    TotRegions=174;
end


for blah=1:1:4
    BaselineData=DataObject1.Data{i,4}.OutMatrix;
    j=blah+1;
    CurrentData=DataObject1.Data{i,j}.OutMatrix;
    for n=1:1:TotRegions
        for k=1:1:27
            relData=CurrentData(:,n,k);
            relData=nonzeros(relData);
            
            CoeffV(blah,n,k)=mean(relData)/std(relData);
            Average(blah,n,k)=mean(relData);
            for a=1:1:12
                PercentChange(a,n,k)=(CurrentData(a,n,k)-BaselineData(a,n,k))/BaselineData(a,n,k) *100;
            end
            relData=PercentChange(:,n,k);
            AveChange(blah,n,k)=mean(relData);
        end
    end
end

%%

p=1;

for blah=1:1:4
    for n=1:1:TotRegions
        clear relData
        
        relData(:)=CoeffV(blah,n,:);
        deriv1=diff(relData);
        deriv2=diff(deriv1);
        
        if p==1
            
            figure
            hold on
            plot(relData)
            plot(deriv1)
            plot(deriv2)
        end
        
        for k=2:1:25
            if deriv2(1,k)<0
                if relData(k)<relData(k+1) && relData(k)<relData(k+1)
                    minQuantTest(blah,n)=k;
                end
            end
            
        end
    end
    
end


%%

for n=1:1:TotRegions
    figure
    hold on
    for blah=1:1:4
        clear relData
        %         relData(:)=Average(blah,n,:);
        %         relData(:)=CoeffV(blah,n,:);
        
        relData(:)=AveChange(blah,n,:);
        plot(relData,'*')
        
        %         if blah==4
        %             relData(:)=CoeffV(blah,n,:);
        %             plot(relData)
        %         end
        %
    end
end

%% This doesn't really work.
% type='Measured';
type='APOE';
n=1;

for i=1:1:1
    
    if i==1
        TotRegions=59;
    elseif i==2
        TotRegions=106;
    elseif i==3
        TotRegions=174;
    end
    
    reg_num=sprintf('%d', TotRegions);
    
    for j=1:1:4
        if i==1
            model='WTM';
        elseif i==2
            model='WTF';
        elseif i==3
            model='APOEM';
        elseif i==3
            model='APOEF';
        end
        
        
        scn_num=sprintf('%d', j);
        name=strcat(reg_num, 'reg_', type, '_', model, '_data');
        DataObject2.Names{i,j}=name;
        DataObject2.Data{i,j}=load(strcat(name,'.mat'));
    end
    
end



%%
load('59reg_APOE_APOEF_data.mat')
FemA=zz;FemA=mean(FemA,1);FemA=squeeze(FemA);

load('59reg_APOE_WTF_data.mat')
Fem=zz;Fem=mean(Fem,1);Fem=squeeze(Fem);


close all
for i=1:1:59
    
    figure
    hold on
    plot((Fem(i,:)-FemA(i,:))./Fem(i,:).*100,'r*')
%     plot((Out1(i,:)-Out2(i,:))./Out2(i,:).*100,'b*')
    hold off
end

