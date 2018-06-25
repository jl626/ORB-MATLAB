% Read images
im1 = imread('IMG_7895.JPG');
im2 = imread('IMG_7894.JPG');

scale = [1, 0.75, 0.5, 0.25];

tic;
im1 = imresize(im1,0.5);
im1_grey = rgb2gray(im1);
im2 = imresize(im2,0.5);
im2_grey = rgb2gray(im2);

% extract FAST corners and its score
[corner1, fscore1] = fast9(im1_grey,20, 1);
[corner2, fscore2] = fast9(im2_grey,20, 1);

% non-maximal supression
[corner1,fscore1] = FAST_filter(im1_grey,corner1,fscore1);
[corner2,fscore2] = FAST_filter(im2_grey,corner2,fscore2);

% compute Harris corner score
H1 = harris(im1_grey);
H2 = harris(im2_grey);
harris1 = H1(sub2ind(size(H1),corner1(:,2),corner1(:,1)));
harris2 = H2(sub2ind(size(H1),corner2(:,2),corner2(:,1)));

% refine FAST corners with harris scores
[~,idx1] = sort(harris1);
[~,idx2] = sort(harris2);
cnr1 = corner1(idx1(1:500),:);
cnr2 = corner2(idx2(1:500),:);

% get orientations for the selected points
angle1 = orientation(im1_grey,[cnr1(:,2),cnr1(:,1)]);
angle2 = orientation(im2_grey,[cnr2(:,2),cnr2(:,1)]);

% compute rotational BRIEF (one can also use BRIEF)
run('sampling_param.m')
br1 = rBRIEF(im1_grey,cnr1,sample,angle1);
br2 = rBRIEF(im2_grey,cnr2,sample,angle2);

% find matches 
matches = findmatches(br1,br2, cnr1, cnr2);

% matched points (note that there are a number of outliers!)
feature1 = matches(:,1:2);
feature2 = matches(:,3:4);
toc;

% RANdom SAmple Consensus (RANSAC) c.f. it is a necessary step to remove
% outliers!
[H,inlr] = computeHomography(feature1,feature2,3,1000);

% since MATLAB transposed x and y;
Hp = H';
tform = projective2d(Hp);
I = imwarp(im1,tform);

%figure(1);
%imshow(im1)
%hold on;plot(cnr1(:,1),cnr1(:,2),'r*')
%figure(2);
%imshow(im2)
%hold on;plot(cnr2(:,1),cnr2(:,2),'r*')
figure(3)
newImg = cat(2,im2,im1);
imshow(newImg)
hold on
plot(feature2(:,1),feature2(:,2), 'g.')
plot(feature1(:,1)+size(im2,2),feature1(:,2), 'r.')
for i = 1:size(matches,1)
    plot([matches(i,3) matches(i,1)+size(im2,2)],[matches(i,4) matches(i,2)],'b')
end
title('the matched feature between the two images')
figure(4); % warped image
imshow(I);