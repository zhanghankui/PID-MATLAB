function [sys,x0,str,ts] = s_function(t,x,u,flag)
switch flag,
    case 0,
        [sys,x0,str,ts]=edlInitializeSizes;
    case 1,
        