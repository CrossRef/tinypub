require 'bundler/setup'
$LOAD_PATH.unshift File.join(File.dirname(File.expand_path(__FILE__)),'..','lib')
require 'database'
require 'json'

name = ARGV.shift
ip = ARGV.shift
abort "You need to provide a name and IP address" unless name && ip
begin
	s = Subscribers.create(:name => name, :ip => IPAddr.new(ip))
	puts "Added IP Address:\n #{s.to_json}"
rescue Exception => e
	STDERR.puts "Error: #{e}"
end
puts "Done"

