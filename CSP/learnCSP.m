function CSPMatrix = learnCSP(eegData,labels)

[nbChannel,nbSample,nbTrial]=size(eegData);% channel sample ntrial
classLabel = unique(labels); % �ļ��ֱ�ǩ
nbClasses = length(unique(labels)); %��ǩ������

covMatrices = cell(nbClasses,1);
% Э�������ĺ�
trialCov = zeros(nbChannel,nbChannel,nbTrial);
for t = 1:nbTrial
    E = eegData(:,:,t);
    EE = E*(E');
    trialCov(:,:,t)=EE./trace(EE);
end

for c = 1:nbClasses
    covMatrices{c}=mean(trialCov(:,:,labels==classLabel(c)),3);% 3��ʾ������  1�����о�ֵ 2 �о�ֵ
end
% ����õ�ƽ��Э�������
covTotal = covMatrices{1}+covMatrices{2}; 
% �׻��ܵ���������
%%% ��Э�������R��������ֵ�ֽ�
[Ut Dt]=eig(covTotal);
eigenvalues = diag(Dt);
[eigenvalues egIndex] = sort(eigenvalues,'descend');
Ut = Ut(:,egIndex);
P = diag(sqrt(1./eigenvalues))*Ut';
% ��P�任��һ��Э�������
transformedCov1 = P*covMatrices{1}*P';
% U1��������  D1����ֵ
[U1 D1]=eig(transformedCov1);
eigenvalues = diag(D1);
[eigenvalues egIndex] =sort(eigenvalues,'descend');%������ֵ��������
U1 =U1(:,egIndex);
% ����ͶӰ����
CSPMatrix = U1'*P;
