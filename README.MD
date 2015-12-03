### random_scripts

I'm using this repo to keep track of random scripts I write.

`convert_htm_to_mobi`
I've been disappointed with the ability to download free, old books from [project gutenberg](https://www.gutenberg.org/) and use them on my Kindle. When I download the books as .mobi files, I can't change the font style. When I download them as plain text documents, there's weird line spacing.     

This script uses amazon's [KindleGen](https://www.amazon.com/gp/feature.html?docId=1000765211) command line tool to convert .htm books from the project gutenberg site to .mobi files that the Kindle can read. There are no funky spacing issues and you can choose whatever font you'd like.

The script is run like `bash -x convert_htm_to_mobi.sh /path/to/dir/with/htm/files/`. It'll save the results .mobi files the directory containing the /htm files. The filenames of the htm files can't have spaces.
