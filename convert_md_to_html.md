## convert markdown files into html files that are nicer to read

Use *pandoc*. Install with `brew install pandoc`. Then use something like `pandoc convert_md_to_html.md -s -c buttondown.css --self-contained -o foo.html`. This will style the resulting html file with the stylings provided in the provided `.css` file.


