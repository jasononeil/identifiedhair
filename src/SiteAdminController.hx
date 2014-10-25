import ufront.web.result.*;
import ufront.web.*;
import ufront.view.*;
import SiteData;
import tink.CoreApi;

@layout("layout.html")
@viewFolder("admin")
class SiteAdminController extends Controller {

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