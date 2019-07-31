%±¥ºÍº¯Êý
function f=sat(x,r)
if abs(x)>r
    f=sign(x);
else
    f=x/r;
end
