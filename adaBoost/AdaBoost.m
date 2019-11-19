function [dim,F,threshold,alpha]= AdaBoost(data,label,iter)
% data��ʾ�������� label���ݱ�ǩ iter ѵ���������ĸ���
% n������ m��ά��
[n,m]=size(data);

% ��ʼ��ѵ�����ݵ�Ȩֵ�ֲ������ȷֲ�
D = ones(1,n)/n; % ����Ȩ��D 1�� n��
% w(1,:) = zeros(1,length(label))+1/length(label);%����ɾ��
% ȷ��m ��ʲô
% ѵ���ڷ����� 
for k=1:iter
    %Ѱ�Һ��ʵĲ��� ��n����ͬ�������ĵ�k΢����
    % step = linspace(min(data(:,k)),max(:,k),stepNum);
    % ����Ƚ�ѡȡ������С�����ʵ���ֵ�����򣬷ֱ𷵻�������ǩ����С������Er����ֵthre������Flag ��ά��dim
    % �������Ǹ��� DiȨֵ�ֲ������  
    [Err,threshold(k),dim(k),F(k),pre_label] = findThreshold(data,label,D);
    % �����ǰ��ά���³��ֱ�֮ǰ��С�Ĵ����ʣ������
    alpha(k) = 0.5*log((1-Err)/Err);
    %����ȫֵD D��һ��n�е�ֵ n ���������ĸ��� label��ʾ n��1��
    D = D.*(exp(-alpha(k)*(label'*pre_label(k))));
    D = D /sum(D);
end


