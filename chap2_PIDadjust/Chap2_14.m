%Transfer function identification with frequency test
clear all;
close all;

ts=0.001;
a=25;b=133;c=10;
sys=tf(b,[1,a,c]);
dsys=c2d(sys,ts,'z');
[num,den]=tfdata(dsys,'v');%plant

Am=0.5;%�����źŷ�ֵ
kk=0;  

for F=1:0.5:10%F��Ƶ�ʱ仯
    kk=kk+1;%��¼���
    FF(kk)=F;%����Ƶ��
    
    u_1=0.0;u_2=0.0;
    y_1=0;y_2=0;
    
    for k=1:1:20000  %ÿ��Ƶ�ʵ㣬����20K����ʱ��
        time(k)=k*ts;
        
        u(k)=Am*sin(1*2*pi*F*k*ts);%Sine Signal with different frequency
        y(k)=-den(2)*y_1-den(3)*y_2+num(2)*u_1+num(3)*u_2;
        
        u_2=u_1;u_1=u(k);
        y_2=y_1;y_1=y(k);
    end
    
    plot(time,u,'r',time,y,'b'); %Dynamic Simuliation ��������ڲ�ͬƵ���µı仯
    pause(1.0);
    
    for i=10001:1:15000
        fai(1,i-10000)=sin(2*pi*F*i*ts);%��
        fai(2,i-10000)=cos(2*pi*F*i*ts);%��
    end
    Fai=fai';
    fai_in(kk)=0;
    
    Y_out=y(10001:1:15000)';
    cout = inv(Fai'*Fai)*Fai'*Y_out;%inv ��������
    fai_out(kk)=atan(cout(2)/cout(1)); %Phase Frequency(Deg.)
    
    if fai_out(kk)>0
        fai_out(kk)=fai_out(kk)-pi;
    end
    
    Af(kk)=sqrt(cout(1)^2+cout(2)^2);%Magnitude Frequency(dB)
    mag_e(kk)=20*log10(Af(kk)/Am); %in dB. ��ֵ��
    ph_e(kk)=(fai_out(kk)-fai_in(kk))*180/pi;%in Deg ��λ��
    
    if ph_e(kk)>0
        ph_e(kk)=ph_e(kk)-360;
    end
end

FF=FF';
%%%%%%%%%%%%%%%%%%%%%%%% Closed system modelling
mag_el=Af'/Am; %From dB.to ratio ��ֵ��������
ph_el=fai_out'-fai_in';%From Deg. to rad  ���������λ��

hp=mag_el.*(cos(ph_el)+j*sin(ph_el));%Practical frequency response vector

na=2; %Second order transger function
nb=0;
w=2*pi*FF; %in rad./s
%bb and aa gives real numerator and denominator of transfer function
[bb,aa]=invfreqs(hp,w,nb,na);%w(in rad./s) constains the frequency values

G=tf(bb,aa);%Transfer function fitting

figure(2);
bode(sys,'r',G,'k:');
legend('practical model','estimate model');


    