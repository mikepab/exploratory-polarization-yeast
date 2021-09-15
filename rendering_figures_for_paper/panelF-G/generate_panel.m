function generate_panel()
basepath = 'C:\\Users\\mike\\Documents\\GitHub\\pheromone-emission\\rossie_paper\\corrected_exprelease_vesicles\\higher_pheromone_emission_rates\\analysis\\';
[mean_CV, sem_CV] = load_data(basepath);

co = [127,205,187;...
      65, 182, 196; ...
      29, 145, 192;...
      34, 94, 168;...
      37, 52, 148;...
      8, 29, 88;...
      0, 0, 0]/255;

% Global emitter [receiver] vs. local emitter [receiver],
% vesicle secretion.
y   = squeeze(mean_CV(:,2,2,:));
err = squeeze(sem_CV(:,2,2,:));
figure('position',[539   753   318   224]); hold on;
for i=1:7
   bar(i,y(1,i),'facecolor',co(i,:));
   bar(i+8,y(2,i),'facecolor',co(i,:));
   
   errorbar(i, y(1,i), err(1,i), 'k.')
   errorbar(i+8, y(2,i), err(2,i), 'k.')
end
set(gca,'xtick',[4 12],'xticklabel',{'Local','Global'},'ylim',[0 1400]);
ylabel('CV pheromone (nM)');
set(gca,'fontsize',8,'linewidth',2);
savefig('vesicle_secretion');
print(gcf,'-dsvg','-painters','vesicle_secretion.svg','-r300');
print(gcf,'-dpng','vesicle_secretion.png','-r300');

% Global emitter [receiver] vs. local emitter [receiver],
% poisson secretion.
y   = squeeze(mean_CV(:,1,2,:));
err = squeeze(sem_CV(:,1,2,:));
figure('position',[539   753   318   224]); hold on;
for i=1:7
   bar(i,y(1,i),'facecolor',co(i,:));
   bar(i+8,y(2,i),'facecolor',co(i,:));
   
   errorbar(i, y(1,i), err(1,i), 'k.')
   errorbar(i+8, y(2,i), err(2,i), 'k.')
end
set(gca,'xtick',[4 12],'xticklabel',{'Local','Global'},'ylim',[0 1400]);
ylabel('CV pheromone (nM)');
set(gca,'fontsize',8,'linewidth',2);
savefig('poisson_secretion');
print(gcf,'-dsvg','-painters','poisson_secretion.svg','-r300');
print(gcf,'-dpng','poisson_secretion.png','-r300');


end

function [mean_CV, sem_CV] = load_data(basepath)
pointsource_path = sprintf('%s\\pointsource_csv_cv\\',basepath);
spheresource_path = sprintf('%s\\spheresource_csv_cv\\',basepath);

substr1 = {pointsource_path, spheresource_path};
substr2 = {'poi','ves'};
substr3 = {'em','rc'};
substr4 = {'angle_1','angle_2','angle_3','angle_4','angle_5','angle_6','angle_7'};
CV = zeros(2,2,2,7,300); % [point/sphere, poi/ves, em/rc, angles, realiz]

for i=1:numel(substr1)
    for j=1:numel(substr2)
        for k=1:numel(substr3)
            for m = 1:numel(substr4)
                for repid = 1:300
                    % timepts x realizations
                    tmp= csvread(sprintf('%s%s_%02d_processed_%s_%s_cv.csv',substr1{i},substr2{j},repid,substr3{k},substr4{m}));
                    CV(i,j,k,m,repid) = tmp;


                end
            end
        end
    end
end
    
mean_CV = mean(CV,5); % average the CV across simulations.
std_CV  = std(CV,[],5); % stdev of CV across simulations.
sem_CV  = std_CV/sqrt(300); % standard error of the mean


end