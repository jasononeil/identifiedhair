Identified Hair Website
=======================

Copyright Identified Hair, 2014.

All rights reserved on graphics, branding, logos, text content, HTML templates, stylesheets photos etc.

Feel free to look at and learn, but don't copy, modify or redistribute.

The source code (*.hx files) you can look at, learn from, copy, etc.

The reason this repo is shared on Github is so that you can look at an *extremely* simple site made using ufront.

### Things to look out for

* Haxe source code in `src/`, built it by compiling `server.hxml` using `ufront build server` or just `ufront b` for short.
* All the views in `www/view/*`, using the `erazor` templating engine.
* I use a PHP extern in `src/SimpleHtmlDom.hx` and `www/simple_html_dom.php`.
* To run a sample server use `cd www; php -S localhost:8000`. The router.php will emulate mod_rewrite for you.
* All stylesheets are in `stylesheets/sass/`, and you use `./runstyles` to compile them to `www/css/*.css`.
* I have chosen to avoid using a database to keep this simple and portable. Instead all data is saved to files in `www/uf-content/`
* To deploy, you set up `deploy.json` with the correct repos and server details, and run `ufront d`.