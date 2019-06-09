function dy=PlantModel(t,y,flag,p1,p2)
ut=p1;
time=p2;
dy=zeros(3,1);
dy(1)=y(2);
dy(2)=y(3);
dy(3)=-87.35*dy(2)-10470*dy(1)+523500*ut;