function extract_data(filename)
load(filename);
write_to_file=true;
units='nM';

assert(strcmpi(units,'molecules') || strcmpi(units,'nM'),'invalid units');


% We only have central bullseyes
V = (2*pi/3*(2.75^3 - 2.5^3))*(1-cos(pi/6));
nM_conversion_factor = 1./(V*10^-15)./(6.02*10^23)*10^9;
times = 0:.0001:10;


localPherConc_em = bincountmats_em .* nM_conversion_factor;
localPherConc_rc = bincountmats_rc .* nM_conversion_factor;
%localPherConc_ves_em = bincountmats_ves_em .* nM_conversion_factor;
%localPherConc_ves_rc = bincountmats_ves_rc .* nM_conversion_factor;

plottable_indices = 1:100001;

% Variables for CSV writing
Times = times(plottable_indices)';

[~,fname_noext,~]=fileparts(filename);

if write_to_file
    for i=1:7
        currmat = squeeze(mean(localPherConc_em(i,:),2));
        writematrix(currmat,sprintf('%s_em_angle_%i.csv',fname_noext,i));

        currmat = squeeze(mean(localPherConc_rc(i,:),2));
        writematrix(currmat,sprintf('%s_rc_angle_%i.csv',fname_noext,i));
        
        currmat = squeeze(max(localPherConc_em(i,:),[],2));
        writematrix(currmat,sprintf('%s_em_angle_%i_max.csv',fname_noext,i));

        currmat = squeeze(max(localPherConc_rc(i,:),[],2));
        writematrix(currmat,sprintf('%s_rc_angle_%i_max.csv',fname_noext,i));
    end
end

end
