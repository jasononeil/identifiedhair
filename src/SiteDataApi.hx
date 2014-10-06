import haxe.Json;
import ufront.api.UFApi;
import sys.io.File;
import SimpleHtmlDom;
import haxe.Utf8;
import haxe.Http;
import ufront.sys.SysUtil;
import SiteData;
using StringTools;

class SiteDataApi extends UFApi {

	@inject("contentDirectory") public var contentDir:String;

	public function loadFromJson():SiteData {
		try {
			var json = File.getContent( contentDir+"siteData.json" );
			return Json.parse( json );
		}
		catch ( e:Dynamic ) {
			// Return an empty default.
			return {
				homepage: "",
				newsText: "",
				newsLinks: [],
				aboutOurSalon: "",
				profiles: [],
				servicesAndContact: "",
				openHours: [],
			}
		}
	}

	public function saveToJson( data:SiteData ) {
		var json = Json.stringify( data );
		File.saveContent( contentDir+"siteData.json", json );
	}

	/**
		We can scrape data from http://www.hairsalon.com.au/identified-hair-kensington/
		This saves the staff having to update everything twice.
		Yes, this is very hacky.
	**/
	public function importFromHairSalon() {
		var data = loadFromJson();
		var dom = SimpleHtmlDom.loadHtmlFromFile( "http://www.hairsalon.com.au/identified-hair-kensington/" );
		data.profiles = importStaffProfiles( dom );
		data.openHours = importOpenHours( dom );
		saveToJson( data );
	}

	function importStaffProfiles( dom:SimpleHtmlDom ):Array<Profile> {
		var profiles = [];
		for ( tr in arr(dom.find(".team_profiles tr")) ) {
			var name = tr.find( '.team_member img', 0 ).getAttribute( 'alt' );
			var url = name.trim().toLowerCase().replace(" ","-");
			var position = tr.find( '.team_member_info p', 1 ).innerText();

			var imgSrc = tr.find( '.team_member img', 0 ).getAttribute( 'src' );
			var imgData = Http.requestUrl( 'http://hairsalon.com.au/$imgSrc' );
			var profileDir = contentDir+'profile-pics/';
			SysUtil.mkdir( profileDir );
			File.saveContent( profileDir+'$url.jpg', imgData );

			var bio = "";
			for ( part in arr(tr.find('.team_member_info',0).childNodes()) ) {
				bio += part.outerText();
			}

			profiles.push({ url: url, name: name, position: position, bio: bio });
		}
		return profiles;
	}

	function importOpenHours( dom:SimpleHtmlDom ):Array<OpenHours> {
		var days = [];
		for ( tr in arr(dom.find(".business_hours tr")) ) {
			var day = tr.find( "td strong", 0 ).innerText();
			var open = tr.find( "td", 1 ).innerText();
			var close = tr.find( "td", 3 ).innerText();
			days.push({ day:day, open:open, close:close });
		}
		return days;
	}

	static function arr(native:php.NativeArray):Iterable<SimpleHtmlDomNode> {
		return php.Lib.hashOfAssociativeArray( native );
	}
}
