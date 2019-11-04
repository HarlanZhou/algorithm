%function features = extractCSP(EPO,CSPMatrix,nbFilterPairs)

CSPMatrix = learnCSP(EPO,labels);
[nbChannel,nbSample,nbTrial]=size(EPO);
nbFilterPair = 4; % 特诊参数m
features = zeros(nbTrial,2*nbFilterPair+1);% CSP特征为 2*m
Filter =CSPMatrix([1:nbFilterPair (end-nbFilterPair+1):end],:);
for t = 1:nbTrial
    projectedTrial = Filter * EPO(:,:,t);
    variances = var(projectedTrial,0,2);
    for f = 1:length(variances)
        features(t,f)=log(1+variances(f));
    end
end
%修改int 16