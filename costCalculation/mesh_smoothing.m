function [vertex_s,face_s] = mesh_smoothing(vertex,face)
fv1.vertices = vertex; fv1.faces = face;
fv_smooth = smoothpatch(fv1, 0, 1);
vertex_s = fv_smooth.vertices; 
face_s = fv_smooth.faces;
end