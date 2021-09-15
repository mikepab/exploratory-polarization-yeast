function analyze(target_file)

% pos_em: positions, emitter-centered
% pos_rc: positions, receiver-centered
d_sphere=5;
sep_dist=0.25;
threshold_dist=d_sphere/2 + 10.25;

[t,pos]=read_molPos3_cmpt(target_file);

npher_all = cellfun(@(x) size(x,1), pos.pheromone);
    
[~,pos_em]=get_relative_coordinates(pos,d_sphere,sep_dist,threshold_dist);
[nPerShell_poi,thresholds] = count_per_shell(pos_em,d_sphere,sep_dist,0.25); 

[~,savename,~] = fileparts(target_file); % get name separate from extension

save(sprintf('%s_processed',savename),'nPerShell_poi');
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

function [nPerShell,thresholds] = count_per_shell(pos,d_sphere,sep_dist,shelldepth)
nframes = numel(pos.pheromone);
thresholds = d_sphere/2:shelldepth:(d_sphere/2+(10*shelldepth));

nPerShell = zeros(nframes,numel(thresholds)-1); % extend 10 shell volumse
pos_em.pheromone = cell(nframes,1);
for i=1:nframes
    % Emitter positions
    if ~isempty(pos.pheromone{i})
        pos_em.pheromone{i} = pos.pheromone{i} + [d_sphere/2+sep_dist/2,0,0];
        n_particles = size(pos_em.pheromone{i},1);
        if n_particles==1
            distances = norm(pos_em.pheromone{i});
        elseif n_particles>1
            distances = vecnorm(pos_em.pheromone{i},2,2);
        end
        
        for j=2:numel(thresholds)
            nPerShell(j-1) = sum( (distances > thresholds(j-1)) .* (distances < thresholds(j)) );
        end
        
        %pos_em.pheromone{i} = tmp;
    end
end
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
