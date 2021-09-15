clear; load('processed_narrow_3D_central_bullseyes.mat');
write_to_file=true;
units='nM';

assert(strcmpi(units,'molecules') || strcmpi(units,'nM'),'invalid units');

localPherConc_poi_em = zeros(110001,10,30);% Time points x depths x reps
localPherConc_ves_em = zeros(110001,10,30);

% We only have central bullseyes
shell_boundaries = 2.5:.25:5;
V = zeros(10,1);
for i=2:numel(shell_boundaries)
   V(i-1) = 4/3*pi*shell_boundaries(i)^3 - 4/3*pi*shell_boundaries(i-1)^3; 
end
nM_conversion_factor = 1./(V.*10.^-15)./(6.02.*10.^23).*10.^9;
times = 0:.0001:11;

if strcmpi(units,'nM')
    for i=1:30
        localPherConc_poi_em(:,:,i) = nPerShell_poi{i} .* nM_conversion_factor';
        localPherConc_ves_em(:,:,i) = nPerShell_ves{i} .* nM_conversion_factor';        
    end
elseif strcmpi(units,'molecules')
    for i=1:30
        localPherConc_poi_em(:,:,i) = nPerShell_poi{i};
        localPherConc_ves_em(:,:,i) = nPerShell_ves{i};
    end    
end

% Show 
co=copper(10);
figure('position',[871   570   805   298]); hold on;
for i=1:10
    plot(times,smooth(localPherConc_poi_em(:,i,1),1000),'color',co(i,:),'linewidth',2);
end
legend({'0-0.25',...
        '0.25-0.50',...
        '0.50-0.75',...
        '0.75-1.00',...
        '1.00-1.25',...
        '1.25-1.50',...
        '1.50-1.75',...
        '1.75-2.00',...
        '2.00-2.25',...
        '2.25-2.50'},'location','eastoutside');
xlabel('time (s)')
ylabel('pheromone (nM)')
title('1 realization, all shells, 0.1s smoothing window');
savefig(gcf,'example_smoothed_1ex');
print(gcf,'-dpng','example_smoothed_1ex.png','-r300');

% Take average of timeseries in each simulation, then plot mean and std of those.
% This is effectively the mean/std of the average pheromone around the emitter.
mean_meanconcs_poi = squeeze(mean(mean(localPherConc_poi_em(20001:end,:,:),1),3));
std_meanconcs_poi  = squeeze(std(mean(localPherConc_poi_em(20001:end,:,:),1),[],3));
mean_meanconcs_ves = squeeze(mean(mean(localPherConc_ves_em(20001:end,:,:),1),3));
std_meanconcs_ves  = squeeze(std(mean(localPherConc_ves_em(20001:end,:,:),1),[],3));

figure;
subplot(2,1,1)
errorbar(1:10,mean_meanconcs_poi,std_meanconcs_poi,'k');
set(gca,'xtick',1:10,'xticklabel',{'0-0.25',...
                                   '0.25-0.50',...
                                   '0.50-0.75',...
                                   '0.75-1.00',...
                                   '1.00-1.25',...
                                   '1.25-1.50',...
                                   '1.50-1.75',...
                                   '1.75-2.00',...
                                   '2.00-2.25',...
                                   '2.25-2.50'},'xticklabelrotation',90);
ylabel('time-averaged pheromone (nM)')
title('Poisson release')
grid on;
set(gca,'xlim',[.5 10.5],'ylim',[0 0.3])
subplot(2,1,2)
errorbar(1:10,mean_meanconcs_ves,std_meanconcs_ves,'k');
set(gca,'xtick',1:10,'xticklabel',{'0-0.25',...
                                   '0.25-0.50',...
                                   '0.50-0.75',...
                                   '0.75-1.00',...
                                   '1.00-1.25',...
                                   '1.25-1.50',...
                                   '1.50-1.75',...
                                   '1.75-2.00',...
                                   '2.00-2.25',...
                                   '2.25-2.50'},'xticklabelrotation',90);
ylabel('time-averaged pheromone (nM)')
title('Vesicle release')
grid on;
set(gca,'xlim',[.5 10.5],'ylim',[0 0.3])
savefig(gcf,'mean_std_pointsource');
print(gcf,'-dpng','mean_std_pointsource.png','-r300');

