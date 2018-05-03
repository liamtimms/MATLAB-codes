function out = writeSDT(Image, hdr,fileprefix)
% *********************************************************************
% This function writes spr header files and then write sdt image file.
% Input to the program is Image matrix, header structure (hdr) and filename.
% 
% Output is 3D or 4D image and hdr
%**********************************************************************

% setting value
del_time = 1;
fovtime = 1;


if strcmp(hdr.datatype,'uint8')
     pdatatype = 'CHAR';
elseif strcmp(hdr.datatype,'int16')
    pdatatype = 'WORD';
elseif strcmp(hdr.datatype,'int32')
    pdatatype = 'LWORD';
elseif strcmp(hdr.datatype,'float32')
    pdatatype = 'REAL';
elseif strcmp(hdr.datatype,'real*8')
    pdatatype = 'REAL';
end

hdr.fov_col=double(hdr.ncol)*hdr.dcol;
hdr.fov_row=double(hdr.nrow)*hdr.drow;
hdr.fov_slice=double(hdr.nslice)*hdr.dslice;
hdr.fov_time=1;
hdr.dtime=1;

% Opening SPR file
sprfilename = strcat(fileprefix,'.spr');
fid = fopen(sprfilename,'wt');
fprintf(fid,'numDim: %d\n', hdr.numdim);
fprintf(fid,'dim: %d %d %d %d\n',hdr.ncol,hdr.nrow,hdr.nslice,hdr.ntime);
fprintf(fid,'interval: %f %f %f %f\n',hdr.dcol,hdr.drow,hdr.dslice,hdr.dtime);
fprintf(fid,'fov: %f %f %f %f\n',hdr.fov_col,hdr.fov_row,hdr.fov_slice,hdr.fov_time);
fprintf(fid,'sdtOrient: %s\n',hdr.orient);
fprintf(fid,'dataType: %s\n',pdatatype);
fprintf(fid,'endian: %s\n',hdr.endian);
fclose(fid);

% Open SDT file
sdtfilename = strcat(fileprefix,'.sdt');
fid = fopen(sdtfilename,'wb');

if hdr.ntime ==1
    for k =1: hdr.nslice
        fwrite(fid,Image(:,:,k),hdr.datatype);
    end
elseif hdr.ntime>1
    for t =1:hdr.ntime
        for k =1: hdr.nslice
        fwrite(fid,Image(:,:,k,t),hdr.datatype);
        end
    end
else
    disp('No time information,Image information is correpted');
end
fclose(fid);


end % end of function 

