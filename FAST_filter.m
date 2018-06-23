function [fast_nonmax,fsc] = FAST_filter(I,corners,fscore)

% image size
[y,x]=size(I);

% get vectorial indices for corners
pixel = zeros(size(corners,1),1);
for i = 1:size(corners,1)
    pixel(i) = (corners(i,1)-1)*y + corners(i,2); 
end

% get indicies for surrounding pixels
kernel_size = 5;
kernel_n = kernel_size*2+1; 
kernel_vector = zeros(kernel_n^2,1);

for i = 1:kernel_n
    for j = 1:kernel_n
        kernel_vector((i-1)*kernel_n + j,1) = j-6 + (i-6)*y;
    end
end

% create fast score map
map = zeros(size(I));
map(pixel) = fscore;

% initiate non maximum suppression 
corner_max = zeros(size(corners,1),1);
% 
for i = 1:size(corners,1)
    surround = pixel(i) + kernel_vector;
    corner_max(i) = (sum(fscore(i) >= map(surround)) == kernel_n^2);    
end

fast_nonmax = corners(logical(corner_max),:);
fsc = fscore(logical(corner_max));