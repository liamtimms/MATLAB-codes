%% Subfuction: create GUI or bring it to front if exists
function create_gui
fh = figure('dicm' * 256.^(0:3)'); % arbitury integer
if strcmp('dicm2nii_fig', get(fh, 'Tag')), return; end

scrSz = get(0, 'ScreenSize');
fSz = 9 + isunix * 2;
clr = [1 1 1]*206/256;
clrButton = [1 1 1]*216/256;
cb = @(cmd) {@gui_callback cmd fh}; % callback shortcut
uitxt = @(txt,pos) uicontrol('Style', 'text', 'Position', pos, ...
    'FontSize', fSz, ...
    'HorizontalAlignment', 'left', 'String', txt, 'BackgroundColor', clr);
getpf = @(p,dft)getpref('dicm2nii_gui_para', p, dft);
chkbox = @(parent,val,str,cbk,tip) uicontrol(parent, 'Style', 'checkbox', ...
    'FontSize', fSz, 'HorizontalAlignment', 'left', 'BackgroundColor', clr, ...
    'Value', val, 'String', str, 'Callback', cbk, 'TooltipString', tip);

set(fh, 'Toolbar', 'none', 'Menubar', 'none', 'Resize', 'off', 'Color', clr, ...
    'Tag', 'dicm2nii_fig', 'Position', [200 scrSz(4)-600 420 300], ...
    'Name', 'dicm2nii - DICOM to NIfTI Converter', 'NumberTitle', 'off');

uitxt('Browse source', [8 274 88 16]);
uicontrol('Style', 'Pushbutton', 'Position', [98 270 48 24], ...
    'FontSize', fSz, 'String', 'Folder', 'Background', clrButton, ...
    'TooltipString', ['Browse source folder (can have subfolders) containing' ...
    ' convertible files'], 'Callback', cb('srcDir'));
uitxt('or', [148 274 20 16]);
uicontrol('Style', 'Pushbutton', 'Position', [166 270 48 24], 'FontSize', fSz, ...
    'String', 'File(s)', 'Background', clrButton, 'Callback', cb('srcFile'), ...
    'TooltipString', ['Browse convertible file(s), such as dicom, Philips PAR,' ...
    ' AFNI HEAD, BrainVoyager files, or a zip file containing those files']);
uitxt('or drag&drop source folder/file(s)', [216 274 200 16]);

uitxt('Source folder/files', [8 238 110 16]);
jSrc = javaObjectEDT('javax.swing.JTextField');
hs.src = javacomponent(jSrc, [114 234 294 24], fh);
hs.src.FocusLostCallback = cb('set_src');
hs.src.Text = getpf('src', pwd);
% hs.src.ActionPerformedCallback = cb('set_src'); % fire when pressing ENTER
hs.src.ToolTipText = ['<html>This is the source folder or file(s). You can<br>' ...
    'Type the source folder name into the box, or<br>' ...
    'Click Folder or File(s) button above to set the value, or<br>' ...
    'Drag and drop a folder or file(s) into the box'];

uicontrol('Style', 'Pushbutton', 'Position', [8 198 104 24], ...
    'FontSize', fSz, 'String', 'Result folder', 'Background', clrButton, ...
    'TooltipString', 'Browse result folder', 'Callback', cb('dstDialog'));
jDst = javaObjectEDT('javax.swing.JTextField');
hs.dst = javacomponent(jDst, [114 198 294 24], fh);
hs.dst.FocusLostCallback = cb('set_dst');
hs.dst.Text = getpf('dst', pwd);
hs.dst.ToolTipText = ['<html>This is the result folder name. You can<br>' ...
    'Type the folder name into the box, or<br>' ...
    'Click Result folder button to set the value, or<br>' ...
    'Drag and drop a folder into the box'];

uitxt('Output format', [8 166 82 16]);
hs.rstFmt = uicontrol('Style', 'popup', 'Background', 'white', 'FontSize', fSz, ...
    'Value', getpf('rstFmt',1), 'Position', [92 162 80 24], 'String', ' .nii| .hdr/.img', ...
    'TooltipString', 'Choose output file format');

hs.gzip = chkbox(fh, getpf('gzip',true), 'Compress', '', 'Compress into .gz files');
sz = get(hs.gzip, 'Extent'); set(hs.gzip, 'Position', [220 166 sz(3)+16 sz(4)]);

hs.rst3D = chkbox(fh, getpf('rst3D',false), 'SPM 3D', cb('SPMStyle'), ...
    'Save one file for each volume (SPM style)');
sz = get(hs.rst3D, 'Extent'); set(hs.rst3D, 'Position', [330 166 sz(3)+16 sz(4)]);
           
hs.convert = uicontrol('Style', 'pushbutton', 'Position', [104 8 200 30], ...
    'FontSize', fSz, 'String', 'Start conversion', ...
    'Background', clrButton, 'Callback', cb('do_convert'), ...
    'TooltipString', 'Dicom source and Result folder needed before start');

hs.about = uicontrol('Style', 'popup', ...
    'String', 'About|License|Help text|Check update|A paper about conversion', ...
    'Position', [342 12 72 20], 'Callback', cb('about'));

ph = uipanel(fh, 'Units', 'Pixels', 'Position', [4 50 410 102], 'FontSize', fSz, ...
    'BackgroundColor', clr, 'Title', 'Preferences (also apply to command line and future sessions)');
setpf = @(p)['setpref(''dicm2nii_gui_para'',''' p ''',get(gcbo,''Value''));'];

p = 'lefthand';
h = chkbox(ph, getpf(p,true), 'Left-hand storage', setpf(p), ...
    'Left hand storage works well for FSL, and likely doesn''t matter for others');
sz = get(h, 'Extent'); set(h, 'Position', [4 60 sz(3)+16 sz(4)]);

p = 'save_patientName';
h = chkbox(ph, getpf(p,true), 'Store PatientName', setpf(p), ...
    'Store PatientName in NIfTI hdr, ext and json');
sz = get(h, 'Extent'); set(h, 'Position', [180 60 sz(3)+16 sz(4)]);

p = 'use_parfor';
h = chkbox(ph, getpf(p,true), 'Use parfor if needed', setpf(p), ...
    'Converter will start parallel tool if necessary');
sz = get(h, 'Extent'); set(h, 'Position', [4 36 sz(3)+16 sz(4)]);

p = 'use_seriesUID';
h = chkbox(ph, getpf(p,true), 'Use SeriesInstanceUID if exists', setpf(p), ...
    'Only uncheck this if SeriesInstanceUID is messed up by some third party archive software');
sz = get(h, 'Extent'); set(h, 'Position', [180 36 sz(3)+16 sz(4)]);

p = 'save_json';
h = chkbox(ph, getpf(p,false), 'Save json file', setpf(p), ...
    'Save json file for BIDS (http://bids.neuroimaging.io/)');
sz = get(h, 'Extent'); set(h, 'Position', [4 12 sz(3)+16 sz(4)]);

hs.fig = fh;
guidata(fh, hs); % store handles
set(fh, 'HandleVisibility', 'callback'); % protect from command line

try % java_dnd is based on dndcontrol by Maarten van der Seijs
    java_dnd(jSrc, cb('drop_src'));
    java_dnd(jDst, cb('drop_dst'));
catch me
    fprintf(2, '%s\n', me.message);
end

gui_callback([], [], 'set_src', fh);

