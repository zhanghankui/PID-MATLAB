%Discrete Kalman filter
%x=Ax+B(u+w(k));
%y=Cx+D+v(k)

function [u]=kalman(u1,u2,u3)
persistent A B C D Q R P x

yv = u2;
if u3 == 0%初始化
	x = zeros(2,1);
	ts = 0.001;
	a=25;b=133;
	sys = tf(b,[1,a,0]);
	[A1,B1,C1,D1] = tf2ss(b,[1,a,0]);%传递函数只有一个，但状态方程可以有不同形式
	[A,B,C,D]=c2dm(A1,B1,C1,D1,ts,'z');%状态方程离散化
	
	Q=1;           %Covariances of w
	R=1;           %Covariances of v
	P = B*Q*B';    %Initial error covariance
end

%Measurement update
Mn = P*C'/(C*P*C'+R);
P = A*P*A'+B*Q*B';
P = (eye(2)-Mn*C)*P;

x = A*x+Mn*(yv-C*A*x);


ye = C*x+D;        %Filtered value

u(1) = ye;         %Filtered signal
u(2) = yv;         %Signal with noise

errcov = C*P*C';   %Convariance of estimation error

%Time update
x = A*x+B*u1;

