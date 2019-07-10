%Levant提出了一种基于滑模技术的非线性微分器，其中二阶滑模微分表达式为
%  dx=u
%  u=u1-lambda*(abs(x-v(t)))^0.5*sgn(x-v(t))
%  du1=-alfa*sgn(x-v(t))
%  其中, alfa>C,lambda^2>=4C(alfa+C)/(alfa-C)
function [sys,x0,str,ts]=Differentiator(t,x,u,flag)
switch flag,
    case 0,
        [sys,x0,str,ts]=mdlInitializeSizes;
    case 1,
        sys=mdlDerivatives(t,x,u);
    case 3,
        sys=mdlOutputs(t,x,u);
    case {2,4,9}
        sys=[];
    otherwise
        error(['Unhandled flag =',num2str(flag)]);
end

function [sys,x0,str,ts]=mdlInitializeSizes
sizes=simsizes;
sizes.NumContStates = 2;
sizes.NumDiscStates = 0;
sizes.NumOutputs = 2;
sizes.NumInputs = 1;
sizes.DirFeedthrough = 1;
sizes.NumSampleTimes = 1;
sys = simsizes(sizes);
x0 = [0 0];
str = [];
ts = [0 0];

function sys = mdlDerivatives(t,x,u)
vt = u(1);
e = x(1)-vt;
alfa = 1;
nmn = 5;
sys(1)=x(2)-nmn*(abs(e))^0.5*sign(e);
sys(2)=-alfa*sign(e);

function sys=mdlOutputs(t,x,u)
sys=x;
