function generate_schematic
d_sphere = 5; sep_dist = 0.25;
[sph1XYZ,sph2XYZ] = get_sphere_locations(d_sphere,sep_dist,40);
[newXYZmat1,...
 newXYZmat2,...
 newXYZmat3,...
 newXYZmat4,...
 newXYZmat5,...
 newXYZmat6,...
 newXYZmat7] = get_patch_locations(d_sphere, sep_dist, 150);

co = flipud([127,205,187;...
      65, 182, 196; ...
      29, 145, 192;...
      34, 94, 168;...
      37, 52, 148;...
      8, 29, 88;...
      0 0 0])/255;

figure('position',[680   687   461   291]);
axis image
hold on; box on;
surf(sph1XYZ{1},sph1XYZ{2},sph1XYZ{3},'facecolor','none');
surf(sph2XYZ{1},sph2XYZ{2},sph2XYZ{3},'facecolor','none');
plot3(newXYZmat1(:,1),newXYZmat1(:,2),newXYZmat1(:,3),'.','color',co(1,:))
plot3(newXYZmat2(:,1),newXYZmat2(:,2),newXYZmat2(:,3),'.','color',co(2,:))
plot3(newXYZmat3(:,1),newXYZmat3(:,2),newXYZmat3(:,3),'.','color',co(3,:))
plot3(newXYZmat4(:,1),newXYZmat4(:,2),newXYZmat4(:,3),'.','color',co(4,:))
plot3(newXYZmat5(:,1),newXYZmat5(:,2),newXYZmat5(:,3),'.','color',co(5,:))
plot3(newXYZmat6(:,1),newXYZmat6(:,2),newXYZmat6(:,3),'.','color',co(6,:))
plot3(newXYZmat7(:,1),newXYZmat7(:,2),newXYZmat7(:,3),'.','color',co(7,:))

axis([-5.8  5.8   -2.9    2.9   -2.9    2.9]);
view(15.6,36.5696); grid on;
xlabel('x'); ylabel('y'); zlabel('z');
set(gca,'fontsize',16);
savefig(gcf,'schematic.fig');
print(gcf,'-dpng','schematic.png','-r300');
print(gcf,'-dsvg','-painters','schematic.svg','-r300');

end

function [sph1XYZ, sph2XYZ] = get_sphere_locations(d_sphere, sep_dist, SphRes)
[sphX,sphY,sphZ]=sphere(SphRes);
surf(sphX*d_sphere/2-(d_sphere/2+sep_dist/2),sphY*d_sphere/2,sphZ*d_sphere/2,'facecolor','none');
surf(sphX*d_sphere/2+(d_sphere/2+sep_dist/2),sphY*d_sphere/2,sphZ*d_sphere/2,'facecolor','none');

% These are cell arrays to be used as surf(sph1XYZ{1}, sph1XYZ{2}, sph1XYZ{3})
sph1XYZ = {sphX*d_sphere/2-(d_sphere/2+sep_dist/2),...
           sphY*d_sphere/2,...
           sphZ*d_sphere/2};
sph2XYZ = {sphX*d_sphere/2+(d_sphere/2+sep_dist/2),...
           sphY*d_sphere/2,...
           sphZ*d_sphere/2};
end

function [newXYZmat1,...
          newXYZmat2,...
          newXYZmat3,...
          newXYZmat4,...
          newXYZmat5,...
          newXYZmat6,...
          newXYZmat7] = get_patch_locations(d_sphere, sep_dist, Npts)
[X,Y,Z]=ndgrid(linspace(-8,8,Npts),...
               linspace(-8,8,Npts),...
               linspace(-8,8,Npts));
Xvec = X(:);
Yvec = Y(:);
Zvec = Z(:);

XYZmat = [Xvec,Yvec,Zvec];

todrop = vecnorm(XYZmat,2,2)<d_sphere/2;
radial_tokeep = (vecnorm(XYZmat,2,2)<(d_sphere/2+sep_dist));
angular_tokeep1 = false(size(radial_tokeep));
angular_tokeep2 = false(size(radial_tokeep));
angular_tokeep3 = false(size(radial_tokeep));
angular_tokeep4 = false(size(radial_tokeep));
angular_tokeep5 = false(size(radial_tokeep));
angular_tokeep6 = false(size(radial_tokeep));
angular_tokeep7 = false(size(radial_tokeep));

vec = [1;0;0];

for i=1:size(XYZmat,1)
   
    
   normproj = dot(XYZmat(i,:),vec)/ (norm(XYZmat(i,:))*norm(vec));
   angle = rad2deg(acos(normproj));
   if angle >=0 && angle < 30
       angular_tokeep1(i) = true;
   end
   
   % 30 deg
   angle_rotation = deg2rad(-30);
   rotmatrix = [cos(angle_rotation), -sin(angle_rotation), 0;
                sin(angle_rotation),  cos(angle_rotation), 0;
                                  0,                    0, 1];
   new_vec = rotmatrix*vec;
   normproj = dot(XYZmat(i,:),new_vec)/ (norm(XYZmat(i,:))*norm(new_vec));
   angle = rad2deg(acos(normproj));
   if angle >=0 && angle < 30
       angular_tokeep2(i) = true;
   end
   
   %60 deg
   angle_rotation = deg2rad(-60);
   rotmatrix = [cos(angle_rotation), -sin(angle_rotation), 0;
                sin(angle_rotation),  cos(angle_rotation), 0;
                                  0,                    0, 1];
   new_vec = rotmatrix*vec;
   normproj = dot(XYZmat(i,:),new_vec)/ (norm(XYZmat(i,:))*norm(new_vec));
   angle = rad2deg(acos(normproj));
   if angle >=0 && angle < 30
       angular_tokeep3(i) = true;
   end
   
   %90 deg
   angle_rotation = deg2rad(-90);
   rotmatrix = [cos(angle_rotation), -sin(angle_rotation), 0;
                sin(angle_rotation),  cos(angle_rotation), 0;
                                  0,                    0, 1];
   new_vec = rotmatrix*vec;
   normproj = dot(XYZmat(i,:),new_vec)/ (norm(XYZmat(i,:))*norm(new_vec));
   angle = rad2deg(acos(normproj));
   if angle >=0 && angle < 30
       angular_tokeep4(i) = true;
   end
   
   %120 deg
   angle_rotation = deg2rad(-120);
   rotmatrix = [cos(angle_rotation), -sin(angle_rotation), 0;
                sin(angle_rotation),  cos(angle_rotation), 0;
                                  0,                    0, 1];
   new_vec = rotmatrix*vec;
   normproj = dot(XYZmat(i,:),new_vec)/ (norm(XYZmat(i,:))*norm(new_vec));
   angle = rad2deg(acos(normproj));
   if angle >=0 && angle < 30
       angular_tokeep5(i) = true;
   end
   
   %150 deg
   angle_rotation = deg2rad(-150);
   rotmatrix = [cos(angle_rotation), -sin(angle_rotation), 0;
                sin(angle_rotation),  cos(angle_rotation), 0;
                                  0,                    0, 1];
   new_vec = rotmatrix*vec;
   normproj = dot(XYZmat(i,:),new_vec)/ (norm(XYZmat(i,:))*norm(new_vec));
   angle = rad2deg(acos(normproj));
   if angle >=0 && angle < 30
       angular_tokeep6(i) = true;
   end
   
   %180 deg
   angle_rotation = deg2rad(-180);
   rotmatrix = [cos(angle_rotation), -sin(angle_rotation), 0;
                sin(angle_rotation),  cos(angle_rotation), 0;
                                  0,                    0, 1];
   new_vec = rotmatrix*vec;
   normproj = dot(XYZmat(i,:),new_vec)/ (norm(XYZmat(i,:))*norm(new_vec));
   angle = rad2deg(acos(normproj));
   if angle >=0 && angle < 30
       angular_tokeep7(i) = true;
   end
   
end

touse1 = ~todrop & radial_tokeep & angular_tokeep1;
touse2 = ~todrop & radial_tokeep & angular_tokeep2;
touse3 = ~todrop & radial_tokeep & angular_tokeep3;
touse4 = ~todrop & radial_tokeep & angular_tokeep4;
touse5 = ~todrop & radial_tokeep & angular_tokeep5;
touse6 = ~todrop & radial_tokeep & angular_tokeep6;
touse7 = ~todrop & radial_tokeep & angular_tokeep7;

newXYZmat1 = XYZmat(touse1,:);
newXYZmat2 = XYZmat(touse2,:);
newXYZmat3 = XYZmat(touse3,:);
newXYZmat4 = XYZmat(touse4,:);
newXYZmat5 = XYZmat(touse5,:);
newXYZmat6 = XYZmat(touse6,:);
newXYZmat7 = XYZmat(touse7,:);   

newXYZmat1(:,1) = newXYZmat1(:,1) + (d_sphere/2+sep_dist/2);
newXYZmat2(:,1) = newXYZmat2(:,1) + (d_sphere/2+sep_dist/2);
newXYZmat3(:,1) = newXYZmat3(:,1) + (d_sphere/2+sep_dist/2);
newXYZmat4(:,1) = newXYZmat4(:,1) + (d_sphere/2+sep_dist/2);
newXYZmat5(:,1) = newXYZmat5(:,1) + (d_sphere/2+sep_dist/2);
newXYZmat6(:,1) = newXYZmat6(:,1) + (d_sphere/2+sep_dist/2);
newXYZmat7(:,1) = newXYZmat7(:,1) + (d_sphere/2+sep_dist/2);
end