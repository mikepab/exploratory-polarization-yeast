function [r,c] = analytic_soln(D,R,release_rate)

r = 2.5:.25:5.25;
%r=linspace(R,R+2.5,100); % distance from surface of sphere

%c = R.^2 .* release_rate/(4*pi*R.^2)  ./ (D.*r);

C0 = release_rate/(4*pi*R*D);
c = C0.*R./(r); % = release_rate * R / (4*pi*r*R*D), Debraj

% convert from molecules / um^3 to nM
c = c*1.661;

c = mean([c(1:end-1); c(2:end)],1);
r = mean([r(1:end-1); r(2:end)],1);
end