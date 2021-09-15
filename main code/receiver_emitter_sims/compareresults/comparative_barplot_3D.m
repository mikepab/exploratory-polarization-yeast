timeAvg_conc = zeros(2,4,7,30); % [point/sphere, poiEm/poiRc/vesEm/vesRc, angles, realiz]
std_conc = zeros(2,4,7,30);
timePeak_conc = zeros(2,4,7,30);
substr1 = {'..\\pointsource\\data\\', '..\\spheresource\\data\\'};
substr2 = {'poi_em\\','poi_rc\\','ves_em\\','ves_rc\\'};
substr3 = {'angle_1.csv','angle_2.csv','angle_3.csv','angle_4.csv','angle_5.csv','angle_6.csv','angle_7.csv'};

for i=1:numel(substr1)
    for j=1:numel(substr2)
        for k=1:numel(substr3)
            % timepts x realizations
            tmp = csvread(fullfile(substr1{i},substr2{j},substr3{k}));
            
            tmp = tmp(20001:end,2:end); % first column is the time value. throw out first 20000 datapts for equilibration
            for realiz = 1:30
                timeAvg_conc(i,j,k,realiz) = mean(tmp(:,realiz));
                %std_conc(i,j,k,realiz)  = std(tmp(:,realiz));
                timePeak_conc(i,j,k,realiz) = max(tmp(:,realiz));
            end            
        end
    end
end
    
mean_avgconc = mean(timeAvg_conc,4); % average the time-averaged conc., across simulations.
std_avgconc  = std(timeAvg_conc,[],4); % stdev of time-averaged conc., across simulations.
sem_avgconc  = std_avgconc/sqrt(30); % standard error of the mean
mean_peakconc = mean(timePeak_conc,4); % average the time-peak conc., across simulations.
std_peakconc = std(timePeak_conc,[],4); % average the time-peak conc., across simulations.
sem_peakconc = std_peakconc/sqrt(30);

co = [127,205,187;...
      65, 182, 196; ...
      29, 145, 192;...
      34, 94, 168;...
      37, 52, 148;...
      8, 29, 88;...
      0, 0, 0]/255;

% Poisson, point-source, time-average
y   = squeeze(mean_avgconc(1,1:2,:));
err = squeeze(sem_avgconc(1,1:2,:));
figure; hold on;
for i=1:7
   bar(i,y(1,i),'facecolor',co(8-i,:));
   bar(i+8,y(2,i),'facecolor',co(i,:));
   
   errorbar(i, y(1,i), err(1,i), 'k.')
   errorbar(i+8, y(2,i), err(2,i), 'k.')
end

set(gca,'xtick',[4 12],'xticklabel',{'Emitter','Receiver'});
ylabel('Time-averaged pheromone (nM)');
title('Poisson, point source');
set(gca,'fontsize',12,'linewidth',2);
savefig(['poisson_pointsource_timeaverage']);
print(gcf,'-dsvg','-painters',['poisson_pointsource_timeaverage' '.svg'],'-r300');
print(gcf,'-dpng',['poisson_pointsource_timeaverage.png'],'-r300');

% Vesicle, point-source, time-average
y   = squeeze(mean_avgconc(1,3:4,:));
err = squeeze(sem_avgconc(1,3:4,:));
figure; hold on;
for i=1:7
   bar(i,y(1,i),'facecolor',co(8-i,:));
   bar(i+8,y(2,i),'facecolor',co(i,:));
   
   errorbar(i, y(1,i), err(1,i), 'k.')
   errorbar(i+8, y(2,i), err(2,i), 'k.')
end

set(gca,'xtick',[4 12],'xticklabel',{'Emitter','Receiver'});
ylabel('Time-averaged pheromone (nM)');
title('Vesicle, point source');
set(gca,'fontsize',12,'linewidth',2);
savefig(['vesicle_pointsource_timeaverage']);
print(gcf,'-dsvg','-painters',['vesicle_pointsource_timeaverage' '.svg'],'-r300');
print(gcf,'-dpng',['vesicle_pointsource_timeaverage.png'],'-r300');

% Poisson, sphere-source, time-average
y   = squeeze(mean_avgconc(2,1:2,:));
err = squeeze(sem_avgconc(2,1:2,:));
figure; hold on;
for i=1:7
   bar(i,y(1,i),'facecolor',co(8-i,:));
   bar(i+8,y(2,i),'facecolor',co(i,:));
   
   errorbar(i, y(1,i), err(1,i), 'k.')
   errorbar(i+8, y(2,i), err(2,i), 'k.')
end

set(gca,'xtick',[4 12],'xticklabel',{'Emitter','Receiver'});
ylabel('Time-averaged pheromone (nM)');
title('Poisson, sphere source');
set(gca,'fontsize',12,'linewidth',2);
savefig(['poisson_spheresource_timeaverage']);
print(gcf,'-dsvg','-painters',['poisson_spheresource_timeaverage' '.svg'],'-r300');
print(gcf,'-dpng',['poisson_spheresource_timeaverage.png'],'-r300');

% Vesicle, sphere-source, time-average
y   = squeeze(mean_avgconc(2,3:4,:));
err = squeeze(sem_avgconc(2,3:4,:));
figure; hold on;
for i=1:7
   bar(i,y(1,i),'facecolor',co(8-i,:));
   bar(i+8,y(2,i),'facecolor',co(i,:));
   
   errorbar(i, y(1,i), err(1,i), 'k.')
   errorbar(i+8, y(2,i), err(2,i), 'k.')
end

set(gca,'xtick',[4 12],'xticklabel',{'Emitter','Receiver'});
ylabel('Time-averaged pheromone (nM)');
title('Vesicle, sphere source');
set(gca,'fontsize',12,'linewidth',2);
savefig(['vesicle_spheresource_timeaverage']);
print(gcf,'-dsvg','-painters',['vesicle_spheresource_timeaverage' '.svg'],'-r300');
print(gcf,'-dpng',['vesicle_spheresource_timeaverage.png'],'-r300');

% Poisson, point-source, peak
y   = squeeze(mean_peakconc(1,1:2,:));
err = squeeze(sem_peakconc(1,1:2,:));
figure; hold on;
for i=1:7
   bar(i,y(1,i),'facecolor',co(8-i,:));
   bar(i+8,y(2,i),'facecolor',co(i,:));
   
   errorbar(i, y(1,i), err(1,i), 'k.')
   errorbar(i+8, y(2,i), err(2,i), 'k.')
end

set(gca,'xtick',[4 12],'xticklabel',{'Emitter','Receiver'});
ylabel('peak pheromone (nM)');
title('Poisson, point source');
set(gca,'fontsize',12,'linewidth',2);
savefig(['poisson_pointsource_peakconc']);
print(gcf,'-dsvg','-painters',['poisson_pointsource_peakconc' '.svg'],'-r300');
print(gcf,'-dpng',['poisson_pointsource_peakconc.png'],'-r300');

% Vesicle, point-source, peak
y   = squeeze(mean_peakconc(1,3:4,:));
err = squeeze(sem_peakconc(1,3:4,:));
figure; hold on;
for i=1:7
   bar(i,y(1,i),'facecolor',co(8-i,:));
   bar(i+8,y(2,i),'facecolor',co(i,:));
   
   errorbar(i, y(1,i), err(1,i), 'k.')
   errorbar(i+8, y(2,i), err(2,i), 'k.')
end

set(gca,'xtick',[4 12],'xticklabel',{'Emitter','Receiver'});
ylabel('peak pheromone (nM)');
title('Vesicle, point source');
set(gca,'fontsize',12,'linewidth',2);
savefig(['vesicle_pointsource_peakconc']);
print(gcf,'-dsvg','-painters',['vesicle_pointsource_peakconc' '.svg'],'-r300');
print(gcf,'-dpng',['vesicle_pointsource_peakconc.png'],'-r300');

% Poisson, sphere-source, peak
y   = squeeze(mean_peakconc(2,1:2,:));
err = squeeze(sem_peakconc(2,1:2,:));
figure; hold on;
for i=1:7
   bar(i,y(1,i),'facecolor',co(8-i,:));
   bar(i+8,y(2,i),'facecolor',co(i,:));
   
   errorbar(i, y(1,i), err(1,i), 'k.')
   errorbar(i+8, y(2,i), err(2,i), 'k.')
end

set(gca,'xtick',[4 12],'xticklabel',{'Emitter','Receiver'});
ylabel('peak pheromone (nM)');
title('Poisson, sphere source');
set(gca,'fontsize',12,'linewidth',2);
savefig(['poisson_spheresource_peakconc']);
print(gcf,'-dsvg','-painters',['poisson_spheresource_peakconc' '.svg'],'-r300');
print(gcf,'-dpng',['poisson_spheresource_peakconc.png'],'-r300');

% Vesicle, sphere-source, peak
y   = squeeze(mean_peakconc(2,3:4,:));
err = squeeze(sem_peakconc(2,3:4,:));
figure; hold on;
for i=1:7
   bar(i,y(1,i),'facecolor',co(8-i,:));
   bar(i+8,y(2,i),'facecolor',co(i,:));
   
   errorbar(i, y(1,i), err(1,i), 'k.')
   errorbar(i+8, y(2,i), err(2,i), 'k.')
end

set(gca,'xtick',[4 12],'xticklabel',{'Emitter','Receiver'});
ylabel('peak pheromone (nM)');
title('Vesicle, sphere source');
set(gca,'fontsize',12,'linewidth',2);
savefig(['vesicle_spheresource_peakconc']);
print(gcf,'-dsvg','-painters',['vesicle_spheresource_peakconc' '.svg'],'-r300');
print(gcf,'-dpng',['vesicle_spheresource_peakconc.png'],'-r300');


