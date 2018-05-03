function [] = get_nii_to_stm_Custom(CurrentNii, saveName)
%UNTITLED Summary of this function goes here
%   Adapted from code by Praveen (nii2stm)

CurrentNii.img=int32(CurrentNii.img*100); %this is to scale things to be percents
nii=CurrentNii;

ncol = nii.hdr.dime.dim(2);
nrow = nii.hdr.dime.dim(3);
nslice = nii.hdr.dime.dim(4);
ntime =1;
delcol = nii.hdr.dime.pixdim(2);
delrow = nii.hdr.dime.pixdim(3);
delslice= nii.hdr.dime.pixdim(4);
Endian= nii.machine;
sdtOrient='axis';
numDim =4;
fovcol =ncol*delcol;
fovrow =nrow*delrow;
fovslice=nslice*delslice;
fileprefix = saveName;
sdtfileName= strcat(fileprefix,'.sdt');

switch nii.hdr.dime.datatype
    case 1
        % no equvalent in matlab for single bit
    case 2
        datatype = 'uint8';
        pdataType = 'CHAR';
    case 4
        datatype = 'int16';
        pdataType = 'WORD';
    case 8
        datatype = 'int32';
        pdataType = 'LWORD';
    case 16
        datatype = 'float32';
        pdataType = 'REAL';
    case 32
        % 32 Complex :- No such type in matlab
    case 64
        datatype = 'real*8';
        pdataType = 'REAL';
        %  New way of decribing datatype.
        
    case 256
        datatype = 'uint8';
        pdataType = 'CHAR';
    case 512
        datatype = 'int16';
        pdataType = 'WORD';
    case 768
        datatype = 'int32';
        pdataType = 'LWORD';
        
end

% newimg= int16(nii.img);
% pdataType = 'WORD';

nextfileExist =1;
sdtfid = fopen(sdtfileName,'wb',Endian);
nii.img= flipimg(nii.img);
fwrite(sdtfid,nii.img,datatype);

fclose(sdtfid);
WriteSPR(Endian,pdataType,sdtOrient,numDim,ncol,nrow,nslice,ntime,fovcol,fovrow, fovslice, delcol,delrow,delslice,fileprefix);
disp('Stimulate File written to the disk');

end

function img= flipimg(niiimg)
[a b c]=size(niiimg);
img(a,b,c)=0;
for k=1:c
    for j=1:b
        jj=b-j+1;
        for i=1:a
            ii=a-i+1;
            img(ii,jj,k)=niiimg(i,j,k);
        end
    end
end

end