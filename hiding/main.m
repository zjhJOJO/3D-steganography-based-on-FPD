clear; clc; close all;
addpath(genpath('data'));
addpath(genpath('3Dtools'));
addpath(genpath('functions'));

cover_dir = '../../data/cover/PMN_trimmed';
stego_dir='../../data/stego/FPD/PMN_trimmed/6';
 
cost_dir='../Cost/costm';

mesh=dir(cost_dir);
mesh_num = length(mesh)-2;
% embedding method
% 0 for Q-layered STC;1 for optimal embedding simulation
embedding_method=0;

iter_num=1000;
precision=0.0001;

sdn=10^(-6);

% allowed vertex change range¡£
% not that |I|=16->payload 6, |I|=8->4.5, |I|=4->3, |I|=2->1.5
% becuase 1-layered STC's max payload is 0.5
payload=6; % allowed payloads 1.5 3 4.5 6
I = (1:16)-8;

%/********* STC setting ************/
load('dv_best_submatrices.mat');
H_hat = double(submatrices{2,10});
% Not all combinations are known.
H=create_pcm_from_submatrix(H_hat, 3);

% code = structure with all necesary components
code = create_code_from_submatrix(H_hat, 3);

% /***************************************/

% Rand stream
RandStream.setGlobalStream(RandStream('mt19937ar','Seed',sum(100*clock)));

for i=1:mesh_num
    i
    name=mesh(i+2).name;
    b=strsplit(name,'.');
    cover_mesh = fullfile(cover_dir,[b{1},'.off']);
    [vertex,face]=read_off(cover_mesh);
    cost=load(fullfile(cost_dir,name));
    cost=cost.w;
    
    ver_stego = zeros(3,size(vertex,2));
    for j=1:3 % x,y,z
        w=squeeze(cost(:,j,:));w(:,8)=0;
        opd=optimal_distribution(vertex(j,:),payload/3,w,precision,iter_num,length(I));
        if embedding_method == 1   
            ver_stego(j,:)=optimal_embedding(vertex(j,:),opd,I,sdn);
        else
            ver_stego(j,:)=q_layered_STC(vertex(j,:),opd,I,sdn,H_hat);
        end         
   end
   % write off file
   
    output_path=fullfile(stego_dir,[b{1},'.off']);
    write_off(output_path, ver_stego, face);

end    
