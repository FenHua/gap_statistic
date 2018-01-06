clear all;
close all;
SDataNum=30; %样本观测点的数量
B=10; %参考数据集的数量
EX=[0 0;4 4;4 -4];  %各类样本的均值向量
sigma=[1 0;0 1]; %协方差矩阵
SData=[]; %样本数据
[EM,~]=size(EX);
for i=1:EM
    SData=[SData;mvnrnd(EX(i,:),sigma,fix(SDataNum/EM))]; % fix(X) rounds the elements of X to the nearest integers towards zero.
end
%画二维样本分布图
figure(1);
plot(SData(:,1),SData(:,2),'.'); 
title('SampleSet');

MaxK=10; %最大的聚类数
Wk=log(CompuWk(SData,MaxK)); %计算样本的Wk
interval=minmax(SData'); %样本各维度的取值区间
[M,N]=size(SData);
RefSet=zeros(M,N,B);
for b=1:B 
    %生成参考数据集
    for i=1:N
        TempSet(i,:)=unifrnd(interval(i,1),interval(i,2),1,M);
    end
    RefSet(:,:,b)=TempSet';
end
for b=1:B
    %计算参考数据集的Wkb
    Wkb(:,b)=log(CompuWk(RefSet(:,:,b),MaxK))';
end
for k=1:MaxK %计算Gap(k)
    Gap(k)=sum(Wkb(k,:))/B-Wk(k);
    l(k)=sum(Wkb(k,:))/B;
    sdk(k)=norm(Wkb(k,:)-l(k)*ones(1,B))/sqrt(B);
    sk(k)=sdk(k)*sqrt(1+1/B);
end
OptimusK=1;
for k=2:MaxK
    %计算最优的聚类数k
    if (Gap(k)<=Gap(k-1)+sk(k))&&(OptimusK==1) 
        OptimusK=k-1;
    end
end

figure(2);%画Gap值和最优聚类数
plot(1:MaxK,Gap,'.-',OptimusK,Gap(OptimusK),'dr');
legend('Gap Value','Optimal Number','Location','NorthEast');
xlabel('K Value');ylabel('Gap Value');title('Gap Value');


