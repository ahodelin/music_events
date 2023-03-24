sed -i 's/;//g' Music_Events.csv
cat Music_Events1.tex > Music_Events.tex
cat Music_Events.csv >> Music_Events.tex
cat Music_Events2.tex >> Music_Events.tex
pdflatex Music_Events.tex
