clear; clc; close all;
% cpsb1 = 'C:\Users\A\Desktop\zjh3D\NVT+feature\data\COST(PSB)\PSB_cost1\';
% cpsb2 = 'C:\Users\A\Desktop\zjh3D\NVT+feature\data\COST(PSB)\PSB_cost2\';
% cpsb3 = 'C:\Users\A\Desktop\zjh3D\NVT+feature\data\COST(PSB)\PSB_cost3\';
% cpmn1 = 'C:\Users\A\Desktop\zjh3D\NVT+feature\data\COST(PMN)\PMN_cost1\';
% cpmn2 = 'C:\Users\A\Desktop\zjh3D\NVT+feature\data\COST(PMN)\PMN_cost2\';
% cpmn3 = 'C:\Users\A\Desktop\zjh3D\NVT+feature\data\COST(PMN)\PMN_cost3\';
% 
% addcpsb1='C:\Users\A\Desktop\zjh3D\NVT+feature\data\COST(PSB)\bc\1\';
% addcpsb2='C:\Users\A\Desktop\zjh3D\NVT+feature\data\COST(PSB)\bc\2\';
% addcpsb3='C:\Users\A\Desktop\zjh3D\NVT+feature\data\COST(PSB)\bc\3\';
% 
% addcpmn1='C:\Users\A\Desktop\zjh3D\NVT+feature\data\COST(PMN)\bc\1\';
% addcpmn2='C:\Users\A\Desktop\zjh3D\NVT+feature\data\COST(PMN)\bc\2\';
% addcpmn3='C:\Users\A\Desktop\zjh3D\NVT+feature\data\COST(PMN)\bc\3\';
% 
% 
% spsb1 = 'cost/PSB/1/';
% spsb2 = 'cost/PSB/2/';
% spsb3 = 'cost/PSB/3/';
% spsb4 = 'cost/PSB/4/';
% spmn1 = 'cost/PMN/1/';
% spmn2 = 'cost/PMN/2/';
% spmn3 = 'cost/PMN/3/';
% spmn4 = 'cost/PMN/4/';
% 
% cost=dir(spmn1);
% cost_num=length(cost)-2;
% for i=1:cost_num
%     name=cost(i+2).name;
%     w1=load([spmn1,name]);
%     w2=load([spmn2,name]);
%     w3=load([spmn3,name]);
%     w1=w1.w;w2=w2.w;w3=w3.w;
%     w=w1+w2+w3;
%     w=w./max(max(max(w)));
%     save([spmn4,name],'w');
% end

%     name=cost(i+2).name;
%     w1=load([cpmn3,name]);
%     wa=load([addcpmn3,name]);
%     w1=w1.Cost;
%     wa=wa.Cost;
%     w=cat(3,wa(:,:,1),w1,wa(:,:,2:end));
%     w=w./max(max(max(w)));
%     save([spmn3,name],'w');

cpath='./cost/TSM/';
spath='./cost/TSM/normalize/';
cost = dir(cpath);
for i=1:length(cost)-2
    name=cost(i+2).name;
    b=strsplit(name,'.');
    w=load([cpath,name]);
    w=w.Cost;
    w=w./max(max(max(w)));
    save([spath,cost(i+2).name],'w');
%     w=zeros(size(c,1),3,16);
%     for j=1:size(c,1)
%         for k=1:3
%             w(j,k,:)=c(j,:);
%         end    
%     end 
%     save([cpath,cost(i+2).name],'w');
end