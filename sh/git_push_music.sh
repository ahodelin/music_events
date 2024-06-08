cd ..
rm -rf old
git add * 
d=`date`
git commit -m "Last update $d"
git fetch origin
git push origin main
git push origin gh-pages
