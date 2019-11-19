%function data_matrix = Relief(filename,tau)
filename = 'C:\Users\dell\Desktop\train.xlsx';
tau = 0.5;
% 过滤式特征选择 tau表示阈值
data = xlsread(filename);
[data_row,data_col] = size(data);
%对所有涉及的样本进行归一化
% x' = x'-min/(max-min)
for i = 1:data_col-1 % data_col label 所以进行减1
    if(max(data(:,i))~=0)
        data(:,i) = (data(:,i)-min(data(:,i)))/(max(data(:,i))-min(data(:,i)));
    end
end
% 将连续的变量转换为[0 1]之间的数
all_distance = cell(3,data_row); 
%创建一个元胞数组，用于存储每一个样本
% 猜对近邻 猜错近邻
for j=1:data_row
    %将all_distance 的第一行第j列设置为 data(j,1:data_col-1)
    all_distance{1,j} = data(j,1:data_col-1);
    middle_same = data(find(data(:,data_col)==data(j,data_col)),1:data_col-1);
    % 寻找第j行具有相同标签的样本
    j_find = find_this_matrix(middle_same,data(j,1:data_col-1));
    middle_same(j_find,:) = []%在Label标签相同的类别中去掉自己
    distance = pdist2(data(j,1:data_col-1),middle_same);
    %计算第j个样本与 同类点之间的距离
    min_sa_index = find(distance==min(distance));
    %找出第j个点与同类点中距离最近的点的下标
    if length(min_sa_index)>1
        u = min_sa_index(1);%记录最近的下标
    else
        u = min_sa_index;
    end
    all_distance{2,j} = middle_same(u,:);
    %计算得到异类的样本
    middle_same =data(find(data(:,data_col)~=data(j,data_col)),1:data_col-1);
    distance = pdist2(data(j,1:data_col-1),middle_same);
    min_he_distance = find(distance==min(distance));
    if length(min_he_distance)>1
        u = min_he_distance(1);
    else
        u = min_he_distance;
    end
    all_distance{3,j} = middle_same(u,:);
end

dota_matrix = zeros(data_row,data_col-1);
for o = 1:data_row
    dota_matrix(o,:)=-(all_distance{1,o}-all_distance{2,o}).^2+(all_distance{1,o}-all_distance{3,o}).^2;
end
dota = sum(dota_matrix,1);
effect = find(dota>tau);
data_matrix = data(:,effect);%缺少Label
data_matrix=[data_matrix data(:,10)];
