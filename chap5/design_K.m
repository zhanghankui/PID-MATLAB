close all;

x0=0;%��ֵ
options=optimset('Display','on');
x=fsolve('fun_x',x0,options)
