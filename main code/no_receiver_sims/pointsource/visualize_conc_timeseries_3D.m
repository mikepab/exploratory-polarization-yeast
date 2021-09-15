clear; load('processed_narrow_3D_central_bullseyes.mat');
write_to_file=true;
units='nM';

assert(strcmpi(units,'molecules') || strcmpi(units,'nM'),'invalid units');


localPherConc_det_em = zeros(110001,7,30);
localPherConc_det_rc = zeros(110001,7,30);
localPherConc_poi_em = zeros(110001,7,30);
localPherConc_poi_rc = zeros(110001,7,30);
localPherConc_ves_em = zeros(110001,7,30);
localPherConc_ves_rc = zeros(110001,7,30);

% We only have central bullseyes
V = (2*pi/3*(2.75^3 - 2.5^3))*(1-cos(pi/6));
nM_conversion_factor = 1./(V*10^-15)./(6.02*10^23)*10^9;
times = 0:.0001:11;

if strcmpi(units,'nM')
    for i=1:30
        localPherConc_poi_em(:,:,i) = bincountmats_poi_em{i}' .* nM_conversion_factor;
        localPherConc_poi_rc(:,:,i) = bincountmats_poi_rc{i}' .* nM_conversion_factor;
        localPherConc_ves_em(:,:,i) = bincountmats_ves_em{i}' .* nM_conversion_factor;
        localPherConc_ves_rc(:,:,i) = bincountmats_ves_rc{i}' .* nM_conversion_factor;
    end
elseif strcmpi(units,'molecules')
    for i=1:30
        localPherConc_poi_em(:,:,i) = bincountmats_poi_em{i}';
        localPherConc_poi_rc(:,:,i) = bincountmats_poi_rc{i}';
        localPherConc_ves_em(:,:,i) = bincountmats_ves_em{i}';
        localPherConc_ves_rc(:,:,i) = bincountmats_ves_rc{i}';
    end    
end
plottable_indices = 1:110001;

% Variables for CSV writing
Times = times(plottable_indices)';

if write_to_file
    for i=1:7
        mkdir('data/');
        mkdir('data/poi_em/');
        currmat = cat(2,Times,squeeze(localPherConc_poi_em(:,i,:)));
        writematrix(currmat,fullfile('data/poi_em/',sprintf('angle_%i.csv',i)));

        mkdir('data/');
        mkdir('data/poi_rc/');
        currmat = cat(2,Times,squeeze(localPherConc_poi_rc(:,i,:)));
        writematrix(currmat,fullfile('data/poi_rc',sprintf('angle_%i.csv',i)));

        mkdir('data/');
        mkdir('data/ves_em/');
        currmat = cat(2,Times,squeeze(localPherConc_ves_em(:,i,:)));
        writematrix(currmat,fullfile('data/ves_em/',sprintf('angle_%i.csv',i)));

        mkdir('data/');
        mkdir('data/ves_rc/');
        currmat = cat(2,Times,squeeze(localPherConc_ves_rc(:,i,:)));
        writematrix(currmat,fullfile('data/ves_rc',sprintf('angle_%i.csv',i)));
    end
end
co = [127,205,187;...
      65, 182, 196; ...
      29, 145, 192;...
      34, 94, 168;...
      37, 52, 148;...
      8, 29, 88;...
      0 0 0]/255;

figure('position',[1337         216         584         653]);
set(gcf,'defaultLineLineWidth',2);
%set(gcf,'defaultAxesColorOrder',co);
for i=1:7
    subplot(7,2,(i-1)*2+1)
    plot(times,squeeze(localPherConc_poi_em(:,7-i+1,1)),'linewidth',1,'color',co(i,:));
    set(gca,'xlim',[0 10],'fontsize',14); grid on;
    %plot([times(1) times(end)],[660*nM_conversion_factors(6) 660*nM_conversion_factors(6)],'k--');
end
for i=1:7
    subplot(7,2,i*2)
    plot(times,squeeze(localPherConc_poi_rc(:,i,1)),'linewidth',1,'color',co(i,:));
    set(gca,'xlim',[0 10],'fontsize',14); grid on;
    %plot([times(1) times(end)],[660*nM_conversion_factors(6) 660*nM_conversion_factors(6)],'k--');
end
[~,hx]=suplabel('time (s)','x');
[~,hy]=suplabel(sprintf('pheromone (%s)',units),'y');
sgtitle('Poisson (Emitter, Receiver)');
set(hx,'FontSize',20,'Position',[0.5 0 0]);
set(hy,'FontSize',20,'Position',[-0.01 0.5 0]);
savefig(sprintf('poisson_oneex_%s',units));
%print(gcf,'-dsvg','-painters',['deterministic_oneex' '.svg'],'-r300');
print(gcf,'-dpng',sprintf('poisson_oneex_%s.png',units),'-r300');


% VESICLE
figure('position',[1337         216         584         653]);
set(gcf,'defaultLineLineWidth',2);
%set(gcf,'defaultAxesColorOrder',co);
for i=1:7
    subplot(7,2,(i-1)*2+1)
    plot(times,squeeze(localPherConc_ves_em(:,7-i+1,1)),'linewidth',1,'color',co(i,:));
    set(gca,'xlim',[0 10],'fontsize',14); grid on;
    %plot([times(1) times(end)],[660*nM_conversion_factors(6) 660*nM_conversion_factors(6)],'k--');
end
for i=1:7
    subplot(7,2,i*2)
    plot(times,squeeze(localPherConc_ves_rc(:,i,1)),'linewidth',1,'color',co(i,:));
    set(gca,'xlim',[0 10],'fontsize',14); grid on;
    %plot([times(1) times(end)],[660*nM_conversion_factors(6) 660*nM_conversion_factors(6)],'k--');
end
[~,hx]=suplabel('time (s)','x');
[~,hy]=suplabel(sprintf('pheromone (%s)',units),'y');
sgtitle('Vesicle (Emitter, Receiver)');
set(hx,'FontSize',20,'Position',[0.5 0 0]);
set(hy,'FontSize',20,'Position',[-0.01 0.5 0]);
savefig(sprintf('vesicle_oneex_%s',units));
%print(gcf,'-dsvg','-painters',['deterministic_oneex' '.svg'],'-r300');
print(gcf,'-dpng',sprintf('vesicle_oneex_%s.png',units),'-r300');
