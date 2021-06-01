clear all
close all
clc

%%
s_rad=zeros(50,1);
acc=zeros(50,1);
n_iter=zeros(50,1);

for v=1:10
save ciao v acc n_iter s_rad
build_data;
load ciao
if eigenvalue(24)==1
    continue;
end
s_rad(v)=eigenvalue(24);
save ciao v acc n_iter s_rad
localization_dist;
load ciao
acc(v)=(success/ni*100);
n_iter(v)=round(mean(iter));
end