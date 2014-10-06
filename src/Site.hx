import ufront.app.UfrontApplication;
import ufront.web.result.*;
import ufront.web.*;
import ufront.view.*;
import SiteData;
using StringTools;

class Site extends Controller {

	static function main() {
		new UfrontApplication({
			indexController: Site,
			defaultLayout: "layout.html"
		})
		.addTemplatingEngine( TemplatingEngines.erazor )
		.executeRequest();
	}

	@inject public var api:SiteDataApi;

	@:route("/import/")
	public function doImport() {
		api.importFromHairSalon();
		return "done";
	}

	@:route("/")
	public function home() {
		return new ViewResult( {
			title: null,
			bgClass: "home",
			menuItems: getMenuItems()
		} );
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

	function getProfiles():Map<String,Profile> {
		var profiles = new Map();
		for ( profile in api.loadFromJson().profiles ) {
			profiles.set( profile.url, profile );
		}
		return profiles;
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
