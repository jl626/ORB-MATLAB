% compute angles corresponding to the selected points
function angle = orientation(I,coord)

radii = 3; % FAST corner detector's default radii
I = double(I); % transpose to compute angle // matlab column major -> row major
m = strel('octagon',radii); mask = m.Neighborhood; % FAST search mask
Ip = padarray(I,[radii radii],0,'both'); % padding

r = size(mask,2);
c = size(mask,1);

angle = zeros(size(coord,1),1);

for i = 1:size(coord,1);
    
    r0 = coord(i,2);
    c0 = coord(i,1);
    
    m01 = 0;
    m10 = 0;
    
    for j= 1:r
        for k = 1:c
            if mask(k,j) 
               pixel = Ip(c0 + k-1, r0 + j-1);
               m10 = m10 + pixel * (-radii + k - 1);
               m01 = m01 + pixel * (-radii + j - 1);
            end
        end
    end
    angle(i) = atan2(m01,m10);
end
