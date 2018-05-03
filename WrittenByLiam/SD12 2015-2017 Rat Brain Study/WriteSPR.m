function WriteSPR(Endian,pdatatype,sdtOrient,numDim,ncol,nrow,nslice,ntime,fovcol,fovrow, fovslice, del_col,del_row,del_slice,fileprefix)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Written by: Praveen Kulkarni (prav304@gmail.com)
% Date:Dec 2nd, 2010 
% The function writes spr file
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% setting value
del_time = 1;
fovtime = 1;


if strcmp(pdatatype,'uint8')
     pdatatype = 'CHAR';
elseif strcmp(pdatatype,'int16')
    pdatatype = 'WORD';
elseif strcmp(pdatatype,'int32')
    pdatatype = 'LWORD';
elseif strcmp(pdatatype,'float32')
    pdatatype = 'REAL';
elseif strcmp(pdatatype,'real*8')
    pdatatype = 'REAL';
end

% Opening file
filename = strcat(fileprefix,'.spr');
fid = fopen(filename,'wt');
fprintf(fid,'numDim: %d\n', numDim);
fprintf(fid,'dim: %d %d %d %d\n',ncol,nrow,nslice,ntime);
fprintf(fid,'interval: %f %f %f %f\n',del_col,del_row,del_slice,del_time);
fprintf(fid,'fov: %f %f %f %f\n',fovcol,fovrow,fovslice,fovtime);
fprintf(fid,'sdtOrient: %s\n',sdtOrient);
fprintf(fid,'dataType: %s\n',pdatatype);
fprintf(fid,'endian: %s\n',Endian);
fclose(fid);





