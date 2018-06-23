function T = GeometricTest(feature1,feature2)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Check geometric consistency of randomly selected points (it helps to
%   accelerate ransac algorithm
%   
%   Inputs - Feature1 : 4 randomly chosen source points
%            Feature2 : 4 randomly chosen destination points
%
%   Outputs- T : logical indicator that 4 randomly selected points are
%   geometrically consistent. 
%
%   Ref. Marquez-Neila et al. "Speeding-up homography estimation in mobile devices"
%                           Juheon Lee  (21/06/2018)
%                       Feel free to redistribute!
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if size(feature1,1) ~= 4 || size(feature2,1) ~= 4
    error('The size of each point set must be 4')
end

M = [1 2 3; 1 2 4; 1 3 4; 2 3 4]; % all possible combinations
v = zeros(4,1); % indication vector

for i = 1:4
    A = [feature1(M(i,1),1),feature1(M(i,1),2),1; ...
         feature1(M(i,2),1),feature1(M(i,2),2),1; ...
         feature1(M(i,3),1),feature1(M(i,3),2),1;];
    B = [feature2(M(i,1),1),feature2(M(i,1),2),1; ...
         feature2(M(i,2),1),feature2(M(i,2),2),1; ...
         feature2(M(i,3),1),feature2(M(i,3),2),1;];
    v(i) = det(A)*det(B)<0;
end

if (sum(v) == 0 || sum(v) == 4)
    T = true;
else
    T = false;
end