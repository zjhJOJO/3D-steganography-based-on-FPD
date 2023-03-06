function opd = optimal_distribution(cover,payload,w,sigma,k,q)
m=payload*length(cover);
opd = calcOptimalProb(w, m, sigma, k, q);
end
% modification distribution 
%sigma -> precision£¬k-> Maximum Iterations
function p = calcOptimalProb(w, m, sigma,k,q)
%
lambda_min=0;
lambda_max=10^10;
lambda=lambda_min;
iteration = 1;
%initialize M
p=distortiontoprob(w,lambda,q);
M=entropy(p);
while abs(M-m)>sigma
    if(iteration>k)
        break;
    end
    if M<m
        lambda_max = lambda;
    else 
        lambda_min = lambda;
    end
    lambda = (lambda_min+lambda_max)/2;
    p=distortiontoprob(w,lambda,q);
    M=entropy(p);
    iteration = iteration + 1;
end
end

function Ht = entropy(p)
    Ht=sum(sum(-p.*log(p)));   
end

function p = distortiontoprob(w,lambda,q)
wt=exp(-lambda*w(:,8-floor(q/2)+1:8+floor(q/2)));
fm=repmat(sum(wt,2),1,size(wt,2));
p=wt./fm;  
p(:,floor(q/2))=p(:,floor(q/2))-q*eps;
p=p+eps;
end
