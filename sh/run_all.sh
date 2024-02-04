echo "Database dumping..."
bash dump_music_events.sh

echo "Extraction & Transformation - JSON..."
cd json_files
bash to_js.sh

echo "Extraction & Transformation - PDF..."
cd ../../tex_pdf
bash to_pdf.sh

echo "Update git repository ..."
cd ../sh
bash git_push_music.sh
