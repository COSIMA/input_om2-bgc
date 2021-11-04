#!/usr/bin/env sh
# Commit changes and push, then add metadata to note how changes were made

module load nco
module load git

echo "About to commit all changes to git repository and push to remote."
read -p "Proceed? (y/n) " yesno
case $yesno in
   [Yy] ) ;;
      * ) echo "Cancelled."; exit 0;;
esac

set -x
set -e

git commit -am "update" || true
git push || true

outpath=.

dirs=("1deg" "025deg" "01deg")
for d in ${dirs[@]}; do
   for f in ${outpath}/${d}/*.nc; do
      ncatted -O -h -a history,global,a,c," | Created on $(date) using https://github.com/COSIMA/input_om2-bgc/tree/$(git rev-parse --short HEAD)" $f
   done
done

set +e
chgrp -R ik11 ${outpath}
chmod -R g+rX ${outpath}

echo "done"
