function generate_poisson_simulation(dirToWrite,fileprefix,outputname,randomseedvalue)
cfg_name = [dirToWrite '/' fileprefix '.cfg'];

fid=fopen(cfg_name,'w');
write_setup(fid,randomseedvalue,outputname);
fclose(fid);
end

function write_setup(fid,randomseedvalue,outputname)
fprintf(fid,'random_seed %i\n',randomseedvalue);

fprintf(fid,'variable d_sphere 5\n');
fprintf(fid,'variable sep_dist 0.25\n');
fprintf(fid,'variable Dpher 150 # um2/s\n');
fprintf(fid,'variable d_simdomain 50\n');
fprintf(fid,'variable sim_dt 0.0001 # seconds, use this to correct emission rate\n');


fprintf(fid,'dim 3\n');
fprintf(fid,'boundaries x -d_simdomain-sep_dist d_simdomain+sep_dist\n');
fprintf(fid,'boundaries y -d_simdomain-sep_dist d_simdomain+sep_dist\n');
fprintf(fid,'boundaries z -d_simdomain-sep_dist d_simdomain+sep_dist\n');
fprintf(fid,'\n\n');

fprintf(fid,'species pheromone\n');
fprintf(fid,'difc pheromone(all) Dpher\n\n');

% fprintf(fid,'start_surface receiver\n');
% fprintf(fid,'action both all reflect\n');
% fprintf(fid,'panel sphere d_sphere/2+sep_dist/2 0 0 -d_sphere/2 10 10\n');
% fprintf(fid,'end_surface\n\n');

fprintf(fid,'start_surface emitter\n');
fprintf(fid,'action both all reflect\n');
fprintf(fid,'panel sphere -(d_sphere/2+sep_dist/2) 0 0 -d_sphere/2 10 10\n');
fprintf(fid,'end_surface\n\n');

fprintf(fid,'start_surface sim_boundary\n');
fprintf(fid,'action both all absorb\n');
fprintf(fid,'polygon both none\n');
fprintf(fid,'panel sphere 0 0 0 -d_simdomain 10 10\n');
fprintf(fid,'end_surface\n\n');

fprintf(fid,'# Pseudosurface for keeping track of molecular coordinates.\n');
fprintf(fid,'start_surface surveillance_boundary\n');
fprintf(fid,'action both all transmit\n');
fprintf(fid,'panel sphere 0 0 0 -(d_sphere+12*sep_dist) 10 10\n');
fprintf(fid,'end_surface\n\n');

fprintf(fid,'# Pseudocompartment for keeping track of molecular coordinates.\n');
fprintf(fid,'start_compartment surveillance_compartment\n');
fprintf(fid,'surface surveillance_boundary\n');
fprintf(fid,'point 0 0 0\n');
fprintf(fid,'end_compartment\n\n');

% % THIS BLOCK RESULTS IN A POINT SOURCE
% fprintf(fid,'start_surface emission_source_surf\n');
% fprintf(fid,'action both all transmit\n');
% fprintf(fid,'panel sphere -sep_dist/2+0.001 0 0 -0.0005 10 10\n');
% fprintf(fid,'end_surface\n\n');

% THIS BLOCK RESULTS IN A SPHERE SOURCE AROUND THE EMITTER
fprintf(fid,'start_surface emission_source_surf\n');
fprintf(fid,'action both all transmit\n');
fprintf(fid,'panel sphere -(d_sphere/2+sep_dist/2) 0 0 -(d_sphere/2+0.001) 10 10\n');
fprintf(fid,'end_surface\n\n');

fprintf(fid,'# Generate molecules following zeroth-order law, Poisson rate..\n');
fprintf(fid,'reaction surface=emission_source_surf pher_emit 0 -> pheromone\n');
fprintf(fid,'reaction_production pher_emit 1/7.1429\n'); % 1/7.1429 yields 1400 molecules per second

fprintf(fid,'time_start 0\n');
fprintf(fid,'time_stop 15\n');
fprintf(fid,'time_step sim_dt\n\n');

%fprintf(fid,'cmd N 18 pointsource pheromone 1 0 0 0\n');
%write_vesicle_events(fid);

fprintf(fid,'output_files %s.xyz\n',outputname);
fprintf(fid,'cmd I 50000 150000 1 listmolscmpt pheromone(all) surveillance_compartment %s.xyz\n',outputname);
fprintf(fid,'end_file\n');
end

