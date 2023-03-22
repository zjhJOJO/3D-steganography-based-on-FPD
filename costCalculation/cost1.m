function cost1(mesh_index,path,sdn,I,save_pth)
[vertex,face] = read_off(path);
vertex=vertex';face=face';

[vertex_m,face_m] = mesh_smoothing(vertex,face);

% area of each vertex
face_area=meshSurfaceAreaList(vertex,face);
face_area_m=meshSurfaceAreaList(vertex_m,face_m);

% vertices in the one-ring neighborhood of each vertex
vv = compute_vertex_ring(face);
% faces contained in the one-ring neighborhood of each vertex
vf = compute_vertex_face_ring(face);

% normal for each face
face_normal = faceNormal(vertex,face);
face_normal_m = faceNormal(vertex_m,face_m);

%centroid of each face
f_c = meshFaceCentroids(vertex,face);
f_c_m=meshFaceCentroids(vertex_m,face_m);
%¸
Lambda = zeros(size(vf,2),3);
Lambda_m =Lambda;

% calculate the original NVT features
for i=1:size(vf,2)
    Lambda(i,:)=lambdaCalculation(i,vertex,vf,face_normal,face_area,f_c);
    Lambda_m(i,:)=lambdaCalculation(i,vertex_m,vf,face_normal_m,face_area_m,f_c_m);
end

diff_lambda = log(abs(Lambda-Lambda_m)+eps);
%features of original mesh
feature=[mean(diff_lambda),var(diff_lambda),skewness(diff_lambda),kurtosis(diff_lambda)];

Cost = zeros(size(vf,2),3,length(I));

%calculate the vertex-changing costs
parfor_progress(size(vf,2));
parfor i=1:size(vf,2)
    modified_face=face(vf{i},:);
    B = zeros(3,length(I));
    for j=1:3 %x y z
        for k=1:length(I)
            vertex_s = vertex;
            vertex_s(i,j) = vertex_s(i,j)+I(k)*sdn;

            % new face area
            modified_area=trimeshSurfaceArea(vertex_s,modified_face);
            f_a=face_area;
            f_a(vf{i},:)=modified_area;
            % new face normal
            modified_normal=faceNormal(vertex_s,modified_face);
            f_n=face_normal;
            f_n(vf{i},:)=modified_normal;
            %new face centroids
            modified_cen = meshFaceCentroids(vertex_s,modified_face);
            f_cen = f_c;
            f_cen(vf{i},:)=modified_cen;
            % obtain neighborhood pattern 1
            v_nb = [i,vv{i}];
            Lambda_s = Lambda;
     
            temp=zeros(size(v_nb,2),3);
            for h=1:size(v_nb,2)
                temp(h,:) = lambdaCalculation(v_nb(h),vertex_s,vf,f_n,f_a,f_cen);
            end
            Lambda_s(v_nb,:)=temp;
            diff_lambda = log(abs(Lambda_s-Lambda_m)+eps);
            feature_s=[mean(diff_lambda),var(diff_lambda),skewness(diff_lambda),kurtosis(diff_lambda)];
            B(j,k) = abs(sum(feature_s-feature));
        end
    end
    Cost(i,:,:)=B;
    parfor_progress;
end

% save costs
save(fullfile(save_pth,[mesh_index,'.mat']),'Cost');
parfor_progress(0);

end
% 
function lambda = lambdaCalculation(m_vertex,vertex,vf,f_n,f_a,f_ce)
    f_n(isnan(f_n))=eps;
    f_a(isnan(f_a))=eps;
    f_ce(isnan(f_ce))=eps;
    n_face = vf{m_vertex};
    area = f_a(n_face);
    n_face_normal = f_n(n_face,:);
    face_C = f_ce(n_face,:);
    max_area = max(area);  
    cov_mat = zeros(3,3);
    for i = 1:size(n_face,2)
        mu = (area(i)/(max_area+eps))*exp(3*sqrt(sum(vertex(m_vertex,:)-face_C(i,:)).^2));
        cov_mat=cov_mat+mu*n_face_normal(i,:)'*n_face_normal(i,:);
    end
    [~, eig_val] = eig(cov_mat);
    lambda = sort(diag(eig_val), 'descend');
end

    
