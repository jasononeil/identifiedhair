typedef SiteData = {
	homepage:String,
	newsText:String,
	newsLinks:Array<NewsLink>,
	aboutOurSalon:String,
	profiles:Array<Profile>,
	servicesAndContact:String,
	openHours:Array<OpenHours>,
}

typedef Profile = {
	url:String,
	name:String,
	position:String,
	bio:String,
}

typedef OpenHours = {
	day:String,
	open:String,
	close:String
}

typedef NewsLink = {
	text:String,
	link:String
}
