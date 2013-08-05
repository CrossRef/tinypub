require 'bundler/setup'
require 'sinatra'
require 'sinatra/config_file'
config_file 'config/application.yml'
require 'json'
require 'logger'
require 'rest_client'
require 'active_support/all'
require 'prawn'
$LOAD_PATH.unshift File.join(File.dirname(File.expand_path(__FILE__)),'lib')
require 'database'


configure :development do
	enable :logging, :dump_errors, :raise_errors
	set :show_exceptions, true
end

configure do
	LOGGER = Logger.new(File.join(File.dirname(__FILE__),'logs','debug.log'))
	LOGGER.info "***** Starting #{settings.journal_name} Server at #{Time.now.utc} UTC *******"
end


helpers do
	require 'helpers'
end

error do
	e = env['sinatra.error']
	status e.status
	JSON.pretty_generate :result => 'error', :message => e.message
end

get '/' do
		erb :index
end

# Landing Page Resource
get '/landing/*' do
	@doi = selected_doi
	erb :landing_page
end

# Fulltext PDF Rresource
get '/fulltext/:id', :provides => [:pdf]  do
	ensure_ssl if settings.force_ssl
	
	check_subscription unless settings.open_access

	prospector = prospector_session
	check_license prospector if settings.check_license_registry

	reply_headers =	{'CR-Propspect-Client-Token' => "#{request.env['HTTP_CR_PROSPECT_CLIENT_TOKEN']}"}
	
	reply_headers.merge! rate_limit prospector if settings.rate_limit

	generate_pdf params[:id]
	
	headers reply_headers
	send_file "fulltext/example.pdf", :type => "application/pdf"
end

# Fulltext XML Rresource
get '/fulltext/:id', :provides => [:xml]  do
	ensure_ssl if settings.force_ssl
	
	check_subscription unless settings.open_access

	prospector = prospector_session
	check_license prospector if settings.check_license_registry

	reply_headers =	{'CR-Propspect-Client-Token' => "#{request.env['HTTP_CR_PROSPECT_CLIENT_TOKEN']}"}
	
	reply_headers.merge! rate_limit prospector if settings.rate_limit

	headers reply_headers
	erb :xml
	
end


