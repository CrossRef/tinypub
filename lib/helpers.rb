

### Subscription methods

# Simply checks to see if the remote address is included in the subscribers table
def check_subscription
	LOGGER.info "checking subscription for ip address:  #{request.env['REMOTE_ADDR']}"
	raise UnrecognizedIPAddress unless (Subscribers.count(:ip => IPAddr.new(request.env['REMOTE_ADDR'])) > 0 )
	LOGGER.info "yay, a subscriber!"
end

### Propsect license methods

# Query the CrossRef Click-Through Service for info related to the provided CLICKTHROUGH_CLIENT_TOKEN
def get_profile(xq_publisher_token, xq_client_token)
	LOGGER.info "get researcher profile from Click-Through Service using publisher_token #{xq_publisher_token}"
	begin
		response = 	RestClient.get("https://apps.crossref.org/clickthrough/api/licenses/#{xq_client_token}", { :cr_clickthrough_publisher_token => xq_publisher_token })
	rescue Exception => e
		LOGGER.error "error looking up license with Click-Through Service: #{e.http_code}"
		case e.http_code
		when 404
			raise APITokenNotFound
		when 500
			raise ClickThroughServiceDown
		else
			raise e
		end
	end
	return JSON.parse response
end

# See if the CrossRef Click-Through Service Record says that CR_CLICKTHROUGH_CLIENT_API_TOKEN has accpted an appropriate license 
def has_accepted_clickthrough_license?
	client_api_token = request.env['HTTP_CR_CLICKTHROUGH_CLIENT_TOKEN']
	clickthrough_profile = get_profile(settings.clickthrough_publisher_api_token,client_api_token)
	clickthrough_profile['licenses'].each do |license|
		settings.accepted_licenses.each do |accepted_license|
			return true if license['uri'] == accepted_license && license['status'] == 'accepted'
		end
	end
	return false
end

### Control the timing of license checks with Click-Through Service

# Don't want Click-Through Service to become a bottleneck by
# Being paranoid, so we only check the API token
# with Click-Through Service once every X minutes
# instead of at every query.
# NB, you could as easily make this once every X queries instead.
def check_license researcher
	if Time.now > researcher.license_check_reset_time
		LOGGER.info "but it is time to do a periodic check with the Click-Through Service..."
		reset_license_check researcher 
		raise LicenseNotAccepted unless has_accepted_clickthrough_license? 
	else
		LOGGER.info "skip check with Click-Through service and rely on local data..."
	end
end

def reset_license_check researcher
	researcher.license_check_reset_time = next_license_check_time
	researcher.save
end

def next_license_check_time
	return (Time.now.utc + settings.license_trust_length)
end



### Manage Researcher session

def researcher_session
	LOGGER.info "getting researcher session information"
	api_token = request.env['HTTP_CR_CLICKTHROUGH_CLIENT_TOKEN']
	researcher =  Researchers.first( :api_token => api_token )
	# If we have a record for the api_token, return it
	LOGGER.info "we have this researcher already in our local database" if researcher
	return researcher if researcher
	# otherwise, check to see if the Click-Through Service knows about the  API token
	LOGGER.info "we do not have this researcher in our local database, we need to check with Click-Through Service" 
	
	clickthrough_profile = get_profile(settings.clickthrough_publisher_api_token,api_token)
	# It seems to be registered with the Click-Through Service, save session info locally so we can keep track of rate limiting
	LOGGER.info "they appear to be legit, so we create them a local record and return it" 
	
	# The Click-Through service does not currently supply the ORCID of the researcher.
	orcid = "not supplied"
	Researchers.create( :api_token => api_token, :window_count => 0, :window_reset_time => next_window_time, :orcid => orcid, :license_check_reset_time => next_license_check_time )
end

### Rate limiting methods

def next_window_time
	return (Time.now.utc + settings.window_length)
end

def reset_window researcher
	researcher.window_count = 0
	researcher.window_reset_time = next_window_time
end

def rate_limit researcher
	reset_window researcher if Time.now > researcher.window_reset_time
	if researcher.window_count >= settings.window_query_limit
		raise RateLimitExceeded
	end
	researcher.window_count += 1
	researcher.save
	{
		'CR-TDM-Rate-Limit' => "#{settings.window_query_limit}",
		'CR-TDM-Rate-Limit-Remaining' => "#{settings.window_query_limit - researcher.window_count}",
		'CR-TDM-Rate-Limit-Reset' => "#{researcher.window_reset_time.to_i}"
	}
end

### Generate fake content

def generate_pdf id
	pdf = Prawn::Document.new
	pdf.text "Journal Name: #{settings.journal_name}"
	pdf.text "Publisher: #{settings.publisher_name}"
	pdf.text "This is a fake full text document for the document: #{id}"
	pdf.text ""
	pdf.text "Abstract: Blah, Blah, Blah"
	pdf.text ""
	pdf.text "Blah, Blah, Blah, Blah, Blah..."
	pdf.render_file "fulltext/example.pdf"
end

### Misc utitlities

def selected_doi
	argument = params[:splat].join
	raise InvalidDOI unless is_valid_doi? argument
	return argument
end

def is_valid_doi? text
	text =~ /^10\.\d{4,6}(\.[\.\w]+)*\/\S+$/
end

def ensure_ssl
	redirect 'https://' + settings.site_uri + request.fullpath , 'Please use SSL when providing credendtials.' unless request.secure?
end

## Errors

# Let's be specific about  errors so that researchers
# can easily debug their TDM tools

class AnnalsError < StandardError
	attr_accessor :status
end

class InvalidDOI < AnnalsError
	def initialize
		@status = 400
		super("Invalid DOI")
	end
end

## Publisher ACS Errors

class UnrecognizedIPAddress < AnnalsError
	def initialize
		@status = 401
		super("Not from subscribed IP address")
	end
end


## Propspect API Errors

class APITokenNotFound < AnnalsError
	def initialize
		@status = 401
		super("Click-Through Service API Token Not Found")
	end
end

class LicenseNotAccepted < AnnalsError
	def initialize
		@status = 401
		super("Client has not accepted appropriate license")
	end
end

class APITokenRevoked < AnnalsError
	def initialize
		@status = 401
		super("Click-Through Service API Token Revoked")
	end
end

class RateLimitExceeded < AnnalsError
	def initialize
		@status = 429
		super("Click-Through Service Rate Limit Exceeded")
	end
end

class ClickThroughServiceDown < AnnalsError
	def initialize
		@status = 502
		super("Click-Through Service License Checking API is down")
	end
end
