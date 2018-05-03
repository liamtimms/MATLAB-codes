function [A, M, S] = QuartileCut(Data)

Quartiles = quantile(Data,3);

Data(Data<Quartiles(1,1))=NaN;
Data(Data>Quartiles(1,3))=NaN;

A=nanmean(Data);
M=nanmedian(Data);
S=nanstd(Data);

end