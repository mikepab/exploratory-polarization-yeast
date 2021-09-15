function localPherConc_rc = extract_receiver_data(filename)
load(filename);
write_to_file=true;
units='nM';

assert(strcmpi(units,'molecules') || strcmpi(units,'nM'),'invalid units');


% We only have central bullseyes
V = (2*pi/3*(2.75^3 - 2.5^3))*(1-cos(pi/6));
nM_conversion_factor = 1./(V*10^-15)./(6.02*10^23)*10^9;


localPherConc_rc = bincountmats_rc .* nM_conversion_factor;
end
