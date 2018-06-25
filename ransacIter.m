function iter = ransacIter(p,ninlr, maxiter)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Dynamic Update for RANSAC
%
%   Inputs - p : confidence level (default 0.99);
%            ninlr : number of inliers
%            maxiter :
%
%
%   output - iter : maximum iteration
%
%
%                   Juheon Lee (21/06/2018)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if (p >1 || p <0)
    error('p should be larger than 0 and smaller than 1');
end

ep = 1-p;
tmp = 1 - (1 - ep)^ninlr;

num =  log(ep);
denum = log(tmp);

if (num/denum > maxiter)
    iter = maxiter;
else
    iter = round(num/denum);
end
