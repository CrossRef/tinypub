

### Subscription methods

# Simply checks to see if the remote address is included in the subscribers table
def check_subscription
	LOGGER.info "checking subscription for ip address:  #{request.env['REMOTE_ADDR']}"
	raise UnrecognizedIPAddress unless (Subscribers.count(:ip => IPAddr.new(request.env['REMOTE_ADDR'])) > 0 )
	LOGGER.info "yay, a subscriber!"
end

### Propsect license methods

# Query the CrossRef Prospect Server for info related to the provided PROSPECT_CLIENT_TOKEN
def get_profile(xq_publisher_token, xq_client_token)
	LOGGER.info "get prospector profile from Prospect License Registry using publisher_token #{xq_publisher_token}"
	begin
		response = 	RestClient.get("https://prospect.crossref.org/licenses/#{xq_client_token}", { :cr_prospect_publisher_token => xq_publisher_token })
	rescue Exception => e
		LOGGER.error "error looking up license with Prospect service: #{e.http_code}"
		case e.http_code
		when 404
			raise APITokenNotFound
		when 500
			raise ProspectLicenseServerDown
		else
			raise e
		end
	end
	return JSON.parse response
end

# See if the CrossRef Prospect Record says that PROSPECT_CLIENT_API_TOKEN has accpted an appropriate license 
def has_accepted_prospect_license?
	client_api_token = request.env['HTTP_CR_PROSPECT_CLIENT_TOKEN']
	prospect_profile = get_profile(settings.prospect_publisher_api_token,client_api_token)
	prospect_profile['licenses'].each do |license|
		settings.accepted_licenses.each do |accepted_license|
			return true if license['uri'] == accepted_license && license['status'] == 'accepted'
		end
	end
	return false
end

### Control the timing of licnese checks with Prospect License Registry

# Don't want Prospect to become a bottleneck by
# Being paranoid, so we only check the API token
# with Prospect once every X minutes
# instead of at every query.
# NB, you could as easily make this once every X queries instead.
def check_license prospector
	if Time.now > prospector.license_check_reset_time
		LOGGER.info "but it is time to do a periodic check with the Prospect License Registry..."
		reset_license_check prospector 
		raise LicenseNotAccepted unless has_accepted_prospect_license? 
	else
		LOGGER.info "skip check with Prospect service and rely on local data..."
	end
end

def reset_license_check prospector
	prospector.license_check_reset_time = next_license_check_time
	prospector.save
end

def next_license_check_time
	return (Time.now.utc + settings.license_trust_length)
end



### Manage Prospector session

def prospector_session
	LOGGER.info "getting prospector session information"
  api_token = request.env['HTTP_CR_PROSPECT_CLIENT_TOKEN']
	prospector =  Prospectors.first( :api_token => api_token )
	# If we have a record for the api_token, return it
	LOGGER.info "we have this prospector already in our local database" if prospector
	return prospector if prospector
	# otherwise, check to see if the Prospect License Registry knows about the  API token
	LOGGER.info "we do not have this prospector in our local database, we need to check with Prospect License Registry" 
	prospect_profile = get_profile(settings.prospect_publisher_api_token,api_token)
	# It seems to be registered with the Prospect License Registry, save session info locally so we can keep track of rate limiting
	LOGGER.info "they appear to be legit, so we create them a local record and return it" 
	orcid = prospect_profile['orcid']
	Prospectors.create( :api_token => api_token, :window_count => 0, :window_reset_time => next_window_time, :orcid => orcid, :license_check_reset_time => next_license_check_time )
end

### Rate limiting methods

def next_window_time
	return (Time.now.utc + settings.window_length)
end

def reset_window prospector
	prospector.window_count = 0
	prospector.window_reset_time = next_window_time
end

def rate_limit prospector
	reset_window prospector if Time.now > prospector.window_reset_time
	if prospector.window_count >= settings.window_query_limit
		raise RateLimitExceeded
	end
	prospector.window_count += 1
	prospector.save
	{
		'CR-Prospect-Rate-Limit' => "#{settings.window_query_limit}",
		'CR-Prospect-Rate-Limit-Remaining' => "#{settings.window_query_limit - prospector.window_count}",
		'CR-Prospect-Rate-Limit-Reset' => "#{prospector.window_reset_time.to_i}"
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
		super("Prospect API Token Not Found")
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
		super("Prospect API Token Revoked")
	end
end

class RateLimitExceeded < AnnalsError
	def initialize
		@status = 401
		super("Prospect Rate Limit Exceeded")
	end
end

class ProspectLicenseServerDown < AnnalsError
	def initialize
		@status = 502
		super("Prospect License Checking API is down")
	end
end
