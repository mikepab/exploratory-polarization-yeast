function generate_figure()
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

figure('position',[1110         609         409         280]);
subplot(7,2,1); % Angle 1, global
plot(t,gl_data(1,:),'color',co(1,:)); set(gca,'xticklabel',[]);
subplot(7,2,3); % Angle 2, global
plot(t,gl_data(2,:),'color',co(2,:)); set(gca,'xticklabel',[]);
subplot(7,2,5); % Angle 3, global
plot(t,gl_data(3,:),'color',co(3,:)); set(gca,'xticklabel',[]);
subplot(7,2,7); % Angle 4, global 
plot(t,gl_data(4,:),'color',co(4,:)); set(gca,'xticklabel',[]);
subplot(7,2,9); % Angle 5, global
plot(t,gl_data(5,:),'color',co(5,:)); set(gca,'xticklabel',[]);
subplot(7,2,11); % Angle 6, global
plot(t,gl_data(6,:),'color',co(6,:)); set(gca,'xticklabel',[]);
subplot(7,2,13); % Angle 7, global
plot(t,gl_data(7,:),'color',co(7,:));


subplot(7,2,2); % Angle 1, global
plot(t,lc_data(1,:),'color',co(1,:)); set(gca,'xticklabel',[]);
subplot(7,2,4); % Angle 2, global
plot(t,lc_data(2,:),'color',co(2,:)); set(gca,'xticklabel',[]);
subplot(7,2,6); % Angle 3, global
plot(t,lc_data(3,:),'color',co(3,:)); set(gca,'xticklabel',[]);
subplot(7,2,8); % Angle 4, global
plot(t,lc_data(4,:),'color',co(4,:)); set(gca,'xticklabel',[]);
subplot(7,2,10); % Angle 5, global
plot(t,lc_data(5,:),'color',co(5,:)); set(gca,'xticklabel',[]);
subplot(7,2,12); % Angle 6, global
plot(t,lc_data(6,:),'color',co(6,:)); set(gca,'xticklabel',[]);
subplot(7,2,14); % Angle 7, global
plot(t,lc_data(7,:),'color',co(7,:));

[~,hy]=suplabel('pheromone (nM)','y');
[~,hx]=suplabel('time (s)','x');
hy.Position(1)=0;
hx.Position(2)=0;

savefig(gcf,'panel.fig');
print(gcf,'-dpng','panel.png','-r300');
print(gcf,'-dsvg','-painters','panel.svg','-r300');
end
