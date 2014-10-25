Identified Hair Website
=======================

Copyright Identified Hair, 2014.

All rights reserved on graphics, branding, logos, text content, HTML templates, stylesheets photos etc.
Feel free to look at and learn, but don't copy, modify or redistribute.
The source code (*.hx files) you can look at, learn from, copy, etc.
The reason this repo is shared on Github is so that you can look at an *extremely* simple site made using ufront.

A preview of the site is available on http://identified.jasono.co/

### Things to look out for

* Haxe source code in `src/`, built it by compiling `server.hxml`.
* All the views in `www/view/*`, using the `erazor` templating engine.
* I use a PHP extern in `src/SimpleHtmlDom.hx` and `www/simple_html_dom.php`.
* To run a sample server use `cd www; php -S localhost:8000`. The `router.php` file is needed to emulate mod_rewrite pretty URLs.
* All stylesheets are in `stylesheets/sass/`, and you use `./runstyles` to compile them to `www/css/*.css`.
* I have chosen to avoid using a database to keep this simple and portable. Instead all data is saved to files in `www/uf-content/`
* There is a very basic admin page at `/idh-admin/`, using simple HTTP authentication and the `SiteAdminController`.
* There's an example of file uploads in the `SiteAdminController`.
* If you run `./rundocs`, you get browseable API documentation for all code, both for this site, ufront libraries, and the standard library. 
* To deploy, you set up `deploy.json` with the correct repos and server details, and run `ufront d`.

### Getting it running

* `git clone https://github.com/jasononeil/identifiedhair.git`
* `cd identifiedhair/`
* `haxelib install all`
* `haxe server.hxml`
* `./runstyles`
* `php -S localhost:8000`
* Open http://localhost:8000/import/ to scrape some data from another website
* Open http://localhost:8000/ to view the site!

### Deploying

* `haxelib install ufront` to get the ufront helper tool.
* `haxelib run ufront setup` to get the shortcut set up for our ufront tool.
* `cp deploy.json.sample deploy.json`, then edit `deploy.json` with the right values for your server.
* `ufront deploy` or `ufront d`
