clear

A=2;
fm=5;

ts=0.01;
t=0:ts:2;

x=A*cos(2*pi*fm*t)+cos(2*pi*t);


figure(1)
plot(t,x);

fs=10;
ts_2=1/fs;

sample_step=floor(ts_2/ts);

t2=0:ts_2:2;

x_s(1)=x(1);
for i=1:length(t2)-1
    x_s(i+1)=x(1+i*sample_step);
end

hold on
stem(t2,x_s);

y=zeros(length(t2), length(t));
for i=1:length(t2)
    y(i,:)=x_s(i)*sinc((t-(i-1)*ts_2)/ts_2);
end
y=sum(y);
plot(t,y);legend('origin','sample','recon');

