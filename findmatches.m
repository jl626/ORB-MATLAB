function matches = findmatches(des1, des2,corner1,corner2)


[idx1,dist1]= knnsearch(des2,des1,'K',2,'Distance','hamming'); % knn distance for descriptor 1
[idx2,~]= knnsearch(des1,des2,'K',2,'Distance','hamming'); % knn distance for descriptor 2

matches = zeros(size(des1,1),4);
for i = 1:size(des1,1);
    if (dist1(i,1) <= 64/256 && dist1(i,1)/dist1(i,2) <=0.98 && i == idx2(idx1(i),1))
        % hamming distance < 0.25 + ratio between smallest and second
        % smallest < 0.98  and cross minimum value check 
        matches(i,:) = [corner1(i,:),corner2(idx1(i,1),:)];
    end
end

% remove outliers
filter = find(matches(:,1));
matches = matches(filter,:);