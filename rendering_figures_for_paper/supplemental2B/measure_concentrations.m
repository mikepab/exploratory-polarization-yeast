function [localPherConc_poi_em, localPherConc_ves_em] = measure_concentrations(filename_poi,filename_ves)
poi=load(filename_poi);
ves=load(filename_ves);

units='nM';

assert(strcmpi(units,'molecules') || strcmpi(units,'nM'),'invalid units');

localPherConc_poi_em = zeros(100001,10);% Time points x depths x reps
localPherConc_ves_em = zeros(100001,10);

% We only have central bullseyes
shell_boundaries = 2.5:.25:5;
V = zeros(10,1);
for i=2:numel(shell_boundaries)
   V(i-1) = 4/3*pi*shell_boundaries(i)^3 - 4/3*pi*shell_boundaries(i-1)^3; 
end
nM_conversion_factor = 1./(V.*10.^-15)./(6.02.*10.^23).*10.^9;

if strcmpi(units,'nM')
    localPherConc_poi_em(:,:) = poi.nPerShell .* nM_conversion_factor';
    localPherConc_ves_em(:,:) = ves.nPerShell .* nM_conversion_factor';        
elseif strcmpi(units,'molecules')
    localPherConc_poi_em(:,:) = poi.nPerShell;
    localPherConc_ves_em(:,:) = ves.nPerShell;
end
end