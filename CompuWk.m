function Wk=CompuWk(Data,MaxK)
[M,N]=size(Data);
%为了兼容Matlab自带的kmeans算法，这里先单独计算聚类数为1时的Wk，
%因为Matlab的kmeans函数不能计算聚类数为1的情况。
Dr=0; %计算Wk(1)
for i=1:M
    for j=i:M
        Dr=Dr+norm(Data(i,:)-Data(j,:))^2;
    end
end
Wk(1)=0.5*Dr/M;
for k=2:MaxK
    %计算Wk(2：MaxK)
    labels=cmeans(Data,k); 
    Dr=zeros(1,k);
    for i=1:k
        Cr=[];
        for j=1:M
            if labels(j)==i
                Cr=[Cr;Data(j,:)];
            end
        end
        [CrM,~]=size(Cr);
        aver=mean(Cr);
        if CrM~=0
            for m=1:CrM
                    Dr(i)=Dr(i)+sum((Cr(m,:)-aver).^2);
            end
            Dr(i)=0.5*Dr(i)/CrM; 
        end
    end
    Wk(k)=sum(Dr);
end
end