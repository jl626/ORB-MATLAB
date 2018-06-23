function H = homography(pts1, pts2, isnormal)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Estimate homography matrix H using direct linear transform (4-point
%   method)
%
%   Inputs - pts1: points from Frame 1
%            pts2: points from Frame 2
%            isnormal: apply normalisation (default 1)  
%
%   Output - H: Homography matrix
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if nargin < 3
    isnormal = 1;
end

if isnormal == 0 
    X1 = pts1(:,1); Y1 = pts1(:,2);
    X2 = pts2(:,1); Y2 = pts2(:,2);
    % create a matrix 
   A = [X1(1), Y1(1), 1, 0, 0, 0, -X2(1)*X1(1), -X2(1)*Y1(1), -X2(1); ...
        0, 0, 0, X1(1), Y1(1), 1, -Y2(1)*X1(1), -Y2(1)*Y1(1), -Y2(1); ...
        X1(2), Y1(2), 1, 0, 0, 0, -X2(2)*X1(2), -X2(2)*Y1(2), -X2(2); ...
        0, 0, 0, X1(2), Y1(2), 1, -Y2(2)*X1(2), -Y2(2)*Y1(2), -Y2(2); ...
        X1(3), Y1(3), 1, 0, 0, 0, -X2(3)*X1(3), -X2(3)*Y1(3), -X2(3); ...
        0, 0, 0, X1(3), Y1(3), 1, -Y2(3)*X1(3), -Y2(3)*Y1(3), -Y2(3); ...
        X1(4), Y1(4), 1, 0, 0, 0, -X2(4)*X1(4), -X2(4)*Y1(4), -X2(4); ...
        0, 0, 0, X1(4), Y1(4), 1, -Y2(4)*X1(4), -Y2(4)*Y1(4), -Y2(4)];

    [evec, ~] = eigs(A);
    Hp = evec(:,9); % smallest eigenvector is the solution
    H = reshape(Hp,3,3)/Hp(9); % normalised w.r.t. the last component i.e. H(3,3) = 1;
else 
   % get mean
   cx = 0; cy = 0;
   cX = 0; cY = 0;
   for i = 1:4
       cx = cx + pts1(i,1);
       cy = cy + pts1(i,2);
       cX = cX + pts2(i,1);
       cY = cY + pts2(i,2);
   end
   
   cx = cx/4; cy = cy/4;
   cX = cX/4; cY = cy/4;
   
   % scale
   sx = 0; sy = 0;
   sX = 0; sY = 0;
   
   for j = 1:4;
       sx = sx + fabs(pts1(i,1) - cx);
       sy = sy + fabs(pts1(i,2) - cy);
       sX = sX + fabs(pts2(i,1) - cX);
       sY = sY + fabs(pts2(i,2) - cY);
   end
   
   sx = 4/sx; sy = 4/sy;
   sX = 4/sX; sY = 4/sY;
   
   % H norm
   InvHnorm = [1./sX, 0, cX; 0, 1./sY, cY;0, 0, 1];
   Hnorm = [sx, 0, -cx*sx; 0, sy, -cy*sy; 0, 0, 1];
   
   % contruct matrix 
   X1 = (pts1(:,1) - cx)*sx; Y1 = (pts1(:,2) - cy)*sy;
   X2 = (pts2(:,1) - cX)*sX; Y2 = (pts2(:,2) - cY)*sY;
   
   A = [X1(1), Y1(1), 1, 0, 0, 0, -X2(1)*X1(1), -X2(1)*Y1(1), -X2(1); ...
        0, 0, 0, X1(1), Y1(1), 1, -Y2(1)*X1(1), -Y2(1)*Y1(1), -Y2(1); ...
        X1(2), Y1(2), 1, 0, 0, 0, -X2(2)*X1(2), -X2(2)*Y1(2), -X2(2); ...
        0, 0, 0, X1(2), Y1(2), 1, -Y2(2)*X1(2), -Y2(2)*Y1(2), -Y2(2); ...
        X1(3), Y1(3), 1, 0, 0, 0, -X2(3)*X1(3), -X2(3)*Y1(3), -X2(3); ...
        0, 0, 0, X1(3), Y1(3), 1, -Y2(3)*X1(3), -Y2(3)*Y1(3), -Y2(3); ...
        X1(4), Y1(4), 1, 0, 0, 0, -X2(4)*X1(4), -X2(4)*Y1(4), -X2(4); ...
        0, 0, 0, X1(4), Y1(4), 1, -Y2(4)*X1(4), -Y2(4)*Y1(4), -Y2(4)];
    [evec, ~] = eigs(A);
    Hp = evec(:,9);
    tmp = reshape(Hp,3,3);
    Htmp = InvHnorm*tmp*Hnorm;
    H = Htmp/Htmp(3,3);
end

