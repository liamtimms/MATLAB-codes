%% MRI inhomogeneity Correction

% You need to get the actual fit function and coefficeints from doing the 
% inhomogeneity characterization and then fitting a function to your data 
% using the "curve fitting" MATLAB app

% Fit found when optimization terminated:

% Linear model Poly4:
%      f(x) = p1*x^4 + p2*x^3 + p3*x^2 + p4*x + p5
% Coefficients (with 95% confidence bounds):
%        p1 =  -5.009e-09  (-5.104e-09, -4.913e-09)
%        p2 =   1.965e-06  (1.927e-06, 2.002e-06)
%        p3 =  -0.0002875  (-0.0002926, -0.0002823)
%        p4 =     0.02103  (0.02074, 0.02132)
%        p5 =      0.3065  (0.3011, 0.3119)

% Goodness of fit:
%   SSE: 1.182e-05
%   R-square: 0.9973
%   Adjusted R-square: 0.9973
%   RMSE: 8.569e-05

function [CorrectedData] = Inhomogeneity_Correction(filename)

p1 =  -5.009e-09;
p2 =   1.965e-06;
p3 =  -0.0002875;
p4 =     0.02103;
p5 =      0.3065;

Raw_Data=load_nii(filename);
Raw_image=double(Raw_Data.img);

for i=1:1:200
    ZCorrectionFactor(i)=1/(p1*i^4 + p2*i^3 + p3*i^2 + p4*i + p5);
    CorrectedImage(:,:,i)=Raw_image(:,:,i)*ZCorrectionFactor(i);
end

CorrectedData=Raw_Data;
CorrectedData.img=CorrectedImage;

end