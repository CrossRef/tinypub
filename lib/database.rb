require 'data_mapper'

file_name =  File.join('sqlite://',File.dirname(File.expand_path(__FILE__)),'..','db','access_control.db')
DataMapper.setup(:default, file_name)


class Subscribers
	include DataMapper::Resource
	property :id,         Serial  
	property :name,       String 
	property :ip,         IPAddress, :key => true   
	property :created_at, DateTime 
end


class Prospectors
	include DataMapper::Resource
	property :id,												Serial 
	property :api_token,								String, :key => true
	property :window_count,							Integer
	property :window_reset_time,				DateTime
	property :orcid,										URI
	property :license_check_reset_time, DateTime
end


DataMapper.auto_upgrade!
