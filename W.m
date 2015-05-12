clear
clc
%parameters
SZ=10;
TB=40;

samples=40;
A=sqrt(0.1);
W1=W(TB,1);
W2=W(TB,0);

t=[0:TB/samples:SZ*TB-(TB/samples)];
%%input binary stream
Bk=randi([0 1],1,SZ);
%%modulated signal
S=A*cos(kron(W(TB,Bk),ones(1,samples)).*t);
%SN=awgn(S,4);
subplot(4,1,1);

plot(t,S);

%%Noise
S=awgn(S,-4);
subplot(4,1,2);
plot(t,S);

%%Matched Filter
t2=[0:TB/samples:2*(SZ*TB-(TB/samples))];
M1=(A*cos(W1*(TB-t))).*((t>0)-(t>TB));
M2=(A*cos(W2*(TB-t))).*((t>0)-(t>TB));
%%Conv
y1=TB*conv(S,M1);
y2=TB*conv(S,M2);


subplot(4,1,3);
plot(t2,y1);
subplot(4,1,4);
plot(t2,y2);
%%decision
Z=[];
O=[];

for ind=1:SZ
    %fprintf('y1=%f ? y2=%f\n',y1(ind*TB*samples),y2(ind*TB*samples));
    Z=[Z y2(floor(ind*samples)+1)];
    O=[O y1(floor((ind*samples))+1)];
    Bo(ind)=O(ind)>Z(ind);
    Q(ind)=y1(floor(ind*samples)+1)>sqrt(2)*A*A*TB/2;
end
%floor(O)
%floor(Z)
sum(Bo==Bk)
sum(Q==Bk)
%Bk
%Bo
%Q
