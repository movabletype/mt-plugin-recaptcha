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

package reCaptcha;

use strict;
use warnings;
use base qw(MT::ErrorHandler);

sub debuglog {
    return unless MT->config->ReCaptchaDebug;
    my $msg = shift || return;
    require MT;
    MT->log({
        message => "reCaptcha: $msg",
        level   => MT::Log::DEBUG(),
    });
}

sub form_fields {
    my $self = shift;
    my ($blog_id) = @_;

    my $plugin = MT::Plugin::reCaptcha->instance;
    my $config = $plugin->get_config_hash("blog:$blog_id");
    my $publickey = $config->{recaptcha_publickey};
    my $privatekey = $config->{recaptcha_privatekey};
    return q() unless $publickey && $privatekey;

    return <<FORM_FIELD;
<div id="recaptcha_script" style="display:block">
<script type="text/javascript"
   src="//www.google.com/recaptcha/api/challenge?k=$publickey">
</script>

<noscript>
   <iframe src="//www.google.com/recaptcha/api/noscript?k=$publickey"
       height="300" width="500" frameborder="0"></iframe><br>
   <textarea name="recaptcha_challenge_field" rows="3" cols="40">
   </textarea>
   <input type="hidden" name="recaptcha_response_field"
       value="manual_challenge">
</noscript>
</div>
<script type="text/javascript">
if ( typeof(mtCaptchaVisible) != "undefined" )
    mtCaptchaVisible = true;
else if ( typeof(commenter_name) != "undefined" ) {
    var div = document.getElementById("recaptcha_script");
    if (commenter_name)
        div.style.display = "none";
    else
        div.style.display = "block";
}
</script>
FORM_FIELD
}

sub validate_captcha {
    my $self = shift;
    my ($app) = @_;

    my $blog_id = $app->param('blog_id');
    if ( my $entry_id = $app->param('entry_id') ) {
        my $entry = $app->model('entry')->load($entry_id)
            or return 0;
        $blog_id = $entry->blog_id;
    };
    return 0 unless $blog_id;
    return 0 unless $app->model('blog')->count( { id => $blog_id } );

    my $config = MT::Plugin::reCaptcha->instance->get_config_hash("blog:$blog_id");
    my $privatekey = $config->{recaptcha_privatekey};

    my $challenge = $app->param('recaptcha_challenge_field');
    my $response = $app->param('recaptcha_response_field');
    my $ua = $app->new_ua({ timeout => 15, max_size => undef });
    return 0 unless $ua;

    require HTTP::Request;
    my $req = HTTP::Request->new(POST => 'http://www.google.com/recaptcha/api/verify');
    $req->content_type("application/x-www-form-urlencoded");
    require MT::Util;
    my $content = 'privatekey=' . MT::Util::encode_url($privatekey);
    $content .= '&remoteip=' . MT::Util::encode_url($app->remote_ip);
    $content .= '&challenge=' . MT::Util::encode_url($challenge);
    $content .= '&response=' . MT::Util::encode_url($response);
    $req->content($content);
    debuglog("sending verification request: '$content'");

    my $res = $ua->request($req);
    my $c = $res->content;

    if (substr($res->code, 0, 1) eq '2') {
        if ($c =~ /^true\n/) {
            debuglog("submitted code is valid: '$c'");
            return 1;
        }
        debuglog("submitted code is not valid: '$c'");
    } else {
        debuglog("verification failed: response code: '" . $res->code . "', content: '$c'");
    }

    return 0;
}

sub generate_captcha {
    # This won't be called since there is no link which requests to "generate_captcha" mode.
    my $self = shift;
    1;
}

1;
