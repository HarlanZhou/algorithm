function [err,threshold,dimT,direction,final_label]=findThreshold(data,label,Di)
% �����С�����ʼ�����ֵ������ά�ȵ�λ��  
% data������ǵ�K������  pre_label�ôη����µĽ��
% dimT ���Ե����ݵ�ά�ȵ�λ��  DiȨֵ�ֲ� ���ڼ��������
    err = 100; % ������
    threshold = 0; % ��ֵ �������������
    direction = 100;
    stepNum = 50;% ����50
    dimT = -1;
    [m,n]=size(data);
    %Ѱ�Һ��ʵĲ��� ��n����ͬ�������ĵ�k΢����
for i = 1:n
    step = linspace(min(data(:,i)),max(data(:,i)),stepNum);
    for j = 1: stepNum
        % ��һ����ֵ��ʼ �����ĸ������ʵ� �ֱ�ͳ������ С����ֵΪ1��С����ֵΪ-1
        % С����ֵΪ 1 ������-1data��������
        y_pre = (data(:,i)<=step(j))*2-1; % ������ֵΪ2.5 dataΪ 1 1<2.5=1  ���Ը�ֵΪ 1
        correct = y_pre == label; %��ͬΪ 1 ��ͬΪ0
        %index = find(data(:,q)<step(i));
         
        % ȡ���������
        errI = Di*(~correct); % 
        if err>errI
            err = errI;
            threshold = step(j);
            direction = 1;
            dimT = i;
            pre_label = y_pre;
        end
        % С����ֵΪ -1
        y_pre = (data>=step(j))*2-1; % 1>2.5   0--->-1
        correct = y_pre == label;
        errI = Di*(~correct); %����DiȨ�صõ������� 
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
