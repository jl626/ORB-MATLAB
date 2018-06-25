function [cnr, br] = orb(im, npts, scale)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MATLAB implementation of Oriented FAST rotated BRIEF (ORB) 
%
%   Inputs - im : input image
%            npts: number of ORB feature points to be extracted (default
%            500)
%            scale : a vector of image scales (ORB is not scale invariant,
%            so ORB needs to be computed from different scales of the input
%            image
%           
%   Outputs - cnr : the coordinates of ORB features
%             br  : BRIEF feature descriptor corresponding to ORB features;
%
%
%
%                       Juheon Lee (21/06/2018)
%                       GNU public licence v 3.0 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if nargin < 3
    scale = [1, 0.75, 0.5, 0.25];
end

if nargin <2 
    npts = 500;
end

if nargin <1
    error('input image is needed to compute ORB');
end

im_grey = rgb2gray(im);
corner = [];
harris1 = [];
angle = [];

for i = 1:length(scale)
    if scale(i) == 1
        im2 = im;
    else
        im2 = imresize(im,scale(i));
    end
    im2_grey = rgb2gray(im2);

    % extract FAST corners and its score
    [corner2, fscore2] = fast9(im2_grey,20, 1);

    % non-maximal supression
    [corner2,fscore2] = FAST_filter(im2_grey,corner2,fscore2);

    % compute Harris corner score
    H2 = harris(im2_grey);
    harris2 = H2(sub2ind(size(H2),corner2(:,2),corner2(:,1)));
    
    % compute angle 
    angle2 = orientation(im2_grey,[corner2(:,2),corner2(:,1)]);
    
    corner = [corner;round(corner2*(1/scale(i)))];
    harris1 = [harris1;harris2];
    angle  = [angle; angle2];
end

% selected desired number of points 
[~,idx1] = sort(harris1);
cnr = corner(idx1(1:npts),:);
ang = angle(idx1(1:npts));

% compute rotational BRIEF (one can also use BRIEF)
run('sampling_param.m')
br = rBRIEF(im_grey,cnr,sample,ang);

