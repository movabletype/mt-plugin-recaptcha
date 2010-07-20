# reCaptcha, a plugin for Movable Type

Authors: Six Apart Ltd.  
Copyright: 2009 Six Apart Ltd.  
License: [Artistic License 2.0](http://www.opensource.org/licenses/artistic-license-2.0.php)


## Overview

Captcha plugin powered by [reCaptcha](http://recaptcha.net/).


## Requirements

* MT 4.x


## Features

* provides captcha powered by reCaptcha


## Documentation

http://www.tildemark.com/movable-type/adding-captcha-to-comments-in-movable-type-4.html


1. Register for an account on reCaptcha and follow the links to "add a new site" to get the "reCaptcha public key" and "reCaptcha private key".
2. Install the reCaptcha plugin.
3. Go the Blog menu Tools > Plugins and open the settings for the reCaptcha plugin.
4. Enter the keys into the respective public and private fields and click "Save Changes".
5. Go to Blog menu Preferences > Comment.
6. Select "reCaptcha" as the value for "CAPTCHA Provider" and click "Save Changes".
7. Edit the template containing the commenting form. *In the default templates this is th "Comment Form" template.*

    Look for one of the following blocks of code (from default templates in MT4.0x and MT4.1x):
    
        <mt:If tag="MTCaptchaFields">
        <mt:IfCommentsAccepted><mt:IfRegistrationAllowed><mt:Else><$mt:CaptchaFields$></mt:IfRegistrationAllowed></mt:IfCommentsAccepted>
        <div id="comments-open-captcha">
        </div>
        </mt:If>
    
    ...or this code  (from default templates in MT4.2x+):
    
        <div id="comments-open-captcha"></div>
    
    Replace this with this code:
    
        <mt:If tag="MTCaptchaFields">
            <div id="comments-open-captcha"><$mt:CaptchaFields$></div>
        </mt:If>
    
    > **Note:** The `mt:If` tag will remove the catcha if the "CAPTCHA Provider" setting is changed to "none" in Movable Type.

8. Open the Javascript index template and remove the followin code, or place the following code in a `mt:Ignore` tag. (This code was in the default templates in MT4.0x and MT4.1x):

        <mt:If tag="MTCaptchaFields">
        captcha_timer = setInterval('delayShowCaptcha()', 1000);
        </mt:If>

9. Rebuild index and individual entry archives.


## Installation

1. Move the reCaptcha plugin directory to the MT `plugins` directory.

Should look like this when installed:

    $MT_HOME/
        plugins/
            reCaptcha/

[More in-depth plugin installation instructions](http://tinyurl.com/easy-plugin-install).

## Troubleshooting

Add the following MT config directive to write validation requests and responses to the Activity log:

    ReCaptchaDebug 1

## Desired Feature Wish List

* add wish-list item here


## Support

This plugin is not an official Six Apart Ltd. release, and as such support from Six Apart Ltd. for this plugin is not available.
