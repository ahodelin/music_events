git checkout main -- js/*
git add js/*
d=`date`
git commit -m "Web last update $d"
git fetch origin
git push origin gh-pages
