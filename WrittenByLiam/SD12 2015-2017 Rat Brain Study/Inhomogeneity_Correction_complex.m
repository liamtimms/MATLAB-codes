%% MRI inhomogeneity Correction For Real and Imaginary (AKA Two Channel)

% You need to get the actual fit function and coefficeints from doing the 
% inhomogeneity characterization and then fitting a function to your data 
% using the "curve fitting" MATLAB app

function [Image_Corrected] = Inhomogeneity_Correction_complex(Image_Original, type)

%type 1 for real, type 2 for imaginary
if type==1
    
% REAL FIT
%Fit computation did not converge:
%Fit found when optimization terminated:
%Linear model Poly6:
%      f(x) = p1*x^6 + p2*x^5 + p3*x^4 + p4*x^3 + p5*x^2 + 
%                     p6*x + p7
% Coefficients (with 95% confidence bounds):
%        p1 =  -6.146e-12  (-6.279e-12, -6.014e-12)
%        p2 =   3.764e-09  (3.683e-09, 3.845e-09)
%        p3 =  -9.211e-07  (-9.408e-07, -9.015e-07)
%        p4 =   0.0001137  (0.0001113, 0.0001161)
%        p5 =   -0.007353  (-0.007504, -0.007201)
%        p6 =      0.2375  (0.2327, 0.2422)
%        p7 =      -2.299  (-2.355, -2.242)
% Goodness of fit:
%   SSE: 38.63
%   R-square: 0.9953
%   Adjusted R-square: 0.9953
%   RMSE: 0.1633

       p1 =  -6.146e-12;
       p2 =   3.764e-09;
       p3 =  -9.211e-07;
       p4 =   0.0001137;
       p5 =   -0.007353;
       p6 =      0.2375;
       p7 =      -2.299;
       
elseif type==2 
    
%IMAGINARY FIT
%Fit computation did not converge:
%Fit found when optimization terminated:
% 
% Linear model Poly6:
%      f(x) = p1*x^6 + p2*x^5 + p3*x^4 + p4*x^3 + p5*x^2 + 
%                     p6*x + p7
% Coefficients (with 95% confidence bounds):
%        p1 =   -7.42e-13  (-8.161e-13, -6.679e-13)
%        p2 =   4.082e-10  (3.647e-10, 4.517e-10)
%        p3 =  -9.005e-08  (-1e-07, -8.01e-08)
%        p4 =   1.047e-05  (9.35e-06, 1.16e-05)
%        p5 =  -0.0007158  (-0.0007804, -0.0006511)
%        p6 =     0.03056  (0.0288, 0.03232)
%        p7 =      0.2961  (0.2787, 0.3135)
% Goodness of fit:
%   SSE: 71.19
%   R-square: 0.9903
%   Adjusted R-square: 0.9903
%   RMSE: 0.2141

       p1 =   -7.42e-13;
       p2 =   4.082e-10;
       p3 =  -9.005e-08;
       p4 =   1.047e-05;
       p5 =  -0.0007158;
       p6 =     0.03056;
       p7 =      0.2961;
elseif type==3
    
% MAGNITUDE FIT    
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
       
       p1 =           0;
       p2 =           0;
       p3 =  -5.009e-09;
       p4 =   1.965e-06;
       p5 =  -0.0002875;
       p6 =     0.02103;
       p7 =      0.3065;
  
    
end
  


for i=1:1:200
    CorrectionFactor=1/(p1*i^6 + p2*i^5 + p3*i^4 + p4*i^3 + p5*i^2 + p6*i + p7);
    Image_Corrected(:,:,i)=Image_Original(:,:,i)*CorrectionFactor;
end



end