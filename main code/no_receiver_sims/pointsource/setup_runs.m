mkdir('to_LL');
fid=fopen('to_LL\\run_all.sh','w');
fprintf(fid,'#!/bin/bash\n\n');
for i=1:30
    poiname = sprintf('poi_%02d',i);
    vesname = sprintf('ves_%02d',i);

    generate_poisson_simulation('to_LL\\',poiname,poiname,i);
    generate_vesicle_simulation('to_LL\\',vesname,vesname,i);

    fprintf(fid,'sbatch -p general -N 1 -J poi%02d -t 24:00:00 --mem=1g --wrap="/nas/longleaf/home/mikepab/smoldyn-2.58/cmake/smoldyn %s.cfg"\n',i,poiname);
    fprintf(fid,'sbatch -p general -N 1 -J ves%02d -t 24:00:00 --mem=1g --wrap="/nas/longleaf/home/mikepab/smoldyn-2.58/cmake/smoldyn %s.cfg"\n',i,vesname);
end
fclose(fid);
