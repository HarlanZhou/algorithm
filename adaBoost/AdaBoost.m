function [dim,F,threshold,alpha]= AdaBoost(data,label,iter)
% data表示数据特征 label数据标签 iter 训练分类器的个数
% n个样本 m个维度
[n,m]=size(data);

% 初始化训练数据的权值分布，均匀分布
D = ones(1,n)/n; % 迭代权重D 1行 n列
% w(1,:) = zeros(1,length(label))+1/length(label);%可以删除
% 确定m 是什么
% 训练第分类器 
for k=1:iter
    %寻找合适的步长 在n个不同的样本的第k微数据
    % step = linspace(min(data(:,k)),max(:,k),stepNum);
    % 逐个比较选取具有最小错误率的阈值、方向，分别返回三个标签：最小错误率Er、阈值thre、方向Flag 、维度dim
    % 错误率是根据 Di权值分布计算的  
    [Err,threshold(k),dim(k),F(k),pre_label] = findThreshold(data,label,D);
    % 如果当前的维度下出现比之前还小的错误率，则更新
    alpha(k) = 0.5*log((1-Err)/Err);
    %更新全值D D是一行n列的值 n 代表样本的个数 label表示 n行1列
    D = D.*(exp(-alpha(k)*(label'*pre_label(k))));
    D = D /sum(D);
end


