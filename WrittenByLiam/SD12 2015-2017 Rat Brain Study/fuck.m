folder='matlab_generated_intensity_distributions\';

s=size(reg_vector);
for n=1:1:s(1)
    figure
    hold on
    k=reg_vector(n);
    r=sprintf('%d', k);
    ns=sprintf('%d', n);
    
%     temp=cell2mat(myDataHistNormSmushed(3,k));
%     if ~isempty(temp)
%         plot(temp(:,2),temp(:,1))
%     end
    temp=cell2mat(myDataHistNormSmushed(4,k));
    if ~isempty(temp)
        plot(temp(:,2),temp(:,1))
    end
    
%     
%     temp=cell2mat(myDataHistNormSmushed(5,k));
%     if ~isempty(temp)
%         plot(temp(:,2),temp(:,1))
%     end
    
    if MMDiffMean(2,k)
    filename=strcat(folder,'Fig', ns, 'rSD12_DistributionAwake_Region',r,'.jpg');
    
    saveas(gcf, filename);
    
    hold off
    
end