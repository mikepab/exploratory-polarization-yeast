mkdir('to_LL');
fid=fopen('to_LL\\run_all_extract_data.sh','w');
fprintf(fid,'#!/bin/bash\n\n');
for i=1:300
    poiname = sprintf('poi_%02d_processed.mat',i);
    vesname = sprintf('ves_%02d_processed.mat',i);

    %generate_poisson_simulation('to_LL\\',poiname,poiname,i);
    %generate_vesicle_simulation('to_LL\\',vesname,vesname,i);

    fprintf(fid,'sbatch -p general -N 1 -J poi%02d -t 36:00:00 --mem=4g --wrap="matlab -nodisplay -nosplash -singleCompThread -r extract_data\\(\\''%s\\''\\) -logfile %s.log"\n',i,poiname, poiname);
    fprintf(fid,'sbatch -p general -N 1 -J ves%02d -t 36:00:00 --mem=4g --wrap="matlab -nodisplay -nosplash -singleCompThread -r extract_data\\(\\''%s\\''\\) -logfile %s.log"\n',i,vesname, vesname);
end
fclose(fid);
