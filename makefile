setup:
	rake install:local
	rvm gemset create demo
	rvm gemset use demo
	gem install --local pkg/slack_alarm-0.1.0.gem
	gem info slack_alarm

remove:
	gem uninstall slack_alarm

run:
	ruby test/ping.rb
