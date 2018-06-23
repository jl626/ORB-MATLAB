function [val,loc] = compute_reproj_error(pts1,pts2,H,thres)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Compute Homography reprojection error
% 
%   Inputs - pts1 : points from frame 1
%            pts2 : corresponding points in frame 2
%            H : Homography matrix
%            thres: threshold for inliers
%
%   Output- val : mean reprojection error in L2 distance (euclidean metric)
%           loc : index for inliears
%
%                       Juheon Lee (21/06/2018)
%               Feel Free to redistribute! 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if nargin <4
   thres = 3;
end

leng = size(pts1,1);
val = zeros(leng,1);

for i = 1:leng
    % compute reprojection 
    xp = (pts1(i,1)* H(1,1)  + pts1(i,2) * H(1,2) + H(1,3))/(pts1(i,1) * H(3,1) + pts1(i,2) * H(3,2) + H(3,3));
    yp = (pts1(i,1)* H(2,1)  + pts1(i,2) * H(2,2) + H(2,3))/(pts1(i,1) * H(3,1) + pts1(i,2) * H(3,2) + H(3,3));
    % compute euclidean reprojection error
    val(i) = sqrt((xp - pts2(i,1))^2 + (yp - pts2(i,2))^2); 
end

loc = find(val < thres);
