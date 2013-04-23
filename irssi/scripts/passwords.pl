use strict;

use vars qw($VERSION %IRSSI);
use Irssi qw(command_bind signal_add);
use Data::Dumper;

$VERSION = '0.01';
%IRSSI = (
  authors     => 'Thiago de Arruda',
  contact     => 'tpadilha84@gmail.com',
  name        => 'Passwords',
  description => 'Loads passwords from a gnupg encrypted file and '.
                 'authenticates automatically when the server requests.',
  license     => 'WTFPL',
);

my %passwords;

sub reload_passwords {
  %passwords = ();
  open PASSWORDS_DB, "gpg --batch -q --decrypt $ENV{'HOME'}/.irssi-passwords.gpg |";
  while (<PASSWORDS_DB>) {
    chomp;
    my ($chatnet, $password) = split(':');
    $passwords{$chatnet} = $password;
  }
  close PASSWORDS_DB
}

sub event_notice {
  # $data = "nick/#channel :text"
  my ($server, $data, $nick, $address) = @_;
  my ($target, $text) = split(/ :/, $data, 2);

  return if ($target !~ /$server->{nick}/);

  my $chatnet = $server->{'chatnet'};

  if (exists($passwords{$chatnet})) {
    if ($chatnet =~ /^freenode$/) {

      return if ($text !~ /this nickname is registered./i) ||
        ($nick !~ /NickServ/);

      if ($address !~ 'NickServ@services.') {
        print("!!!'$nick($address)' trying to cause nickserv authentication, but " .
          "the host is not recognized as the freenode nickserv host!!!", MSGLEVEL_CRAP);
        return;
      }

      $server->command("msg NickServ identify " . $passwords{$chatnet});
    }
  }
}

sub channel_joined {
  my ($channel,) = @_;

  my $name = $channel->{'name'};
  my $chatnet = $channel->{'server'}->{'chatnet'};

  if ($chatnet =~ /^bitlbee$/ && $name =~ /^&bitlbee$/ && exists($passwords{'bitlbee'})) {
    $channel->command("msg &bitlbee identify " . $passwords{'bitlbee'});
  } else {
    print $name ;
  }
}

reload_passwords;

signal_add 'event notice', 'event_notice';
signal_add 'channel joined', 'channel_joined';