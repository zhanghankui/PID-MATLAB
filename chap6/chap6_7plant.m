function dy=PlantModel(t,y,flag,p)
ut=p;
dy=zeros(2,1);

f=-25*y(2);%unknown part
b=133;

dy(1)=y(2);
dy(2)=f+b*ut;