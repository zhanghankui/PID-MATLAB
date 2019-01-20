function dy = PlantModel(t,y,flag,para)
u = para;
J = 0.0067;B = 0.1;

dy = zeros(2,1);%Éú³É2*1È«Áã¾ØÕó
dy(1) = y(2);%dy(1)=y'
dy(2) = -(B/J)*y(2) + (1/J)*u;%dy(2)=y''

% G(s)=1/(Js^2+Bs)=Y(s)/U(s)
% U(s) = JY(s)s^2 + BY(s)s
% u = Jy'' + By'
% y'' = -(B/J)y' + (1/J)*u
