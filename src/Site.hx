import ufront.app.UfrontApplication;
import ufront.web.result.*;
import ufront.web.*;
import ufront.view.*;
import SiteData;
using StringTools;

/**
	This class is the main controller for our site, and also has the `main` entry point function.
**/
class Site extends Controller {

	/**
		The entry-point for our ufront app.
		PHP will start executing here, and use this class as our main controller.
	**/
	static function main() {
		new UfrontApplication({
			indexController: Site,
			defaultLayout: "layout.html"
		})
		.addTemplatingEngine( TemplatingEngines.erazor )
		.executeRequest();
	}

	//
	// Member variables
	//

	// All APIs are available through dependency injection, let's inject our (only) API.
	@inject public var api:SiteDataApi;

	//
	// Routes
	//

	@:route("/")
	public function home() {
		return new ViewResult( {
			title: null,
			bgClass: "home",
			menuItems: getMenuItems()
		} );
	}

	@:route("/import/")
	public function doImport() {
		api.importFromHairSalon();
		return "Done!";
	}

	@:route("/news/")
	public function news() {
		return new ViewResult( {
			title: "News and Updates",
			menuItems: getMenuItems(),
			bgClass: "news",
		} );
	}

	@:route("/gallery/")
	public function gallery() {
		return new ViewResult( {
			title: "Photo Gallery",
			menuItems: getMenuItems(),
			bgClass: "gallery",
			embedURL: "http://embedsocial.com/facebook_album/album_photos/321638951314925"
		} );
	}

	@:route("/about/")
	public function salon() {
		return new ViewResult( {
			title: "About Our Salon",
			menuItems: getMenuItems(),
			bgClass: "about-salon",
		} );
	}

	@:route("/about/team/")
	public function team() {
		return new ViewResult( {
			title: "About Our Team",
			menuItems: getMenuItems(),
			bgClass: "about-team",
			profiles: getProfiles(),
			profileDir: getProfileDir(),
		} );
	}

	@:route("/about/team/$name/")
	public function profile( name:String ) {
		var profile = getProfiles().get( name );
		if ( profile==null )
			throw HttpError.pageNotFound();
		return new ViewResult( {
			title: 'Our Team - ${profile.name}',
			menuItems: getMenuItems(),
			bgClass: 'about-team-$name',
			profile: profile,
			profileDir: getProfileDir(),
		} );
	}

	@:route("/services-and-contact/")
	public function servicesAndContact() {
		return new ViewResult( {
			title: "Services, Contact and Open Hours",
			menuItems: getMenuItems(),
			bgClass: 'contact',
			openHours: api.loadFromJson().openHours,
		} );
	}

	//
	// Private methods
	//

	function getProfiles():Map<String,Profile> {
		var profiles = new Map();
		for ( profile in api.loadFromJson().profiles ) {
			profiles.set( profile.url, profile );
		}
		return profiles;
	}

	function getProfileDir():String {
		return "/" + context.contentDirectory.substr( context.request.scriptDirectory.length ) + "profile-pics/";
	}

	function getMenuItems():Array<MenuItem> {
		var currentUri = context.getRequestUri();
		return [
			{ text:"Home", url: "/", active: currentUri=="/" },
			{ text:"News", url: "/news", active: currentUri=="/news" },
			{ text:"About", url: "/about", active: currentUri.startsWith("/about"), children: [
				{ text: "Salon", url: "/about", active: currentUri=="/about" },
				{ text: "Team", url: "/about/team", active: currentUri=="/about/team" },
			] },
			{ text:"Gallery", url: "/gallery", active: currentUri=="/gallery" },
			{ text:"Services and Contact", shortText:"Contact", url: "/services-and-contact", active: currentUri=="/services-and-contact" },
		];
	}
}

typedef MenuItem = {
	var text:String;
	var url:String;
	var active:Bool;
	@:optional var shortText:String;
	@:optional var children:Array<MenuItem>;
}
