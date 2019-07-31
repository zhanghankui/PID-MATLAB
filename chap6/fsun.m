%fsun函数
%离散系统最速控制综合函数
%孙彪 孙秀霞
function f=fsun(x1,x2,r,h)
d=r*h*h;
y=x1+h*x2;
ks=0.5*(1+sqrt(1+8*abs(y)/d));
k=sign(ks-fix(ks))+fix(ks);

if abs(y)>d
    s=y/(0.5*ks*(ks-1)*d);
    f=-r*sat((1-0.5*k)*s-((x1+k*h*x2)/((k-1)*d)),1);
else
    f=-r*sat(x2+y/h,h*r);
end
