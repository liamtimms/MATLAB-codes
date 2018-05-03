clear
close all
clc

src='E:\Backup And Sync\unshared research\Human B1 Work\Just B1\20171108_Patient_0\_SCAN2_20171108_17_11_08-12_20_43-STD-1_3_12_2_1107_5_2_43_67026\INVESTIGATORS_GHARAGOUZLOO_20171108_122139_648000';
% src='E:\Backup And Sync\unshared research\Human B1 Work\20171108_Patient_0\IENT_0_20171108_17_11_08-06_54_28-STD-1_3_12_2_1107_5_2_43_67026\INVESTIGATORS_GHARAGOUZLOO_20171108_071751_285000';
niiFolder='E:\Backup And Sync\unshared research\Human B1 Work\Just B1\20171108_Patient_0\_SCAN2_20171108_17_11_08-12_20_43-STD-1_3_12_2_1107_5_2_43_67026\Nii';
%%

fmt=[];
nargin=2;

if nargout, varargout{1} = ''; end
if nargin==3 && ischar(fmt) && strcmp(fmt, 'func_handle') % special purpose
    varargout{1} = str2func(niiFolder);
    return;
end

% Deal with output format first, and error out if invalid
if nargin<3 || isempty(fmt), fmt = 1; end % default .nii.gz
no_save = ischar(fmt) && strcmp(fmt, 'no_save');
if no_save, fmt = 'nii'; end

if (isnumeric(fmt) && any(fmt==[0 1 4 5])) || ...
      (ischar(fmt) && ~isempty(regexpi(fmt, 'nii')))
    ext = '.nii';
elseif (isnumeric(fmt) && any(fmt==[2 3 6 7])) || (ischar(fmt) && ...
        (~isempty(regexpi(fmt, 'hdr')) || ~isempty(regexpi(fmt, 'img'))))
    ext = '.img';
else
    error(' Invalid output file format (the 3rd input).');
end

if (isnumeric(fmt) && mod(fmt,2)) || (ischar(fmt) && ~isempty(regexpi(fmt, '.gz')))
    ext = [ext '.gz']; % gzip file
end

rst3D = (isnumeric(fmt) && fmt>3) || (ischar(fmt) && ~isempty(regexpi(fmt, '3D')));


% Deal with data source
if nargin<1 || isempty(src) || (nargin<2 || isempty(niiFolder))
    create_gui; % show GUI if input is not enough
    return;
end

pf.save_patientName = getpref('dicm2nii_gui_para', 'save_patientName', true);
pf.save_json = getpref('dicm2nii_gui_para', 'save_json', false);
pf.use_parfor = getpref('dicm2nii_gui_para', 'use_parfor', true);
pf.use_seriesUID = getpref('dicm2nii_gui_para', 'use_seriesUID', true);
pf.lefthand = getpref('dicm2nii_gui_para', 'lefthand', true);

tic;
unzip_cmd = '';
if iscellstr(src) && numel(src)==1, src = src{1}; end
if isnumeric(src)
    error('Invalid dicom source.');    
elseif iscellstr(src) % multiple files
    dcmFolder = folderFromFile(src{1});
    n = numel(src);
    fnames = src;
    for i = 1:n
        foo = dir(src{i});
        if isempty(foo), error('%s does not exist.', src{i}); end
        fnames{i} = fullfile(dcmFolder, foo.name); 
    end
elseif ~exist(src, 'file') % like input: run1*.dcm
    fnames = dir(src);
    if isempty(fnames), error('%s does not exist.', src); end
    fnames([fnames.isdir]) = [];
    dcmFolder = folderFromFile(src);
    fnames = strcat(dcmFolder, filesep, {fnames.name});    
elseif isdir(src) % folder
    dcmFolder = src;
elseif ischar(src) % 1 dicom or zip/tgz file
    dcmFolder = folderFromFile(src);
    unzip_cmd = compress_func(src);
    if isempty(unzip_cmd)
        fnames = dir(src);
        fnames = strcat(dcmFolder, filesep, {fnames.name});
    end
else 
    error('Unknown dicom source.');
end
dcmFolder = fullfile(getfield(what(dcmFolder), 'path'));


% Deal with niiFolder
if ~isdir(niiFolder), mkdir(niiFolder); end
niiFolder = fullfile([getfield(what(niiFolder), 'path') filesep]);
converter = ['dicm2nii.m 20' reviseDate];
if errorLog('', niiFolder) && ~no_save % remember niiFolder for later call
    more off;
    disp(['Xiangrui Li''s ' converter ' (feedback to xiangrui.li@gmail.com)']);
end

% Unzip if compressed file is the source
if ~isempty(unzip_cmd)
    [~, fname, ext1] = fileparts(src);
    dcmFolder = sprintf('%stmpDcm%s/', niiFolder, fname);
    if ~isdir(dcmFolder)
        mkdir(dcmFolder);
        delTmpDir = onCleanup(@() rmdir(dcmFolder, 's')); %may want to keep this?
    end
    disp(['Extracting files from ' fname ext1 ' ...']);

    if strcmp(unzip_cmd, 'unzip')
        cmd = sprintf('unzip -qq -o %s -d %s', src, dcmFolder);
        err = system(cmd); % first try system unzip
        if err, unzip(src, dcmFolder); end % Matlab's unzip is too slow
    elseif strcmp(unzip_cmd, 'untar')
        if isempty(which('untar')), error('No untar found in matlab path.'); end
        untar(src, dcmFolder);
    end
    drawnow;
end 


% Get all file names including those in subfolders, if not specified
if ~exist('fnames', 'var')
    dirs = genpath(dcmFolder);
    dirs = textscan(dirs, '%s', 'Delimiter', pathsep);
    dirs = dirs{1}; % cell str
    fnames = {};
    for i = 1:numel(dirs)
        curFolder = [dirs{i} filesep];
        foo = dir(curFolder); % all files and folders
        foo([foo.isdir]) = []; % remove folders
        foo = strcat(curFolder, {foo.name});
        fnames = [fnames foo]; %#ok<*AGROW>
    end
end
nFile = numel(fnames);
if nFile<1, error(' No files found in the data source.'); end



% Check each file, store partial header in cell array hh
% first 3 fields are must. First 10 indexed in code
flds = {'Columns' 'Rows' 'BitsAllocated' 'SeriesInstanceUID' 'SeriesNumber' ...
    'ImageOrientationPatient' 'ImagePositionPatient' 'PixelSpacing' ...
    'SliceThickness' 'SpacingBetweenSlices' ... % these 10 indexed in code
    'PixelRepresentation' 'BitsStored' 'HighBit' 'SamplesPerPixel' ...
    'PlanarConfiguration' 'EchoNumber' 'RescaleIntercept' 'RescaleSlope' ...
    'InstanceNumber' 'NumberOfFrames' 'B_value' 'DiffusionGradientDirection' ...
    'RTIA_timer' 'RBMoCoTrans' 'RBMoCoRot'};
dict = dicm_dict('SIEMENS', flds); % dicm_hdr will update vendor if needed

% read header for all files, use parpool if available and worthy
if ~no_save, fprintf('Validating %g files ...\n', nFile); end
hh = cell(1, nFile); errStr = cell(1, nFile);
doParFor = pf.use_parfor && nFile>2000 && useParTool;
for k = 1:nFile
    [hh{k}, errStr{k}, dict] = dicm_hdr(fnames{k}, dict);
    if doParFor && ~isempty(hh{k}) % parfor wont allow updating dict
        parfor i = k+1:nFile
            [hh{i}, errStr{i}] = dicm_hdr(fnames{i}, dict); 
        end
        break; 
    end
end

s=size(hh);
d=hh{1,2}.SliceThickness(1,1);
% d=16;
for k=3:s(2)-1
    if ~isempty(hh{k}) && ~isempty(hh{k-1})
        k
        hh{1,k}.ImagePositionPatient(3,1)= hh{1,(k-1)}.ImagePositionPatient(3,1)+d;
    end
end
