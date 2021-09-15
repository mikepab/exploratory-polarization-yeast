function faster_readin(filename)
[frames,pos] = read_molPos3_cmpt_v0(filename);
%[frames,pos] = read_molPos3_cmpt_v1(filename);
%[frames,pos] = read_molPos3_cmpt_v2(filename);
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

function [frames,pos] = read_molPos3_cmpt_v0(filename)
% Previous version - slow?
fprintf('Attempting to read %s\n',filename);
tic;
T=dlmread(filename,' ');
%nframes=max(T(:,1));
nframes=10000;
skipfac=1;
pos.pheromone=cell(ceil(nframes/skipfac),1);
posindex=1;
for i=1:skipfac:nframes
   pos.pheromone{posindex} = T(T(:,1)==i,4:6); 
   posindex=posindex+1;
end
time=toc;
disp(toc)
frames=1:skipfac:nframes;
end

% This is estimated to take ~8 hours on a typical point poisson release.
% at 1400 mol/s, from 5-15s. 
function [frames,pos] = read_molPos3_cmpt_v1(filename)
fprintf('Attempting to read %s\n',filename);
nframes=100001;
pos.pheromone=cell(nframes,1);
fid=fopen(filename);
tic;
while ~feof(fid)
   currline = fgetl(fid);
   [t,x,y,z]=entry_to_xyz(currline);
   pos.pheromone{t} = [pos.pheromone{t};...
                       x,y,z];
   if mod(t,10000)==0
       disp(t);
       time=toc;
       disp(time);
       break;
   end
end
fclose(fid);
frames=1:nframes;
end

% This is estimated to take ~8 hours on a typical point poisson release.
% at 1400 mol/s, from 5-15s. 
function [frames,pos] = read_molPos3_cmpt_v2(filename)
fprintf('Attempting to read %s\n',filename);
nframes=100001;
pos.pheromone=cell(nframes,1);
fid=fopen(filename);
frameindex=1;
firstEntryThisFrame = true;
particleIndex=1;
estimatedMaxNumberParticlesPerFrame = 1e6;
tic;
while ~feof(fid)
   currline = fgetl(fid);
   [t,x,y,z]=entry_to_xyz(currline);
   if frameindex == t
       if firstEntryThisFrame
           pos.pheromone{t} = nan(estimatedMaxNumberParticlesPerFrame,3);
           particleIndex=1;
           firstEntryThisFrame = false;
       end
       
       pos.pheromone{t}(particleIndex,:) = [x,y,z];
       particleIndex=particleIndex+1;
       if mod(t,10000)==0
           disp(t);
           time=toc;
           disp(time)
           break;
       end
   else % We've hit a new timepoint
       firstEntryThisFrame=true;
       % Drop nans from previous frame
       nan_entries = isnan(pos.pheromone{t-1}(:,1));
       pos.pheromone{t-1} = pos.pheromone{t-1}(~nan_entries,:);
       frameindex = frameindex+1;
   end
end
% Drop nan entries from final frame
nan_entries = isnan(pos.pheromone{t}(:,1));
pos.pheromone{t} = pos.pheromone{t}(~nan_entries,:);
fclose(fid);
frames=1:nframes;
end