function features = rBRIEF(I,corners,patterns,angle)

% initialise features
features = zeros(size(corners,1),256);

for i = 1:size(corners,1)
    pattern1 = round([cos(angle(i)),-sin(angle(i));sin(angle(i)),cos(angle(i))]*patterns(:,1:2)')'; 
    pattern2 = round([cos(angle(i)),-sin(angle(i));sin(angle(i)),cos(angle(i))]*patterns(:,3:4)')';
    for j = 1:256
        p1 = I(corners(i,2) + pattern1(j,2),corners(i,1) + pattern1(j,1));
        p2 = I(corners(i,2) + pattern2(j,2),corners(i,1) + pattern2(j,1));
        features(i,j) = double(p1 < p2);
    end
end