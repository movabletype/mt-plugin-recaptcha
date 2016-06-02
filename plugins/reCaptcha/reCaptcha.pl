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

package MT::Plugin::reCaptcha;

use strict;
use warnings;

use MT;
use base qw(MT::Plugin);

my $plugin = MT::Plugin::reCaptcha->new({
    description => 'CAPTCHA plugin powered by reCaptcha.  Follow the instruction specified in README to use reCaptcha on your published blog.',
    name => 'reCaptcha',
    author_name => 'Six Apart, Ltd.',
    author_link => 'http://www.movabletype.com/',
    blog_config_template => <<TMPL,
<dl>
<dt>reCaptcha public key</dt>
<dd><input name="recaptcha_publickey" size="40" value="<mt:var name="recaptcha_publickey">" /></dd>
<dt>reCaptcha private key</dt>
<dd><input name="recaptcha_privatekey" size="40" value="<mt:var name="recaptcha_privatekey">" /></dd>
</dl>
TMPL
    settings => new MT::PluginSettings([
        ['recaptcha_publickey', { Scope   => 'blog' }],
        ['recaptcha_privatekey', { Scope   => 'blog' }],
    ]),
    version => '0.3',
});

MT->add_plugin($plugin);
sub instance { $plugin }

sub init_registry {
    my $plugin = shift;
    $plugin->registry({
        'captcha_providers' => {
            'sixapart_rc' => {
                'label' => 'reCaptcha',
                'class' => 'reCaptcha',
            },
        },
    });
}

1;
