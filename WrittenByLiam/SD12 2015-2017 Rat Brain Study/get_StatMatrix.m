function [M_STAT] =get_StatMatrix(TotRegions, CBVorCPs)

alpha=0.05;

M1=zeros(TotRegions,12);M2=zeros(TotRegions,12);M3=zeros(TotRegions,12);M4=zeros(TotRegions,12);

for i=1:1:12
    anNum=sprintf('%d',i);
    if i==7
        M1(:,i)=CBVorCPs(i,4,:);
        M2(:,i)=CBVorCPs(i,5,:);
        M3(:,i)=CBVorCPs(i,6,:);
        M4(:,i)=CBVorCPs(i,7,:);
    elseif i==12
        M1(:,i)=CBVorCPs(i,3,:);
        M2(:,i)=CBVorCPs(i,4,:);
        M3(:,i)=CBVorCPs(i,5,:);
        M4(:,i)=CBVorCPs(i,6,:);
    else
        M1(:,i)=CBVorCPs(i,2,:);
        M2(:,i)=CBVorCPs(i,3,:);
        M3(:,i)=CBVorCPs(i,4,:);
        M4(:,i)=CBVorCPs(i,5,:);
    end
    
end

for j=1:1:TotRegions
    
    M_STAT(j,1)= mean(nonzeros(M1(j,:))); % column 1-8 are m,s for grp 1-4
    M_STAT(j,2)= std(nonzeros(M1(j,:)));
    M_STAT(j,3)= mean(nonzeros(M2(j,:)));
    M_STAT(j,4)= std(nonzeros(M2(j,:)));
    M_STAT(j,5)= mean(nonzeros(M3(j,:)));
    M_STAT(j,6)= std(nonzeros(M3(j,:)));
    M_STAT(j,7)= mean(nonzeros(M4(j,:)));
    M_STAT(j,8)= std(nonzeros(M4(j,:)));
    
    
    x1=M1(j,:); y1=M3(j,:); % compare Awake1 vs. Awake2
    x2=M1(j,:); y2=M2(j,:); % compare Awake1 vs. CO2
    x3=M1(j,:); y3=M4(j,:); % compare Awake1 vs. Anesth
    x4=M3(j,:); y4=M2(j,:); % compare Awake2 vs. CO2
    x5=M3(j,:); y5=M4(j,:); % compare Awake2 vs. Anesth
    x6=M2(j,:); y6=M4(j,:); % compare CO2 vs. Anesth
    
    [h1,p1]=ttest2(x1,y1,'alpha',alpha);
    [h2,p2]=ttest2(x2,y2,'alpha',alpha);
    [h3,p3]=ttest2(x3,y3,'alpha',alpha);
    [h4,p4]=ttest2(x4,y4,'alpha',alpha);
    [h5,p5]=ttest2(x5,y5,'alpha',alpha);
    [h6,p6]=ttest2(x6,y6,'alpha',alpha);
    
    % Perform t-test per region for 4 comparisons
    % N=size(Data);
    %
    % if N==[0,1]
    %     fprintf('Empty Region')
    %     I_peak=0;
    %     I_peak_std=0;
    %     I_avg=0;
    %     I_std=0;
    %     GOF=0;
    % else
    
    M_STAT(j,9)=p1;      %M_STAT columns 9-12 are p-values for comparisons
    M_STAT(j,10)=p2;
    M_STAT(j,11)=p3;
    M_STAT(j,12)=p4;
    M_STAT(j,13)=p5;
    M_STAT(j,14)=p6;
    
    M_STAT(j,15)=h1; %M_STAT columns 9-12 are 1s or 0s for same/ notsame
    M_STAT(j,16)=h2;
    M_STAT(j,17)=h3;
    M_STAT(j,18)=h4;
    M_STAT(j,19)=h5;
    M_STAT(j,20)=h6;
end

idx = find(isnan(M_STAT));
if(~isempty(idx))
    M_STAT(idx) = 0;
end

end