/**
	A summary of all the data on the site.
**/
typedef SiteData = {
	homepage:String,
	newsText:String,
	newsLinks:Array<NewsLink>,
	aboutOurSalon:String,
	profiles:Array<Profile>,
	servicesAndContact:String,
	openHours:Array<OpenHours>,
}

/**
	An individual staff profile.
**/
typedef Profile = {
	url:String,
	name:String,
	position:String,
	bio:String,
}

/**
	Opening hours information for a given day.
**/
typedef OpenHours = {
	day:String,
	open:String,
	close:String
}

/**
	A link to a news article.
**/
typedef NewsLink = {
	text:String,
	link:String
}
