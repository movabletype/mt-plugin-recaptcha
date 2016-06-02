<?php
##############################################################################
# Copyright (c) 2009 Six Apart
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the "Software"),
# to deal in the Software without restriction, including without limitation
# the rights to use, copy, modify, merge, publish, distribute, sublicense,
# and/or sell copies of the Software, and to permit persons to whom
# the Software is furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included
# in all copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
# DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
# OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR
# THE USE OR OTHER DEALINGS IN THE SOFTWARE.

require_once("captcha_lib.php");

class reCaptcha extends BaseCaptchaProvider {
    function get_key() {
        return 'sixapart_rc';
    }
    function get_name() {
        return 'reCaptcha';
    }
    function get_classname() {
        return 'reCaptcha';
    }
    function form_fields($blog_id) {
        global $mt;
        $config = $mt->db->fetch_plugin_config('reCaptcha', 'blog:' . $blog_id);
        if ($config) {
            $publickey = $config['recaptcha_publickey'];
        }

        $fields = "
<div id=\"recaptcha_script\" style=\"display:block\">
<script type=\"text/javascript\"
   src=\"http://api.recaptcha.net/challenge?k=$publickey\">
</script>

<noscript>
   <iframe src=\"http://api.recaptcha.net/noscript?k=$publickey\"
       height=\"300\" width=\"500\" frameborder=\"0\"></iframe><br>
   <textarea name=\"recaptcha_challenge_field\" rows=\"3\" cols=\"40\">
   </textarea>
   <input type=\"hidden\" name=\"recaptcha_response_field\"
       value=\"manual_challenge\">
</noscript>
</div>
<script type=\"text/javascript\">
if ( typeof(mtCaptchaVisible) != \"undefined\" )
    mtCaptchaVisible = true;
else if ( typeof(commenter_name) != \"undefined\" ) {
    var div = document.getElementById(\"recaptcha_script\");
    if (commenter_name)
        div.style.display = \"none\";
    else
        div.style.display = \"block\";
}
</script>
";
        return $fields;
    }
}

$provider = new reCaptcha();
$_captcha_providers[$provider->get_key()] = $provider;
