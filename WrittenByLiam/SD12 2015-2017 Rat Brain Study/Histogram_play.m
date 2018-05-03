close all
clc
clear

M=load_nii('rSD12_6_UTE3D_UTEscan5_MAGNITUDE_IMAGE_CORRECTED_CROPPED_METH2.nii');
N=load_nii('rSD12_6_UTE3D_UTEscan5_MAGNITUDE_IMAGE_CORRECTED_CROPPED_METH2_SSS-label.nii');

Mimg=double(M.img);Nimg=double(N.img);
Mimg=Mimg.*Nimg;
M.img=Mimg;

F=nonzeros(Mimg);
% F=log(F);
[a,b]=hist(F,100);
% plot(log(b),a,'*')
figure
plot(b,medfilt1(a,3),'*')
y(:,2)=medfilt1(a,3);
y(:,1)=b;
% figure
% plot(log(b),medfilt1(a,7),'*')
% figure
% plot(log(b),medfilt1(a,11),'*')