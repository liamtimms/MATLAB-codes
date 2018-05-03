function [CurrentStm] = get_nii_to_stm_Custom(CurrentNii)
%UNTITLED Summary of this function goes here
%   Adapted from code by Praveen (nii2stm)

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
fileprefix =strcat(dirName,'\',fileName11);
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
%nii.img= flipimg(nii.img);
fwrite(sdtfid,nii.img,datatype);

while nextfileExist
    
    fileNumber = fileNumber+1;
    
    if fileNumber<10
        tstr = sprintf('%d',fileNumber);
        tstr= strcat('00',tstr);
    elseif fileNumber<100
        tstr = sprintf('%d',fileNumber);
        tstr= strcat('0',tstr);
    else
        tstr = sprintf('%d',fileNumber);
    end   
    nfileprefix =(strcat(dirName,'\',fileName11,'_',tstr,'.nii'));
    %Check if file exist
    if ~exist(nfileprefix);
        nextfileExist =0;
        break;
    end
    new_nii = load_nii(nfileprefix);
    %new_nii.img=flipimg(new_nii.img);
    fwrite(sdtfid,new_nii.img,datatype);
    ntime=ntime+1; 
         
end

fclose(sdtfid);
WriteSPR(Endian,pdataType,sdtOrient,numDim,ncol,nrow,nslice,ntime,fovcol,fovrow, fovslice, delcol,delrow,delslice,fileprefix);
disp('Stimulate File written to the disk');

end

