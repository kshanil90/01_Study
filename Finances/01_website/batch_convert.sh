files=($(find ${INPUT_FOLDER} -type f -name '*.md'))
mkdir build
rm -rf build/*html
printf "Copying js\n"
cp -r js build/
printf "Copying fonts\n"
cp -r fonts build/
printf "Copying es5\n"
cp -r es5 build/
printf "Copying css\n"
cp -r css build/

for item in ${files[*]}
do
    x=$item
    title_date=$(date +%Y-%m-%d-%H_%M_S)
    item_html=${x%.md}.html
    item_link_corrected=${x%.md}_link_corrected.html
    item_link_double_extension_removed=${x%.md}_link_corrected_double_extension_removed.html
    touch $item_link_corrected
    touch $item_link_double_extension_removed
    perl -pe ' s/(\[.+?\])\(([^#)]+?)\)/\1(\2.html)/g' $item > $item_link_corrected
    sed -r 's/\]\(([^.]+\.[^.]+)\.[^)]+\)/]\(\1\)/g' $item_link_corrected > $item_link_double_extension_removed
    pandoc -M title:$title_date -f markdown $item_link_double_extension_removed --template toc-sidebarL.html --standalone --toc -B nav -o ./build/$item_html --mathjax=es5/tex-chtml.js;
    rm -rf $item_link_corrected
    rm -rf $item_link_double_extension_removed
done
