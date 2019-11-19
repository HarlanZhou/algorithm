function [err,threshold,dimT,direction,final_label]=findThreshold(data,label,Di)
% 输出最小错误率及其阈值，方向，维度的位置  
% data传入的是第K列数据  pre_label该次分类下的结果
% dimT 来自的数据的维度的位置  Di权值分布 用于计算错误率
    err = 100; % 错误率
    threshold = 0; % 阈值 这个可能有问题
    direction = 100;
    stepNum = 50;% 步长50
    dimT = -1;
    [m,n]=size(data);
    %寻找合适的步长 在n个不同的样本的第k微数据
for i = 1:n
    step = linspace(min(data(:,i)),max(data(:,i)),stepNum);
    for j = 1: stepNum
        % 从一个阈值开始 计算哪个错误率低 分别统计两次 小于阈值为1与小于阈值为-1
        % 小于阈值为 1 否则是-1data是列向量
        y_pre = (data(:,i)<=step(j))*2-1; % 例如阈值为2.5 data为 1 1<2.5=1  所以该值为 1
        correct = y_pre == label; %相同为 1 不同为0
        %index = find(data(:,q)<step(i));
         
        % 取反方便计算
        errI = Di*(~correct); % 
        if err>errI
            err = errI;
            threshold = step(j);
            direction = 1;
            dimT = i;
            pre_label = y_pre;
        end
        % 小于阈值为 -1
        y_pre = (data>=step(j))*2-1; % 1>2.5   0--->-1
        correct = y_pre == label;
        errI = Di*(~correct); %根据Di权重得到错误率 
        if err>errI
            err = errI;
            threshold = step(j);
            direction = -1;
            dimT = i;
            pre_label = y_pre;
        end
    end
end
final_label = pre_label;
