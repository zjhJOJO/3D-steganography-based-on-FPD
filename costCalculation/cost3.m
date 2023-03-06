function Cost = cost3(mesh_index,path,sdn,I,save_pth)

[vertex,face] = read_off(path);
vertex=vertex';face=face';
[vertex_m,face_m] = mesh_smoothing(vertex,face);

% area of each vertex
face_area=meshSurfaceAreaList(vertex,face);
face_area_m=meshSurfaceAreaList(vertex_m,face_m);
% vertices in the one-ring neighborhood of each vertex
% normal for each face
face_normal = faceNormal(vertex,face);
face_normal_m = faceNormal(vertex_m,face_m);
% faces contained in the one-ring neighborhood of each vertex
vf = compute_vertex_face_ring(face);
% vertices in the one-ring neighborhood of each vertex
% vv = compute_vertex_ring(face);

%=======
%neiborhood pattern
np3=obtain_neighborhood_pattern(face,vf);
%influence region
ir3=obtain_influence_region(size(vf,2),vf,np3);

Lambda = zeros(size(face,1),3);
Lambda_m =Lambda;
% calculate the original NVT features
for i=1:size(face,1)
    Lambda(i,:)=lambdaCalculation(i,np3,face_normal,face_area);
    Lambda_m(i,:)=lambdaCalculation(i,np3,face_normal_m,face_area_m);
end
diff_lambda = log(abs(Lambda-Lambda_m)+eps);
%features of original mesh
feature=[mean(diff_lambda),var(diff_lambda),skewness(diff_lambda),kurtosis(diff_lambda)];


Cost = zeros(size(vf,2),3,length(I));
% parfor_progress(size(vf,2));

for i=1:size(vf,2)
    i
    B = zeros(3,length(I));
     modified_face=face(vf{i},:);
    for j=1:3 %x y z 
        for k=1:length(I)
            vertex_s = vertex;
            vertex_s(i,j) = vertex_s(i,j)+I(k)*sdn;
         
            %new face area
            modified_area=trimeshSurfaceArea(vertex_s,modified_face);
            f_a=face_area;
            f_a(vf{i},:)=modified_area;
            %new face normal
            modified_normal=faceNormal(vertex_s,modified_face);
            f_n=face_normal;
            f_n(vf{i},:)=modified_normal;
            f_nb=ir3{i};
            
            if isempty(f_nb)
                continue
            else 
                temp=zeros(size(f_nb,1),3);
                for h=1:size(f_nb,2)
                    temp(h,:) = lambdaCalculation(f_nb(h),np3,f_n,f_a);
                end
                Lambda_s = Lambda;
                Lambda_s(f_nb,:)=temp;
                diff_lambda = log(abs(Lambda_s-Lambda_m)+eps);
                feature_s=[mean(diff_lambda),var(diff_lambda),skewness(diff_lambda),kurtosis(diff_lambda)];
                B(j,k) = abs(sum(feature_s-feature));
            end
        end
    end
    Cost(i,:,:)=B;
%     parfor_progress;
end

% save costs
save(fullfile(save_pth,[mesh_index,'.mat']),'Cost');

% parfor_progress(0);
end
% 
function lambda = lambdaCalculation(m_face,np3,f_n,f_a)
    n_face = np3{m_face};
    area = f_a(n_face);
    n_face_normal = f_n(n_face,:);
    cov_mat = zeros(3,3);
    if isempty(n_face)
        cov_mat=f_n(m_face,:)'*f_n(m_face,:);
    else  
        for i = 1:size(n_face,2)
            cov_mat=cov_mat+area(i)*n_face_normal(i,:)'*n_face_normal(i,:);
        end
        cov_mat=cov_mat./sum(area);
    end
    [~, eig_val] = eig(cov_mat);
    lambda = sort(diag(eig_val), 'descend');
end

function np3 = obtain_neighborhood_pattern(face,vf)
   np3=cell(1,size(face,1));
   for i=1:size(face,1)
      res=unique([vf{face(i,1)},vf{face(i,2)},vf{face(i,3)}]);
      res(res==i)=[];
      np3{i}=res;
   end    
end

function ir3 = obtain_influence_region(vertex_num, vf, np3)
    ir3=cell(1,vertex_num);
    for i=1:vertex_num
        temp=[];
        for j=1:size(vf{i},1)
            temp=[temp,np3{vf{i}(j)}];
        end
        ir3{i}=unique(temp);
    end    
end    
