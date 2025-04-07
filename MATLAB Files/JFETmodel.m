clear all
close all
A = readmatrix('measure_3.csv');
vp =linspace(-5,0,500);
idss =linspace(10^-3,10^-1,500);
lambda = 1/54; %from measurement
%K = (idss/(vp^2));
vds = A(:,3); 
vgs = A(:,1);
input = [vgs, vds];
y = A(:,4);
MinE = 10^8;
y1 = zeros(500,1);
res = zeros(500,1);
E = zeros(500,1);
for i = 1:length(idss)
    for j = 1:length(vp)
        %JFET equations with condition
        for k = 1:size(input)
            if vgs(k) <= vp(j) && vds(k) >= 0
                y1(k)=0;
         %Ohmic region
         elseif vds(k) < (vgs(k) - vp(j)) && vds(k) >= 0
                y1(k) = 2*(idss(i)/vp(j)^2)*((vgs(k)-vp(j) - vds(k)/2 )*vds(k)*(1+(lambda*vds(k))));
         %Saturation region 
            else 
                y1(k)= idss(i)*((1-(vgs(k)/vp(j)))^2)*(1+(lambda*vds(k)));
            end
        end
        res = (y-y1).^2;
        E = sum(res);
        if E < MinE
            MinE = E;
            B =([vp(j),idss(i)]);
        end
    end
end
