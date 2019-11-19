% 
%data = xlsread('C:\Users\dell\Desktop\train.xlsx');
data = data_matrix;%应用过滤法求解
k = 10;
[m n]=size(data);
indices = crossvalind('Kfold',m,10);
sumPre = 0
for i = 1:k
    test_indic = (indices == i);
    train_indic = ~test_indic;
    test_data = data(test_indic,1:end-1);
    test_label = data(test_indic,end);
    train_data = data(train_indic,1:end-1);
    train_label = data(train_indic,end);
    model = svmtrain(train_label,train_data,'-s 0 -t 2');
    [C,acc,decision_value] = svmpredict(test_label,test_data,model);
    sumPre = sumPre + acc;
end
meanAcc = sumPre/k;
fprintf('\n\n');
disp(meanAcc);