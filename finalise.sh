#!/usr/bin/env sh
# Commit changes and push, then add metadata to note how changes were made

module load nco
module load git

outpath=.
dirs=("." "1deg" "025deg" "01deg")

echo "About to commit all changes to git repository and push to remote, then append to global history attribute of all .nc files in ${dirs[@]} on path ${outpath} ."
read -p "Proceed? (y/n) " yesno
case $yesno in
   [Yy] ) ;;
      * ) echo "Cancelled."; exit 0;;
esac

set -x
set -e

git commit -am "update" || true
git push || true

for d in ${dirs[@]}; do
   for f in ${outpath}/${d}/*.nc; do
      if [ -f $f ]; then
         ncatted -O -h -a history,global,a,c," | Created on $(date) using https://github.com/COSIMA/input_om2-bgc/tree/$(git rev-parse --short HEAD)" $f
      fi
   done
done

set +e
chgrp -R ik11 ${outpath}
chmod -R g+rX ${outpath}

echo "done"
