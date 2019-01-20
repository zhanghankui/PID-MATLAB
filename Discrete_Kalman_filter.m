%Discrete Kalman filter
%x=Ax+B(u+w(k));
%y=Cx+D+v(k)

function [u]=kalman(u1,u2,u3)
persistent A B C D Q R P x

yv = u2;
