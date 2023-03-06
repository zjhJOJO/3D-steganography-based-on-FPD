%/********* practical embedding***********/
% x-> cover siginal
% opd -> optimal distribution
% I -> allowed vertex change range
% sdn -> significant digital number
% H_hat -> generatot for constructing the parity-check matrix H
function y = q_layered_STC(x,opd,I,sdn,H_hat)
% preprocess x
x=round(x./sdn);
x_copy=x;
% record sign "+" and "-"
x_sign = -(x<0) + (x>0);x_sign=x_sign';
x=abs(x);


Q=ceil(log2(length(I)));
code = create_code_from_submatrix(H_hat,floor(length(x)/2));
% for practical embedding
if code.n ~= length(x)
    x = x(1,1:code.n);
    opd = opd(1:code.n,:);
end

% bits to be hidden
m = double(rand(sum(code.shift),1)<0.5);

% initialize array A, please see our paper for details
A=repmat(zeros(1,Q+1),length(x),1);A(:,1)=1;

% initialize state array
op_state = ones(length(x),length(I));
% operation matrxi
op = repmat(I,length(x),1);

% Q-layered STC embedding from LSBs. 
bp_stego = zeros(length(x),Q);
for l=1:Q
    PI = getBitplane(x'+op,l);
    p1 = sum(op_state.*PI.*opd,2)./A(:,1); 
    % only record p0, please see our paper for details
    p0 = 1-p1;
    A(:,l+1) = p0;
    
    bp_stego(:,l)=STC_flipping_lemma(code,A(:,l+1),m);
  
    % Pruning operation 
    op_state = op_state.*bit_operator(bp_stego(:,l),PI); 
    
    % update array A
    A(:,1)=sum(bit_operator(bp_stego(:,l),[zeros(length(x),1),ones(length(x),1)]).*[p0,p1],2).*A(:,1);
end

% generate stego vertex 
% y = Nv x 1 here
y=x'+sum(op.*op_state,2);

if length(y) ~= length(x_copy)
    y=[y;abs(x_copy(end))];
    y=x_sign.*y;
else
    y=x_sign.*y;
end
y=y.*sdn;
y=y'; %size 1XNv
end
%/****************************************/

%/*********** Flipping lemma *************/
% please refer to  the ?"Minimizing Additive Distortion in Steganography
% using Syndrome-Trellis Codes" for the details
function y = STC_flipping_lemma(code,p0,m)
    x = p0<1/2;
    w = log((1-max(p0,1-p0))./max(p0,1-p0)+eps);     
    [y,~] = dual_viterbi(code, x, w, m);
end
% /***************************************/

function z = bit_operator(x,y)
z=abs(xor(x,y)-1);
end
% ** generate vertex coordinates with given bitplaness **/
% function y = generate_stego_coordinates(x,bp_stego,sign)
% r=ceil(log2(max(x)));
% y = zeros(length(x),r);
% for i=1:r
%     y(:,i)=getBitplane(x,i);
% end
% y(:,1:size(bp_stego,2))=bp_stego;
% y=sum((2.^((1:r)-1)).*y,2);
% % note I, we should make a modification here for y
% aa=y'-x;
% end
% % /**********Pruning operation**************/
% function y = Pruning(state, x, pi)
% 
% end
% % /***************************************/





