sph=load('..\\spheresource\processed_narrow_3D_central_bullseyes.mat');
pts=load('..\\pointsource\processed_narrow_3D_central_bullseyes.mat');

poi_sph = cell2mat(sph.npher_poi_all');
ves_sph = cell2mat(sph.npher_ves_all');

poi_pts = cell2mat(pts.npher_poi_all');
ves_pts = cell2mat(pts.npher_ves_all');

figure;
subplot(3,3,1);
plot(0:.0001:11,poi_pts);
title('Poisson, point source')
set(gca,'ylim',[0 100])

subplot(3,3,2);
plot(0:.0001:11,poi_sph);
title('Poisson, sphere source')
set(gca,'ylim',[0 100])

subplot(3,3,3); 
histogram(poi_pts(:),'binwidth',1,'edgecolor','none'); hold on;
histogram(poi_sph(:),'binwidth',1,'edgecolor','none'); hold on;
legend('pts','sph');
title('Poisson, sphere source')
camroll(90); set(gca,'ydir','reverse');
set(gca,'xlim',[0 100])

subplot(3,3,4);
plot(0:.0001:11,ves_pts);
title('Vesicle, point source')
set(gca,'ylim',[0 1500])

subplot(3,3,5);
plot(0:.0001:11,ves_sph);
title('Vesicle, sphere source')
set(gca,'ylim',[0 1500])

subplot(3,3,6); 
histogram(ves_pts(:),'binwidth',1,'edgecolor','none'); hold on;
histogram(ves_sph(:),'binwidth',1,'edgecolor','none'); hold on;
legend('pts','sph');
title('Vesicle, point source')
camroll(90); set(gca,'ydir','reverse');
set(gca,'xlim',[0 1500])

subplot(3,3,7);
plot(0:.0001:11,mean(ves_pts,2));
title('Vesicle, point source (sim-mean)')
set(gca,'ylim',[0 100])

subplot(3,3,8);
plot(0:.0001:11,mean(ves_sph,2));
title('Vesicle, sphere source (sim-mean)')
set(gca,'ylim',[0 100])


subplot(3,3,9); 
histogram(mean(ves_pts,2),'binwidth',1,'edgecolor','none'); hold on;
histogram(mean(ves_sph,2),'binwidth',1,'edgecolor','none'); hold on;
legend('pts','sph');
title('Vesicle, point source')
camroll(90); set(gca,'ydir','reverse');
set(gca,'xlim',[0 100])

[~,hx]=suplabel('time (s)','x');
[~,hy]=suplabel('total pheromone','y');
