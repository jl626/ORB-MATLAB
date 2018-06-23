function features = BRIEF(I,corners,patterns)

% initialise features
features = zeros(size(corners,1),256);

for i = 1:size(corners,1)
    for j = 1:256
        p1 = I(corners(i,2) + patterns(j,2),corners(i,1) + patterns(j,1));
        p2 = I(corners(i,2) + patterns(j,4),corners(i,1) + patterns(j,3));
        features(i,j) = double(p1 < p2);
    end
end