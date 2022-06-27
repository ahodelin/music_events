for i in `ls -1`
  do
    o=`echo $i | sed -e 's/svg/png/'`
    inkscape $i -o $o
  done
