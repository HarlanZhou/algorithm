function CSPMatrix = learnCSP(eegData,labels)

[nbChannel,nbSample,nbTrial]=size(eegData);% channel sample ntrial
classLabel = unique(labels); % 哪几种标签
nbClasses = length(unique(labels)); %标签的种类

covMatrices = cell(nbClasses,1);
% 协方差矩阵的和
trialCov = zeros(nbChannel,nbChannel,nbTrial);
for t = 1:nbTrial
    E = eegData(:,:,t);
    EE = E*(E');
    trialCov(:,:,t)=EE./trace(EE);
end

for c = 1:nbClasses
    covMatrices{c}=mean(trialCov(:,:,labels==classLabel(c)),3);% 3表示矩阵本身  1计算列均值 2 行均值
end
% 计算得到平均协方差矩阵
covTotal = covMatrices{1}+covMatrices{2}; 
% 白化总的特征矩阵
%%% 对协方差矩阵R进行特征值分解
[Ut Dt]=eig(covTotal);
eigenvalues = diag(Dt);
[eigenvalues egIndex] = sort(eigenvalues,'descend');
Ut = Ut(:,egIndex);
P = diag(sqrt(1./eigenvalues))*Ut';
% 用P变换第一类协方差矩阵
transformedCov1 = P*covMatrices{1}*P';
% U1特征向量  D1特征值
[U1 D1]=eig(transformedCov1);
eigenvalues = diag(D1);
[eigenvalues egIndex] =sort(eigenvalues,'descend');%将特征值降序排列
U1 =U1(:,egIndex);
% 计算投影矩阵
CSPMatrix = U1'*P;
