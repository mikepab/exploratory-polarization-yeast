function make_panel()
datasource_sphere = 'C:\Users\mike\Documents\GitHub\pheromone-emission\rossie_paper\no_receiver_sims\higher_release_rate\spheresource\data';
datasource_point = 'C:\Users\mike\Documents\GitHub\pheromone-emission\rossie_paper\no_receiver_sims\higher_release_rate\pointsource\data';

sphere.localPherConc_poi_em = zeros(100001,10,30);
sphere.localPherConc_ves_em = zeros(100001,10,30);
point.localPherConc_poi_em = zeros(100001,10,30);
point.localPherConc_ves_em = zeros(100001,10,30);

for i=1:30
    sphere_file_poi = sprintf('%s\\poi_%02d_processed.mat',datasource_sphere,i);
    sphere_file_ves = sprintf('%s\\ves_%02d_processed.mat',datasource_sphere,i);
    [sphere_poi,sphere_ves] = measure_concentrations(sphere_file_poi,sphere_file_ves);
    
    sphere.localPherConc_poi_em(:,:,i) = sphere_poi;
    sphere.localPherConc_ves_em(:,:,i) = sphere_ves;
    
    point_file_poi = sprintf('%s\\poi_%02d_processed.mat',datasource_point,i);
    point_file_ves = sprintf('%s\\ves_%02d_processed.mat',datasource_point,i);
    [point_poi,point_ves] = measure_concentrations(point_file_poi,point_file_ves);
    
    point.localPherConc_poi_em(:,:,i) = point_poi;
    point.localPherConc_ves_em(:,:,i) = point_ves;
end

sphere.mean_meanconcs_poi = squeeze(mean(mean(sphere.localPherConc_poi_em,1),3));
sphere.std_meanconcs_poi  = squeeze(std(mean(sphere.localPherConc_poi_em,1),[],3));
sphere.mean_meanconcs_ves = squeeze(mean(mean(sphere.localPherConc_ves_em,1),3));
sphere.std_meanconcs_ves  = squeeze(std(mean(sphere.localPherConc_ves_em,1),[],3));
point.mean_meanconcs_poi = squeeze(mean(mean(point.localPherConc_poi_em,1),3));
point.std_meanconcs_poi  = squeeze(std(mean(point.localPherConc_poi_em,1),[],3));
point.mean_meanconcs_ves = squeeze(mean(mean(point.localPherConc_ves_em,1),3));
point.std_meanconcs_ves  = squeeze(std(mean(point.localPherConc_ves_em,1),[],3));

r = 2.75:.25:5.; % midpoints of the simulated regions
[r_analyt,c_analyt]=analytic_soln(150,2.5,1400);

figure('position',[1202         470         451         331]);
% Vesicle point emission
subplot(2,2,1); hold on;
errorbar(r,point.mean_meanconcs_ves,point.std_meanconcs_ves,'k');
plot(r_analyt,c_analyt,'r--');
set(gca,'ylim',[0 0.7],'xlim',[2.5 5]);
title('Vesicle, local');
%legend('Simulation','Analytic');

% Vesicle sphere emission
subplot(2,2,2); hold on;
errorbar(r,sphere.mean_meanconcs_ves,sphere.std_meanconcs_ves,'k');
plot(r_analyt,c_analyt,'r--');
set(gca,'ylim',[0 0.7],'xlim',[2.5 5]);
title('Vesicle, global');
legend('Simulation','Analytic');

% Poisson point emission
subplot(2,2,3); hold on;
errorbar(r,point.mean_meanconcs_poi,point.std_meanconcs_poi,'k');
plot(r_analyt,c_analyt,'r--');
set(gca,'ylim',[0 0.7],'xlim',[2.5 5]);
title('Single molecule, local');
%legend('Simulation','Analytic');

% Poisson sphere emission
subplot(2,2,4); hold on;
errorbar(r,sphere.mean_meanconcs_poi,sphere.std_meanconcs_poi,'k');
plot(r_analyt,c_analyt,'r--');
set(gca,'ylim',[0 0.7],'xlim',[2.5 5]);
title('Single molecule, global');
%legend('Simulation','Analytic');
[~,hy]=suplabel('pheromone (nM)','y');
[~,hx]=suplabel('time (s)','x');
hy.Position(1)=0;
hx.Position(2)=0;

savefig(gcf,'panel.fig');
print(gcf,'-dpng','panel.png','-r300');
print(gcf,'-dsvg','-painters','panel.svg','-r300');
end

