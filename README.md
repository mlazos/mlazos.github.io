This is the repo for my [personal blog](http://mlazos.github.io)

## Getting Started
Run the following command to build the blog generator.

```bash
stack build
```

Be prepared for it the dependencies to take a while to build the first time.  To rebuild the site, use

```bash
stack exec blog rebuild
```

which will place its results in the `_site` folder.  To run a local server to preview the site and automatically rebuild it when any of the source files change, use

```bash
stack exec blog watch -- --host "0.0.0.0"
```

After executing this command, there will be a preview webserver running at `localhost:8000`.

The source files for the site are located in `site-src`.  The executable will look in the `posts/` folder for posts.  Each post should be named `YYYY-MM-DD-short-title-for-url.mkd`.  Consult the Hakyll [tutorials](http://jaspervdj.be/hakyll/tutorials.html) for more information on how to format posts to contain the correct metadata.

This code is distributed under the [MIT License](http://opensource.org/licenses/MIT).
