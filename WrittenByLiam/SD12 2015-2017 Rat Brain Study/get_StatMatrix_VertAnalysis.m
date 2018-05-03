function [M_STAT] =get_StatMatrix_VertAnalysis(TotRegions, CBVorCPs)

% this is not done at all really


alpha=0.05;

M=zeros(12,4,TotRegions);

CBVorCPs(isnan(CBVorCPs))=0;

for i=1:1:12
    if i==7
        skip=2;
    elseif i==12
        skip=1;
    else
        skip=0;
    end
    
    for j=2:1:5
        M(i,j-1,:)=CBVorCPs(i,j+skip,:);
    end
end


for i=1:1:12
    for n=1:1:TotRegions
        
        M(i,1,n)
        
        %     k=1;
        %     for j=1:2:7
        %         M_STAT(n,j)= mean(nonzeros(M(:,k,n))); % column 1-8 are m,s for grp 1-4
        %         M_STAT(n,j+1)= std(nonzeros(M(:,k,n)));
        %         k=k+1;
        %     end
        %
        %     M_STAT(isnan(M_STAT))=0;
        %
        %     problem=0;
        %
        %     for l=1:1:4
        %         test=nonzeros(M(:,l,n));
        %         if size(test) ~= [12, 1]
        %             problem=1;
        %         end
        %     end
        %
        %     if problem==1
        %         fprintf('Region %d skipped \n', n)
        %         h1=0;
        %         h2=0;
        %         h3=0;
        %         h4=0;
        %         h5=0;
        %         h6=0;
        %         p1=0;
        %         p2=0;
        %         p3=0;
        %         p4=0;
        %         p5=0;
        %         p6=0;
        %
        %
        %
        %     else
        %         [h1,p1]=ttest2(M(:,1,n),M(:,3,n),'alpha',alpha); % compare Awake1 vs. Awake2
        %         [h2,p2]=ttest2(M(:,1,n),M(:,2,n),'alpha',alpha); % compare Awake1 vs. CO2
        %         [h3,p3]=ttest2(M(:,1,n),M(:,4,n),'alpha',alpha); % compare Awake1 vs. Anesth
        %         [h4,p4]=ttest2(M(:,3,n),M(:,2,n),'alpha',alpha); % compare Awake2 vs. CO2
        %         [h5,p5]=ttest2(M(:,3,n),M(:,4,n),'alpha',alpha); % compare Awake2 vs. Anesth
        %         [h6,p6]=ttest2(M(:,2,n),M(:,4,n),'alpha',alpha); % compare CO2 vs. Anesth
        %     end
        %
        %     M_STAT(n,9)=p1;  %M_STAT columns 9-12 are p-values for comparisons
        %     M_STAT(n,10)=p2;
        %     M_STAT(n,11)=p3;
        %     M_STAT(n,12)=p4;
        %     M_STAT(n,13)=p5;
        %     M_STAT(n,14)=p6;
        %
        %     M_STAT(n,15)=h1; %M_STAT columns 9-12 are 1s or 0s for same/ notsame
        %     M_STAT(n,16)=h2;
        %     M_STAT(n,17)=h3;
        %     M_STAT(n,18)=h4;
        %     M_STAT(n,19)=h5;
        %     M_STAT(j,20)=h6;
        %
    end
end

end