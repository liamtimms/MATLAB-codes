function firstTime = errorLog(errInfo, folder)
persistent niiFolder;
if nargin>1, firstTime = isempty(niiFolder); niiFolder = folder; end
if isempty(errInfo), return; end
fprintf(2, ' %s\n', errInfo); % red text in Command Window
fid = fopen([niiFolder 'dicm2nii_warningMsg.txt'], 'a');
fseek(fid, 0, -1); 
fprintf(fid, '%s\n', errInfo);
fclose(fid);