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
    version => '0.24',
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
