/**
	The default data if our JSON fails to load.
**/
class DefaultSiteData {
	public static var defaults = {
		contactDetails: {
			address:"",
			phone:"",
			phoneNoSpaces:"",
			email:"",
			website:"",
			facebook:""
		},
		homepage: {
			title:"",
			content:""
		},
		aboutOurSalon: {
			title:"",
			content:""
		},
		profiles: [],
		openHours: [],
	}
}

/**
	A summary of all the data on the site.
**/
typedef SiteData = {
	contactDetails:ContactDetails,
	homepage:Page,
	aboutOurSalon:Page,
	profiles:Array<Profile>,
	openHours:Array<OpenHours>,
}

/**
	A simple page with a title and HTML content.
**/
typedef Page = {
	title:String,
	content:String
}

/**
	The contact details for the salon.
**/
typedef ContactDetails = {
	address:String,
	phone:String,
	phoneNoSpaces:String,
	email:String,
	website:String,
	facebook:String
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
