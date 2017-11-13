# README

This README would normally document whatever steps are necessary to get the
application up and running.

Table of contents

CONTENTS OF THIS FILE
---------------------

 * Introduction
 * Requirements
 * Recommended modules
 * Installation
 * Configuration
 * Troubleshooting
 * FAQ
 * Maintainers

INTRODUCTION
--------------------
This project expose a single endpoint resource, allowing  to take any image of the common formats - jpg, gif, png and turn it into a thumbnail.
The resources should be provided with the image url, expected width and height. The image will be resized according to the new dimensions while preserving the original aspect ratio.
The original aspect ratio is preserved by adding a padding to fill in the blank while centralizing the image.

Resource: Get  <app server>/thumbnail?url=<url>&width<width>&height=<height>
The resource does not support dimensions greater than the original image.

REQUIREMENTS
--------------------

This service require the following to be installed:
-	Ruby 2.4.2
-	Rails 5.1.4
-	JRuby 9.1.8
-	ImageMagick
-	GraphicsMagick
-	Postgres


INSTALLATION
------------------

Installation can take place manually or deployed to a cloud platform such as Heroku.
For deployment in the cloud

Local installation - Create a local repository by cloning  from github - https://github.com/ortek100/ThumbnailCreator.git
Run from root folder ‘rails server’ to start the service.
Web server is WEBrick shipped with Ruby.

CONFIGURATION
----------------------

Configurations available:
-	Service port: by default is 3000, can be adjusted at puma.rb.
-	Working environments : development, production, test, can be found under <root>/config/environments
-	DB connection details are configured at database.yml


MAINTAINERS
------------------

Current maintainers:
 * Ortal Halili

