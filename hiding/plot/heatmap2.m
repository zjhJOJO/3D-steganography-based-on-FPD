% vertexs=[vertexs1;vertexs2;vertexs3];
clear; clc; close all;
addpath(genpath('./data'));
addpath(genpath('./mesh'))
addpath(genpath('./3Dtools'));
addpath(genpath('./functions'));
% 
% [vertex,face]=read_off('./mesh/9.off');
% [vertex_s,face_s]=read_off('./mesh/s9-4bpv.off');
cover_dir = '/Volumes/win10/zjh3D/data/cover/';
stego_dir = '/Volumes/win10/zjh3D/data/stego/';

psb_cover = '2.off';
pmn_cover = '1306.off';
tsm_cover = 'happy_vrip_res4.off';
% load cover mehs
[v1,~]=read_off([cover_dir, 'PSBn/', psb_cover]);
[v2,~]=read_off([cover_dir, 'PMNn/', pmn_cover]);
[v3,~]=read_off([cover_dir, 'TSM/', tsm_cover]);

s1=zeros(4,size(v1,1),size(v1,2));
s2=zeros(4,size(v2,1),size(v2,2));
s3=zeros(4,size(v3,1),size(v3,2));
%load other stego method
[s1(1,:,:),~]=read_off([stego_dir, 'FPD/', 'PSB/', '1.5/', psb_cover]);
[s1(2,:,:),~]=read_off([stego_dir, 'FPD/', 'PSB/', '3/', psb_cover]);
[s1(3,:,:),~]=read_off([stego_dir, 'FPD/', 'PSB/', '4.5/', psb_cover]);
[s1(4,:,:),~]=read_off([stego_dir, 'FPD/', 'PSB/', '6/', psb_cover]);
% load FPD method
[s2(1,:,:),~]=read_off([stego_dir, 'FPD/', 'PMN/', '1.5/', pmn_cover]);
[s2(2,:,:),~]=read_off([stego_dir, 'FPD/', 'PMN/', '3/', pmn_cover]);
[s2(3,:,:),~]=read_off([stego_dir, 'FPD/', 'PMN/', '4.5/', pmn_cover]);
[s2(4,:,:),~]=read_off([stego_dir, 'FPD/', 'PMN/', '6/', pmn_cover]);

[s3(1,:,:),~]=read_off([stego_dir, 'FPD/', 'TSM/', '1.5/', tsm_cover]);
[s3(2,:,:),~]=read_off([stego_dir, 'FPD/', 'TSM/', '3/', tsm_cover]);
[s3(3,:,:),~]=read_off([stego_dir, 'FPD/', 'TSM/', '4.5/', tsm_cover]);
[s3(4,:,:),~]=read_off([stego_dir, 'FPD/', 'TSM/', '6/', tsm_cover]);


% clim 
mx1=0;
for i=1:4
    % other method
    vs = squeeze(s1(i,:,:));
    tmx = max(sum((vs-v1).^2));
    if tmx>mx1
        mx1=tmx;
    end
end

mx2=0;
for i=1:4
    % other method
    vs = squeeze(s2(i,:,:));
    tmx = max(sum((vs-v2).^2));
    if tmx>mx2
        mx2=tmx;
    end
end

mx3=0;
for i=1:4
    % other method
    vs = squeeze(s3(i,:,:));
    tmx = max(sum((vs-v3).^2));
    if tmx>mx3
        mx3=tmx;
    end
end

%plot point cloud heatmap
% for i=1:4
%     subplot(1,4,i);
%     vs = squeeze(s1(i,:,:));
%     map = sum((vs-v1).^2);
%     pcshow(vs',map');
%     caxis([0,mx1]);
%     axis off
% end

% for i=1:4
%     subplot(1,4,i);
%     vs = squeeze(s2(i,:,:));
%     map = sum((vs-v2).^2);
%     pcshow(vs',map');
%     caxis([0,mx2]);
%     axis off
% end
% 
for i=1:4
    subplot(1,4,i);
    vs = squeeze(s3(i,:,:));
    map = sum((vs-v3).^2);
    pcshow(vs',map');
    caxis([0,mx3]);
    axis off
end

h=colorbar('east'); %在图的下方添加colorbar
set(h,'Position', [0.920 0.28 0.018 0.50])