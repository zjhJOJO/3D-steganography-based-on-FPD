% vertexs=[vertexs1;vertexs2;vertexs3];
clear; clc; close all;
addpath(genpath('./data'));
addpath(genpath('./mesh'))
addpath(genpath('./3Dtools'));
addpath(genpath('./functions'));
% 
% [vertex,face]=read_off('./mesh/9.off');
% [vertex_s,face_s]=read_off('./mesh/s9-4bpv.off');
cover_dir = '/Volumes/win10/zjh3D/data/cover/PMNn/';
stego_dir = '/Volumes/win10/zjh3D/data/stego/';
stego_method = 'VND/';
dataset = 'PMN/';
cover_file = '788.off';

% load cover mesh
[v,f]=read_off([cover_dir, cover_file]);
s1=zeros(4,size(v,1),size(v,2));
s2=zeros(4,size(v,1),size(v,2));
%load other stego method
[s1(1,:,:),~]=read_off([stego_dir, stego_method, dataset, '1.5/', cover_file]);
[s1(2,:,:),~]=read_off([stego_dir, stego_method, dataset, '3/', cover_file]);
[s1(3,:,:),~]=read_off([stego_dir, stego_method, dataset, '4.5/', cover_file]);
[s1(4,:,:),~]=read_off([stego_dir, stego_method,dataset, '6/', cover_file]);
% load FPD method
[s2(1,:,:),~]=read_off([stego_dir, 'FPD/', dataset, '1.5/', cover_file]);
[s2(2,:,:),~]=read_off([stego_dir, 'FPD/', dataset, '3/', cover_file]);
[s2(3,:,:),~]=read_off([stego_dir, 'FPD/', dataset, '4.5/', cover_file]);
[s2(4,:,:),~]=read_off([stego_dir, 'FPD/', dataset, '6/', cover_file]);


% preprocess for Chao
% if strcmp(stego_method,'Chao/')
%     for i=1:4
%     s1(i,:,:)=normalize(squeeze(s1(i,:,:)),v);
%     end
% end


% clim 
mx=0;
for i=1:4
    % other method
    vs1 = squeeze(s1(i,:,:));
    % our method
    vs2 = squeeze(s2(i,:,:));
    tmx = max([max(sum((vs1-v).^2)),max(sum((vs2-v).^2))]);
    if tmx>mx
        mx = tmx;
    end
end

%plot point cloud heatmap
for i=1:4
    subplot(2,4,i);
    vs = squeeze(s1(i,:,:));
    map = sum((vs-v).^2);
    pcshow(vs',map');
    caxis([0,mx]);
    axis off
end

for i=1:4
    subplot(2,4,i+4);
    vs = squeeze(s2(i,:,:));
    map = sum((vs-v).^2);
    pcshow(vs',map');
    caxis([0,mx]);
    axis off
end

h=colorbar('east'); %在图的下方添加colorbar
set(h,'Position', [0.920 0.24 0.018 0.60])




