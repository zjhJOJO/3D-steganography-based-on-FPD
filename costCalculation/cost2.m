function Cost = cost2(mesh_index,path,sdn,I,save_pth)

[vertex,face] = read_off(path);
vertex=vertex';face=face';
[vertex_m,face_m] = mesh_smoothing(vertex,face);

% area of each vertex
face_area=meshSurfaceAreaList(vertex,face);
face_area_m=meshSurfaceAreaList(vertex_m,face_m);
% normal for each face
face_normal = faceNormal(vertex,face);
face_normal_m = faceNormal(vertex_m,face_m);
% faces contained in the one-ring neighborhood of each vertex
vf = compute_vertex_face_ring(face);

%=======
edge = meshEdges(face);

% edge: faces
EF = trimeshEdgeFaces(vertex, edge, face);
% face: edges
FE = meshFaceEdges(vertex, edge, face);
%neiborhood pattern 2
np2=obtain_neighborhood_pattern(face,EF,FE);
%influence region 2
ir2=obtain_influence_region(size(vf,2),vf,np2);

Lambda = zeros(size(vertex,1),3);
Lambda_m =Lambda;

% calculate the original NVT features
for i=1:size(face,1)
    Lambda(i,:)=lambdaCalculation(i,np2,face_normal,face_area);
    Lambda_m(i,:)=lambdaCalculation(i,np2,face_normal_m,face_area_m);
end
diff_lambda = log(abs(Lambda-Lambda_m)+eps);
%features of original mesh
feature=[mean(diff_lambda),var(diff_lambda),skewness(diff_lambda),kurtosis(diff_lambda)];

Cost = zeros(size(vf,2),3,length(I));

parfor_progress(size(vf,2));
parfor i=1:size(vf,2)
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
            f_nb=ir2{i};
            
            if isempty(f_nb)
                continue
            else    
                temp=zeros(size(f_nb,1),3);
                for h=1:size(f_nb,1)
                    temp(h,:) = lambdaCalculation(f_nb(h),np2,f_n,f_a);
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
    parfor_progress;
end

% save costs
save(fullfile(save_pth,[mesh_index,'.mat']),'Cost');
parfor_progress(0);
end
% calculation of eigen-values
function lambda = lambdaCalculation(m_face,np2,f_n,f_a)
    n_face = np2{m_face};
    if isempty(n_face)
        cov_mat=f_n(m_face,:)'*f_n(m_face,:);
    else    
        area = f_a(n_face);
        n_face_normal = f_n(n_face,:);
        cov_mat = zeros(3,3);
        for i = 1:size(n_face,2)
            cov_mat=cov_mat+area(i)*n_face_normal(i,:)'*n_face_normal(i,:);
        end
        cov_mat=cov_mat./sum(area);
    end
    [~, eig_val] = eig(cov_mat);
    lambda = sort(diag(eig_val), 'descend');
end

function np2 = obtain_neighborhood_pattern(face,EF,FE) 
   np2=cell(1,size(face,1));
   for j=1:size(face,1)
      res=unique(EF(FE{j},:));
      res(res==j)=[];
      res(res==0)=[];
      np2{j}=res;
   end  
end

function ir2 = obtain_influence_region(num, vf, np2)
    ir2=cell(1,num);
    for i=1:num
        temp=[];
        for j=1:size(vf{i},1)
            temp=[temp,np2{vf{i}(j)}];
        end
        ir2{i}=unique(temp);
    end    
end    

