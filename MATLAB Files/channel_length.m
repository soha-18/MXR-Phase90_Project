clear all
close all
A = readmatrix('measure_1.csv');
B = readmatrix('measure_2.csv');
C = readmatrix('measure_3.csv');
D = readmatrix('measure_4.csv');
E = readmatrix('measure_5.csv');
F = readmatrix('measure_6.csv');
G = readmatrix('measure_7.csv');
H = readmatrix('measure_8.csv');
I = readmatrix('measure_9.csv');
J = readmatrix('measure_10.csv');
%K = (idss/(vp^2));
vds = [A(:,3),B(:,3),C(:,3),D(:,3),E(:,3),F(:,3),G(:,3),H(:,3),I(:,3),J(:,3)] ; 
vgs = [A(:,1),B(:,1),C(:,1),D(:,1),E(:,1),F(:,1),G(:,1),H(:,1),I(:,1),J(:,1)];
id = [A(:,4),B(:,4),C(:,4),D(:,4),E(:,4),F(:,4),G(:,4),H(:,4),I(:,4),J(:,4)];
vds_m = vds;
vds_m(1:200,:)= [];
id_m = id;
id_m(1:200,:)= [];
xq = transpose(linspace(-5000,-1,1000));
vdsq = interp1(vds_m,xq,'linear','extrap');
idq = interp1(id_m,xq,'linear', 'extrap');

plot(vdsq(:,1),idq(:,1),'--',vds(:,1), id(:,1),vdsq(:,2),idq(:,2),'--',vds(:,2), id(:,2),vdsq(:,3),idq(:,3),'--',vds(:,3), id(:,3),vdsq(:,4),idq(:,4),'--',vds(:,4), id(:,4),vdsq(:,5),idq(:,5),'--',vds(:,5), id(:,5),'LineWidth',2)
hold on 
plot(vdsq(:,6),idq(:,6),'--',vds(:,6), id(:,6),vdsq(:,7),idq(:,7),'--',vds(:,7), id(:,7),vdsq(:,8),idq(:,8),'--',vds(:,8), id(:,8),vdsq(:,9),idq(:,9),'--',vds(:,9), id(:,9),vdsq(:,10),idq(:,10),'--',vds(:,10), id(:,10),'LineWidth',2)

hold off
xlabel('Vds in V','interpreter','latex','fontsize',16);
ylabel('Id in A','interpreter','latex','fontsize',16);
title('I-V characteristics of JFET','interpreter','latex','fontsize',16);
grid on
xline(-58.3,'--r','LineWidth', 1);
xline(-47.8,'-.r','LineWidth', 1);
line([0,0], ylim, 'Color', 'k', 'LineWidth', 1); % Draw line for Y axis.
line(xlim, [0,0], 'Color', 'k', 'LineWidth', 1); % Draw line for X axis.


