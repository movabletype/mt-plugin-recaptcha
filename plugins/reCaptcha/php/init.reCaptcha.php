<?php
##############################################################################
# Copyright © 2010 Six Apart Ltd.
# This program is free software: you can redistribute it and/or modify it
# under the terms of version 2 of the GNU General Public License as published
# by the Free Software Foundation, or (at your option) any later version.
# This program is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
# FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
# version 2 for more details.  You should have received a copy of the GNU
# General Public License version 2 along with this program. If not, see
# <http://www.gnu.org/licenses/>.

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
