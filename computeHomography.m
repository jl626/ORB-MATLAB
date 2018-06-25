function [H,inlr_loc] = computeHomography(feature1,feature2, thres, maxiter)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Estimate Homography matrix using RANdom SAmple Consensus &
%   Levenberg-Marquardt method
%   inputs - feature1: matched points in frame 1 
%            feature2: matched points in frame 2
%            thres   : inlier threshold (default 3)
%            maxiter : max itermation (default 1000)
%
%   output - H: Homography matrix
%
%                    Juheon Lee (21/06/2018) 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Random seed
rng(3143254)

pval = 0.99; % confidence parameter for dynamic update
isnormal = 1; % direct linear transform is commited with normalisation 
cinlr = 0; % the number of inliers at current iteration
inlr_loc = []; % index of inliers

for i = 1:maxiter % dynamic iteration
    
    % select 4 random points
    pts = randperm(size(feature1,1),4); % random permutation of N integers
    pts1 = feature1(pts,:);
    pts2 = feature2(pts,:);
    
    % check geometric constraint of the selected points
    T = GeometricTest(pts1,pts2);
    if (T == 0); continue; end % random points does not satisfy geometric constraints
    
    % direct linear transform for estimating homography matrix
    Htmp = homography(pts1,pts2,0);

    % calculate reprojection error
    [~,loc] = compute_reproj_error(feature1,feature2,Htmp,thres);
    
    % dynamic update 
    if length(loc) > cinlr
        cinlr = length(loc); % update the number of inliers
        H = Htmp; % update homography matrix
        inlr_loc = loc;
        maxiter = ransacIter(pval,cinlr,maxiter); % update iteration number (maximum 1000)
    end
end
H = H;
% optional Levenberg-Marquardt optimisation 