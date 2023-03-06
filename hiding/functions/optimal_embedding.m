% Simulate optimal embedding
function y=optimal_embedding(cover,op,I,sdn)
randChange = rand(size(cover));
rc=repmat(randChange',1,size(op,2));
y=cover';
%modified_matrix;
c_mat=repmat(I,size(op,1),1);    
x=zeros(size(op,1),1);
for i=1:length(I)-1
    x(:,i)=sum(op(:,1:i),2);
end
temp=[zeros(size(op,1),1),x];
rc=rc-temp;
is_modified=double(rc>0&rc<op);
modified=is_modified.*c_mat;
y=y+sum(sdn*modified,2);
% y(is_modified)
end  