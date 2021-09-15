function generate_figure_v2()
% v2: 
% Only include angles 1, 3, and 5
% Only include the local
gl_data = extract_receiver_data('vesicle_global_sourcedata/ves_01_processed.mat');
lc_data = extract_receiver_data('vesicle_local_sourcedata/ves_01_processed.mat');

co = [127,205,187;...
      65, 182, 196; ...
      29, 145, 192;...
      34, 94, 168;...
      37, 52, 148;...
      8, 29, 88;...
      0 0 0]/255;
t = 0:.0001:10;

figure('position',[1242         466         506         391]);

subplot(3,1,1); % Angle 1, local
plot(t,lc_data(1,:),'color',co(1,:)); set(gca,'xticklabel',[]);
set(gca,'fontsize',12)
subplot(3,1,2); % Angle 3, local
plot(t,lc_data(3,:),'color',co(3,:)); set(gca,'xticklabel',[]);
set(gca,'fontsize',12)
subplot(3,1,3); % Angle 5, local
plot(t,lc_data(5,:),'color',co(5,:));
set(gca,'fontsize',12)
[~,hy]=suplabel('pheromone (nM)','y');
[~,hx]=suplabel('time (s)','x');
hy.Position(1)=0;
hx.Position(2)=0;
hy.FontSize=14;
hx.FontSize=14;

savefig(gcf,'panel_v2.fig');
print(gcf,'-dpng','panel_v2.png','-r300');
print(gcf,'-dsvg','-painters','panel_v2.svg','-r300');

% Zoom
figure('position',[1242         466         506         391]);
subplot(3,1,1); % Angle 1, local
plot(t,lc_data(1,:),'color',co(1,:)); set(gca,'xticklabel',[]);
set(gca,'xlim',[5.75 5.85]);
set(gca,'fontsize',12)
subplot(3,1,2); % Angle 3, local
plot(t,lc_data(3,:),'color',co(3,:)); set(gca,'xticklabel',[]);
set(gca,'xlim',[5.75 5.85]);
set(gca,'fontsize',12)
subplot(3,1,3); % Angle 5, local
plot(t,lc_data(5,:),'color',co(5,:));
set(gca,'xlim',[5.75 5.85],'xtick',[5.75 5.85],'xticklabel',{'0','0.1'});
set(gca,'fontsize',12)
[~,hy]=suplabel('pheromone (nM)','y');
[~,hx]=suplabel('time (s)','x');
hy.Position(1)=0;
hx.Position(2)=0;
hy.FontSize=14;
hx.FontSize=14;

savefig(gcf,'panel_v2_zoom.fig');
print(gcf,'-dpng','panel_v2_zoom.png','-r300');
print(gcf,'-dsvg','-painters','panel_v2_zoom.svg','-r300');
end
