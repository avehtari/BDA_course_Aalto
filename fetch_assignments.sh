OUTPUT_DIR="${1:-"templates"}"
mkdir -p $OUTPUT_DIR
cd $OUTPUT_DIR
wget https://avehtari.github.io/BDA_course_Aalto/assignments/templates.zip
unzip templates.zip
chmod -R a+rX .
rm templates.zip
cd ..