function [u]  = pidsimf(in)
persistent pidmat errori error_1
%#codegen
if in(1) == 0
    errori = 0;
    error_1 = 0;
end
ts = 0.001;
kp = 1.5;
ki = 2.0;
kd = 0.05;
error = in(2);
errord = (error-error_1)/ts;
errori = errori+error*ts;%error »ý·Ö

u = kp*error+ki*errori+kd*errord;
error_1 = error;

