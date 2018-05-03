%% Get the last date string in history
function dStr = reviseDate(mfile)
if nargin<1, mfile = mfilename; end
dStr = '161231?';
fid = fopen(which(mfile));
if fid<1, return; end
str = fread(fid, '*char')';
fclose(fid);
str = regexp(str, '\n% (\d{6}) ', 'tokens');
if isempty(str), return; end
dStr = str{end}{1};