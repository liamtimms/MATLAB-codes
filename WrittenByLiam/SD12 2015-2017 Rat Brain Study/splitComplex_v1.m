%% Taking Complex Image File and Splitting it into Real and Imaginary Image Files

function [I_peak, I_avg, I_std] =SplitComplex(image, mask)
anNum='1';
    
scanNum=sprintf('%d',i);
% Manipulating Complex image files

M=load_nii(strcat('SD12_',anNum,'_Rat_UTE',scanNum,'_complex_scaled.nii'));
M.hdr.dime.dim=[4 200 200 200 1 1 1 1];

M1=double(M.img);M1=M1(:,:,1:200);
M2=double(M.img);M2=M2(:,:,201:400);

saveName1=strcat('SD12_',anNum,'_Rat_UTE',scanNum,'_imaginary_scaled.nii');
saveName2=strcat('SD12_',anNum,'_Rat_UTE',scanNum,'_real_scaled.nii');

M.img=M1;save_nii(M,saveName1);
M.img=M2;save_nii(M,saveName2);

end