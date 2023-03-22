clear; clc; close all;

% cost_pth = '../Cost/costo/cost3';
% cost = dir(cost_pth);
% save_pth = '../Cost/costn/cost3/';
% for i=1:length(cost)-2
%     name=cost(i+2).name;
%     b=strsplit(name,'.');
%     w=load(fullfile(cost_pth,name));
%     w=w.Cost;
%     w=w./max(max(max(w)));
%     save(fullfile(save_pth,cost(i+2).name),'w');
% end
cost_pth = '../Cost/costn';
type = ['cost1','cost2','cost3'];
cost = dir(fullfile(cost_pth,'cost1'));
save_pth = '../Cost/costm';

for i=1:length(cost)-2
    name = cost(i+2).name;
    on=split(name,'.');
    w1 = load(fullfile(cost_pth,'cost1',name));
    w2 = load(fullfile(cost_pth,'cost2',name));
    w3 = load(fullfile(cost_pth,'cost3',name));
    w1=w1.w;w2=w2.w;w3=w3.w;
    w = w1+w2+w3;
    save(fullfile(save_pth,'costm.m'),'w');
end
