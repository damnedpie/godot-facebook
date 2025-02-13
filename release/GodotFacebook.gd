extends Node

signal fb_inited
signal login_success(token)
signal login_cancelled
signal login_failed(error)
signal request_success(result)
signal request_cancelled
signal request_failed(error)
signal logout

var _fb = null
var token = null
var user = null

func _ready():
	pause_mode = Node.PAUSE_MODE_PROCESS
	if(Engine.has_singleton("GodotFacebook")):  # Android
		_fb = Engine.get_singleton("GodotFacebook")
		_fb.init()
		_fb.setFacebookCallbackId(get_instance_id())
		print('Facebook plugin inited')
		emit_signal('fb_inited')

func login(permissions = null):
	if _fb != null:
		if permissions == null:
			permissions = ["public_profile", 'email', 'user_friends']
			#permissions = ["public_profile", 'email']
		_fb.login(permissions)
		return true
	else:
		return false

func gameRequest(message, recipients='', objectId=''):
	if _fb != null:
		_fb.gameRequest(message, recipients, objectId)

func gameRequests(object, method):
	if _fb != null:
		if OS.get_name() == 'iOS':
			_fb.callApi('/me/apprequests', {}, object, method)
		else:
			_fb.callApi('/me/apprequests', {}, object.get_instance_id(), method)

func logout():
	if _fb != null:
		_fb.logout()
		emit_signal('logout')

func isLoggedIn():
	if _fb != null:
		return _fb.isLoggedIn()
	else:
		return false

func userProfile(object, method):
	if _fb != null:
		if OS.get_name() == 'iOS':
			_fb.callApi('/me', {'fields': 'id,name,first_name,last_name,picture'}, object, method)
		else:
			_fb.callApi('/me', {'fields': 'id,name,first_name,last_name,picture'}, object.get_instance_id(), method)

func getFriends(object, method):
	if _fb != null:
		if OS.get_name() == 'iOS':
			_fb.callApi('/me/friends', {'fields': 'name,first_name,last_name,picture', 'limit': 3000}, object, method)
		else:
			_fb.callApi('/me/friends', {'fields': 'name,first_name,last_name,picture', 'limit': 3000}, object.get_instance_id(), method)

func getInvitableFriends(object, method):
	if _fb != null:
		if OS.get_name() == 'iOS':
			_fb.callApi('/me/invitable_friends', {'fields': 'first_name,last_name,picture', 'limit': 3000}, object, method)
		else:
			_fb.callApi('/me/invitable_friends', {'fields': 'first_name,last_name,picture', 'limit': 3000}, object.get_instance_id(), method)

# FB Analytics

"""

// Public event names

// General purpose
FBSDKAppEventNameCompletedRegistration   = fb_mobile_complete_registration
FBSDKAppEventNameViewedContent           = fb_mobile_content_view
FBSDKAppEventNameSearched                = fb_mobile_search
FBSDKAppEventNameRated                   = fb_mobile_rate
FBSDKAppEventNameCompletedTutorial       = fb_mobile_tutorial_completion
FBSDKAppEventNameContact                 = Contact
FBSDKAppEventNameCustomizeProduct        = CustomizeProduct
FBSDKAppEventNameDonate                  = Donate
FBSDKAppEventNameFindLocation            = FindLocation
FBSDKAppEventNameSchedule                = Schedule
FBSDKAppEventNameStartTrial              = StartTrial
FBSDKAppEventNameSubmitApplication       = SubmitApplication
FBSDKAppEventNameSubscribe               = Subscribe
FBSDKAppEventNameSubscriptionHeartbeat   = SubscriptionHeartbeat
FBSDKAppEventNameAdImpression            = AdImpression
FBSDKAppEventNameAdClick                 = AdClick

// Ecommerce related
FBSDKAppEventNameAddedToCart             = fb_mobile_add_to_cart
FBSDKAppEventNameAddedToWishlist         = fb_mobile_add_to_wishlist
FBSDKAppEventNameInitiatedCheckout       = fb_mobile_initiated_checkout
FBSDKAppEventNameAddedPaymentInfo        = fb_mobile_add_payment_info
FBSDKAppEventNameProductCatalogUpdate    = fb_mobile_catalog_update
FBSDKAppEventNamePurchased               = fb_mobile_purchase

// Gaming related
FBSDKAppEventNameAchievedLevel           = fb_mobile_level_achieved
FBSDKAppEventNameUnlockedAchievement     = fb_mobile_achievement_unlocked
FBSDKAppEventNameSpentCredits            = fb_mobile_spent_credits


// Public event parameter names

FBSDKAppEventParameterNameCurrency               = fb_currency
FBSDKAppEventParameterNameRegistrationMethod     = fb_registration_method
FBSDKAppEventParameterNameContentType            = fb_content_type
FBSDKAppEventParameterNameContent                = fb_content
FBSDKAppEventParameterNameContentID              = fb_content_id
FBSDKAppEventParameterNameSearchString           = fb_search_string
FBSDKAppEventParameterNameSuccess                = fb_success
FBSDKAppEventParameterNameMaxRatingValue         = fb_max_rating_value
FBSDKAppEventParameterNamePaymentInfoAvailable   = fb_payment_info_available
FBSDKAppEventParameterNameNumItems               = fb_num_items
FBSDKAppEventParameterNameLevel                  = fb_level
FBSDKAppEventParameterNameDescription            = fb_description
FBSDKAppEventParameterLaunchSource               = fb_mobile_launch_source
FBSDKAppEventParameterNameAdType                 = ad_type
FBSDKAppEventParameterNameOrderID                = fb_order_id
"""

func setPushToken(token):
	if _fb != null:
		_fb.set_push_token(token)
		
func logEvent(event, value = 0, params = null):
	if _fb != null:
		if value != 0 and params != null:
			_fb.log_event_value_params(event, value, params)
		elif value != 0:
			_fb.log_event_value(event, value)
		elif params != null:
			_fb.log_event_params(event, params)
		else:
			_fb.log_event(event)

func logPurchase(price, currency = 'USD', params = null):
	if _fb != null:
		if params != null:
			_fb.log_purchase_params(price, currency, params)
		else:
			_fb.log_purchase(price, currency)

func deepLinkUri():
	if _fb != null:
		return _fb.deep_link_uri()
	else:
		return null

func deepLinkRef():
	if _fb != null:
		return _fb.deep_link_ref()
	else:
		return null

func deepLinkPromo():
	if _fb != null:
		return _fb.deep_link_promo()
	else:
		return null

func setAdvertiserTracking(enabled: bool) -> void:
	if _fb != null and OS.get_name() == 'iOS':
		_fb.setAdvertiserTracking(enabled)
	

# FACEBOOK SDK CALLBACKS

func login_success(tkn):
	token = tkn
	print('Facebook login success: %s'%tkn)
	emit_signal('login_success', tkn)

func login_cancelled():
	token = null
	user = null
	print('Facebook login cancelled')
	emit_signal('login_cancelled')

func login_failed(error):
	token = null
	user = null
	print('Facebook login failed: %s'%error)
	emit_signal('login_failed', error)

func request_success(result):
	#print('Facebook request finished: %s'%var2str(result))
	emit_signal('request_success', result)

func request_cancelled():
	push_warning('Facebook request cancelled')
	emit_signal('request_cancelled')

func request_failed(err):
	push_error('Facebook request failed: %s'%var2str(err))
	emit_signal('request_failed', err)
