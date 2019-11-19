data = xlsread('C:\Users\dell\Desktop\train.xlsx');
% 进行交叉验证
k = 10;
sum_acc = 0;
[m,n]=size(data);
indice = crossvalind('Kfold',m,k);

for i = 1:k  % 交叉验证的次数
    test_indic = (indice==i);
    train_indic = ~test_indic;
    train_data = data(train_indic,1:end-1);
    train_label = data(train_indic,end);
    test_data = data(test_indic,1:end-1);
    test_label =data(test_indic,end);
    iter = 10;% 训练小分类器的个数
    [dim,direction,thre,alpha]=AdaBoost(train_data,train_label,iter);
    [tt,kk]=size(test_data);
     predict = zeros(tt,1);
    for j=1:tt%length(test_data) 测试集中样本的个数
        test_data_item = test_data(j,:); %选取第j个样本的数据
        for z = 1:iter
            if direction(z) == -1 %判别正负类
                if test_data_item(dim(z))<=thre(z)
                    h(z)=-1;
                else
                    h(z)=1;
                end
            elseif direction(z)==1
                if test_data_item(dim(z))<=thre(z)
                    h(z)=1;
                else
                    h(z)=-1;
                end
            end
        end
        %disp('predict')
        predict(j)=sign(alpha*h');
        %disp(predict(j));
        %disp('real label');
        %disp(test_label(j));
    end
    cor = predict==test_label;
    acc = sum(cor)/length(test_label);
    sum_acc=sum_acc+acc;
end
disp('mean acc');
disp(sum_acc/k);
