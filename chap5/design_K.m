close all;

x0=0;%³õÖµ
options=optimset('Display','on');
x=fsolve('fun_x',x0,options)
