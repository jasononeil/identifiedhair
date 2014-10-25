import haxe.Json;
import ufront.api.UFApi;
import sys.io.File;
import SimpleHtmlDom;
import haxe.Utf8;
import haxe.Http;
import ufront.sys.SysUtil;
import SiteData;
using StringTools;

/**
	A simple API to help load our SiteData from JSON, scrape content from another web service etc.
**/
class SiteDataApi extends UFApi {

	/** The contentDirectory is the path to a directory that ufront has write-permissions for. We'll save our data there. **/
	@inject("contentDirectory") public var contentDir:String;
	
	var data:SiteData;
	
	public function loadFromJson():SiteData {
		if ( data==null ) {
			try {
				data = Json.parse( File.getContent(contentDir+"siteData.json") );
				if ( data==null )
					throw 'Null';
			}
			catch ( e:Dynamic ) {
				// Return an empty default.
				data = DefaultSiteData.defaults;
			}
		}
		return data;
	}

	public function saveToJson( data:SiteData ) {
		File.saveContent( contentDir+"siteData.json", Json.stringify(data) );
		this.data = data;
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

	function arr(native:php.NativeArray):Iterable<SimpleHtmlDomNode> {
		return php.Lib.hashOfAssociativeArray( native );
	}
}
