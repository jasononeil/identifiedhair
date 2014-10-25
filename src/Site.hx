import ufront.app.UfrontApplication;
import ufront.web.result.*;
import ufront.web.*;
import ufront.view.*;
import SiteData;
import tink.CoreApi;
using StringTools;

/**
	This class is the main controller for our site, and also has the `main` entry point function.
**/
class Site extends Controller {
	
	public static var conf = CompileTime.parseJsonFile( "siteconf.json" );

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
	// Member variables and methods
	//

	// All APIs are available through dependency injection, let's inject our (only) API.
	@inject public var api:SiteDataApi;
	
	// Runs after dependency injection
	@post public function init() {
		ViewResult.globalValues.setObject({
			menuItems: getMenuItems(),
			contactDetails: api.loadFromJson().contactDetails
		});
	}
	
	//
	// Routes
	//

	@:route("/")
	public function home() {
		return new ViewResult( {
			title: null,
			bgClass: "home",
			content: api.loadFromJson().homepage
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
			bgClass: "news",
			newsDownloadLink: '/uf-content/${conf.newsFilename}',
		} );
	}

	@:route("/gallery/")
	public function gallery() {
		return new ViewResult( {
			title: "Photo Gallery",
			bgClass: "gallery",
			embedURL: conf.embedURL
		} );
	}

	@:route("/about/")
	public function salon() {
		return new ViewResult( {
			title: "About Our Salon",
			content: api.loadFromJson().aboutOurSalon,
			bgClass: "about-salon",
		} );
	}

	@:route("/about/team/")
	public function team() {
		return new ViewResult( {
			title: "About Our Team",
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
			bgClass: 'about-team-$name',
			profile: profile,
			profileDir: getProfileDir(),
		} );
	}

	@:route("/services-and-contact/")
	public function servicesAndContact() {
		return new ViewResult( {
			title: "Services, Contact and Open Hours",
			bgClass: 'contact',
			openHours: api.loadFromJson().openHours,
			menuDownloadLink: '/uf-content/${conf.menuFilename}',
		} );
	}
	
	@:route("/idh-admin/*")
	public function admin() {
		var message = "Please Login";
		var failure = "Login Failed. Contact Jason on 0428 998 916 or <a href='mailto:jason.oneil@gmail.com'>jason.oneil@gmail.com</a> if you need help.";
		
		var cred = Site.conf.adminCredentials;
		return HttpAuthResult.requireAuth( context, cred.user, cred.pass, message, failure, function() {
			return executeSubController( SiteAdmin );
		});
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

@layout("layout.html")
@viewFolder("admin")
class SiteAdmin extends Controller {

	@inject public var api:SiteDataApi;

	@:route(GET,"/") function index() {
		var siteData = api.loadFromJson();
		return new ViewResult(siteData);
	}

	@:route(POST,"/save/") function submit( args:{ address:String, phone:String, email:String, website:String, facebook:String, homeTitle:String, homeContent:String, aboutSalonTitle:String, aboutSalonContent:String, ?news:String, ?menu:String }) {
		var r = ~/[^0-9+]/g;
		var phoneNoSpaces = r.replace(args.phone,"");
		
		// Save the form data.
		var siteData = api.loadFromJson();
		siteData.contactDetails.address = args.address;
		siteData.contactDetails.phone = args.phone;
		siteData.contactDetails.phoneNoSpaces = phoneNoSpaces;
		siteData.contactDetails.email = args.email;
		siteData.contactDetails.website = args.website;
		siteData.contactDetails.facebook = args.facebook;
		siteData.homepage.title = args.homeTitle;
		siteData.homepage.content = args.homeContent;
		siteData.aboutOurSalon.title = args.aboutSalonTitle;
		siteData.aboutOurSalon.content = args.aboutSalonContent;
		api.saveToJson( siteData );
		
		// Scrape data from HairSalon.com.au
		try api.importFromHairSalon() catch(e:Dynamic) ufError( 'Error importing from HairSalon: $e' );
		
		// Save the uploads
		var futures = [];
		var contentDir = context.contentDirectory;
		if( args.news!="" ) {
			var f = context.request.files["news"].writeToFile( contentDir+'IdentifiedHairNews.pdf' );
			futures.push( f );
		}
		if( args.menu!="" ) {
			var f = context.request.files["menu"].writeToFile( contentDir+'IdentifiedHairMenuAndPricing.pdf' );
			futures.push( f );
		}
		
		// Once the uploads are done, redirect.
		return Future.ofMany( futures ).map(function (_) {
			return new RedirectResult( baseUri );
		});
	}
}

typedef MenuItem = {
	var text:String;
	var url:String;
	var active:Bool;
	@:optional var shortText:String;
	@:optional var children:Array<MenuItem>;
}
