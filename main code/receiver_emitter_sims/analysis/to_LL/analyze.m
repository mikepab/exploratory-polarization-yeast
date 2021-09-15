function analyze(target_file)
nframes=100001; %1001

%npher_rc = cell(1,1);
%npher_em = cell(1,1);

% pos_em: positions, emitter-centered
% pos_rc: positions, receiver-centered
d_sphere=5;
sep_dist=0.25;
threshold_dist=d_sphere/2 + 0.25;

%npher_all = cell(1,1);
%bincountmats_rc = cell(1,1);
%bincountmats_em = cell(1,1);

[t,pos]=read_molPos3_cmpt(target_file);

npher_all = cellfun(@(x) size(x,1), pos.pheromone);
    
[pos_rc,pos_em]=get_relative_coordinates(pos,d_sphere,sep_dist,threshold_dist);

npher_rc = cellfun(@(x) size(x,1),pos_rc.pheromone);
npher_em = cellfun(@(x) size(x,1),pos_em.pheromone);
    
[bincounts1,bincounts2,bincounts3,bincounts4,bincounts5,bincounts6,bincounts7] = get_counts_per_bin(pos_rc.pheromone,[-1; 0; 0]);
    
bincountmats_rc = [cell2mat(bincounts1);
                   cell2mat(bincounts2);
                   cell2mat(bincounts3);
                   cell2mat(bincounts4);
                   cell2mat(bincounts5);
                   cell2mat(bincounts6);
                   cell2mat(bincounts7)];     
    
[bincounts1,bincounts2,bincounts3,bincounts4,bincounts5,bincounts6,bincounts7] = get_counts_per_bin(pos_em.pheromone,[-1; 0; 0]);
    
bincountmats_em = [cell2mat(bincounts1);
                   cell2mat(bincounts2);
                   cell2mat(bincounts3);
                   cell2mat(bincounts4);
                   cell2mat(bincounts5);
                   cell2mat(bincounts6);
                   cell2mat(bincounts7)];     

[~,savename,~] = fileparts(target_file); % get name separate from extension

save(sprintf('%s_processed',savename));

end

function [pos_rc,pos_em] = get_relative_coordinates(pos,d_sphere,sep_dist,threshold_dist)
%threshold_dist=sep_dist+d_sphere/2;
                        
pos_em.pheromone = cell(numel(pos.pheromone),1);
pos_rc.pheromone = cell(numel(pos.pheromone),1);
for i=1:numel(pos.pheromone)
    % Emitter positions
    if ~isempty(pos.pheromone{i})
        tmp = pos.pheromone{i} + [d_sphere/2+sep_dist/2,0,0];
        if size(tmp,1)==1
            pos_em.pheromone{i} = tmp(norm(tmp)<threshold_dist,:);
        elseif size(tmp,1)>1
            pos_em.pheromone{i} = tmp(vecnorm(tmp,2,2)<threshold_dist,:);
        end
        %pos_em.pheromone{i} = tmp;

        % Receiver positions
        tmp = pos.pheromone{i} - [d_sphere/2+sep_dist/2,0,0];    
        if size(tmp,1)==1
            pos_rc.pheromone{i} = tmp(norm(tmp)<threshold_dist,:);
        elseif size(tmp,1)>1
            pos_rc.pheromone{i} = tmp(vecnorm(tmp,2,2)<threshold_dist,:);
        end
        %pos_rc.pheromone{i} = tmp;
    end
end

end

function [bincounts1,bincounts2,bincounts3,bincounts4,bincounts5,bincounts6,bincounts7] = get_counts_per_bin(xyz,vec)
nframes = size(xyz,1);


for i=1:nframes
    subxyz = cell2mat(xyz(i));
    angles1 = zeros(size(subxyz,1),1);
    angles2 = zeros(size(subxyz,1),1);
    angles3 = zeros(size(subxyz,1),1);
    angles4 = zeros(size(subxyz,1),1);
    angles5 = zeros(size(subxyz,1),1);
    angles6 = zeros(size(subxyz,1),1);
    angles7 = zeros(size(subxyz,1),1);
    for j=1:size(subxyz,1)
        % 0-30
        angles1(j) = rad2deg(acos(normalized_projection(subxyz(j,1:3), vec(1:3))));
        
        % 30-60
        angle_rotation = deg2rad(30);
        rotmatrix = [cos(angle_rotation), -sin(angle_rotation), 0;
                     sin(angle_rotation),  cos(angle_rotation), 0;
                                       0,                    0, 1];
        new_vec = rotmatrix*vec;
        angles2(j) = rad2deg(acos(normalized_projection(subxyz(j,1:3), new_vec)));

        % 60-90
        angle_rotation = deg2rad(60);
        rotmatrix = [cos(angle_rotation), -sin(angle_rotation), 0;
                     sin(angle_rotation),  cos(angle_rotation), 0;
                                       0,                    0, 1];
        new_vec = rotmatrix*vec;
        angles3(j) = rad2deg(acos(normalized_projection(subxyz(j,1:3), new_vec)));
        
        % 90-120
        angle_rotation = deg2rad(90);
        rotmatrix = [cos(angle_rotation), -sin(angle_rotation), 0;
                     sin(angle_rotation),  cos(angle_rotation), 0;
                                       0,                    0, 1];
        new_vec = rotmatrix*vec;
        angles4(j) = rad2deg(acos(normalized_projection(subxyz(j,1:3), new_vec)));
        
        % 120-150
        angle_rotation = deg2rad(120);
        rotmatrix = [cos(angle_rotation), -sin(angle_rotation), 0;
                     sin(angle_rotation),  cos(angle_rotation), 0;
                                       0,                    0, 1];
        new_vec = rotmatrix*vec;
        angles5(j) = rad2deg(acos(normalized_projection(subxyz(j,1:3), new_vec)));
        
        % 150-180
        angle_rotation = deg2rad(150);
        rotmatrix = [cos(angle_rotation), -sin(angle_rotation), 0;
                     sin(angle_rotation),  cos(angle_rotation), 0;
                                       0,                    0, 1];
        new_vec = rotmatrix*vec;
        angles6(j) = rad2deg(acos(normalized_projection(subxyz(j,1:3), new_vec)));       
        
        % 150-180
        angle_rotation = deg2rad(180);
        rotmatrix = [cos(angle_rotation), -sin(angle_rotation), 0;
                     sin(angle_rotation),  cos(angle_rotation), 0;
                                       0,                    0, 1];
        new_vec = rotmatrix*vec;
        angles7(j) = rad2deg(acos(normalized_projection(subxyz(j,1:3), new_vec)));       
    end
    [bincounts1{1+i},~]=histcounts(angles1,'binedges',[0 30]);
    [bincounts2{1+i},~]=histcounts(angles2,'binedges',[0 30]);
    [bincounts3{1+i},~]=histcounts(angles3,'binedges',[0 30]);
    [bincounts4{1+i},~]=histcounts(angles4,'binedges',[0 30]);
    [bincounts5{1+i},~]=histcounts(angles5,'binedges',[0 30]);
    [bincounts6{1+i},~]=histcounts(angles6,'binedges',[0 30]);
    [bincounts7{1+i},~]=histcounts(angles7,'binedges',[0 30]);
    
end

end

function [bincounts,t] = get_sliding_window_angle_to_vec(xyz,vec,frame_window,angle_bins,t)
% Inputs:
%   xyz - nx3 matrix containing filtered coordinates of particles, with zero-centered origin
%   vec - 1x3 vector containing the vector direction of interest (receiver->emitter or vice versa)
%   frame_window - number of frames to include. Particles from the surrounding frames are included. Should be odd.
%   angle_bins - in degrees, the edges of the bins in terms of angle with respect to the vector.
%   t - nx1 vector containing actual times corresponding to entries along xyz.
% Outputs:
%   bincounts - particles observed per angle bin
%   t - times (truncated to match frame_window)

% DO ASSERTIONS TO VALIDATE INPUTS

% SUB-INDEX INTO XYZ TO GET TARGET PARTICLE DISTRIBUTIONS PER FRAME

% PERFORM PROJECTION ALONG Z (view XY plane) and compute 2D angles. Bin particles based on 2D angles.

nframes = size(xyz,1);
onesided_window = floor(frame_window/2);
for i=onesided_window:(nframes-onesided_window-1)
    subxyz = cell2mat(xyz( (1+(i-onesided_window)) : (1+i+onesided_window) ));
    angles = zeros(size(subxyz,1),1);
    for j=1:size(subxyz,1)
        angles(j) = rad2deg(acos(normalized_projection(subxyz(j,1:3), vec(1:3))));
    end
    [bincounts{1+i},~]=histcounts(angles,'binedges',angle_bins);
end

t = t( (1+onesided_window):(end-onesided_window) );
end

function norm_proj = normalized_projection(v1,v2)
% Input: vectors 1 and 2 of same length.
% Output: the normalized projection of vector 1 onto vector 2 (or vice-versa)
%         0 means no colinearity at all.
%        -1 is perfect anti-colinearity
%        +1 is perfect colinearity
norm_proj = dot(v1,v2)/(norm(v1)*norm(v2));
end

function [frames,pos] = read_molPos3_cmpt(filename)
% Previous version - slow?
% fprintf('Attempting to read %s\n',filename);
% T=dlmread(filename,' ');
% %nframes=max(T(:,1));
% nframes=100001;
% skipfac=1;
% pos.pheromone=cell(ceil(nframes/skipfac),1);
% posindex=1;
% for i=1:skipfac:nframes
%    pos.pheromone{posindex} = T(T(:,1)==i,4:6); 
%    posindex=posindex+1;
% end
% frames=1:skipfac:nframes;

% Updated version - faster? Naive testing puts it at roughly 4x faster.
fprintf('Attempting to read %s\n',filename);
nframes=100001;
pos.pheromone=cell(nframes,1);
fid=fopen(filename);
while ~feof(fid)
   currline = fgetl(fid);
   [t,x,y,z]=entry_to_xyz(currline);
   pos.pheromone{t} = [pos.pheromone{t};...
                       x,y,z];
end
fclose(fid);
frames=1:nframes;
end

function [t,x,y,z] = entry_to_xyz(line)
coords = sscanf(line,'%g');
if numel(coords)>1
    t=coords(1);
    x=coords(4);
    y=coords(5);
    z=coords(6);
else
    t=nan;x=[];y=[];z=[];
end
end

