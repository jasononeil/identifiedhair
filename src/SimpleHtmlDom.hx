import php.*;

/**
	SimpleHtmlDom is a PHP utility for scraping web data, even from badly formed pages.
	This extern provides access to the tool from Haxe.
	You must have the "simple_html_dom.php" file in your "www/" directory for this to work.

	Please note these externs are not complete - they just provide enough for what I was trying to accomplish.
**/
extern class SimpleHtmlDom {

	static inline var DEFAULT_TARGET_CHARSET = "UTF-8";
	static inline var DEFAULT_BR_TEXT = "\r\n";
	static inline var DEFAULT_SPAN_TEXT = " ";
	static inline var MAX_FILE_SIZE = 600000;

	public static inline function loadHtmlFromFile(
		url:String,
		?use_include_path:Bool=false,
		?context:Bool=null,
		?offset:Int=-1,
		?maxLen:Int=-1,
		?lowercase:Bool = true,
		?forceTagsClosed:Bool=true,
		?target_charset:String = DEFAULT_TARGET_CHARSET,
		?stripRN:Bool=true,
		?defaultBRText:String=DEFAULT_BR_TEXT,
		?defaultSpanText:String=DEFAULT_SPAN_TEXT
	):SimpleHtmlDom {
		untyped __call__("include_once", "simple_html_dom.php");
		return untyped __call__( "file_get_html", url, use_include_path, context, offset, maxLen, lowercase, forceTagsClosed, target_charset, stripRN, defaultBRText, defaultSpanText );
	}

	public static inline function loadHtmlFromString(
		str:String,
		?lowercase:Bool=true,
		?forceTagsClosed:Bool=true,
		?target_charset:String = DEFAULT_TARGET_CHARSET,
		?stripRN:Bool=true,
		?defaultBRText:String=DEFAULT_BR_TEXT,
		?defaultSpanText:String=DEFAULT_SPAN_TEXT
	):SimpleHtmlDom {
		untyped __call__("include_once", "simple_html_dom.php");
		return untyped __call__( "str_get_html", lowercase, forceTagsClosed, target_charset, stripRN, defaultBRText, defaultSpanText, str );
	}

	public static inline function dumpHtmlTree(
		node:SimpleHtmlDomNode,
		?showAttr:Bool=true,
		?deep:Int=0
	):String {
		untyped __call__("include_once", "simple_html_dom.php");
		return untyped __call__( "dump_html_tree", node, show_attr, deep );
	}

	@:native("outertext")
	public function outerText():String;

	@:native("innertext")
	public function innerText():String;

	@:overload(function(selector:String, idx:Int, ?lowercase:Bool):SimpleHtmlDomNode {})
	public function find( selector:String , ?lowercase:Bool ):NativeArray;

	@:overload(function(id:Int):SimpleHtmlDomNode {})
	public function childNodes():NativeArray;

	public function firstChild():SimpleHtmlDomNode;

	public function lastChild():SimpleHtmlDomNode;

	public function createElement( name:String, value:String ):SimpleHtmlDomNode;

	public function createTextNode( value:String ):SimpleHtmlDomNode;

	public function getElementById( id:String ):SimpleHtmlDomNode;

	@:overload(function(id:Int,idx:Int):SimpleHtmlDomNode {})
	public function getElementsById( id:String ):NativeArray;

	public function getElementByTagName( name:String ):SimpleHtmlDomNode;

	@:overload(function(name:String,idx:Int):SimpleHtmlDomNode {})
	public function getElementsByTagName( name:String ):NativeArray;

	public function loadFile( args:Dynamic ):SimpleHtmlDom;
}

@:native("simple_html_dom_node")
extern class SimpleHtmlDomNode {

	@:native("outertext")
	public function outerText():String;

	@:native("innertext")
	public function innerText():String;

	@:overload(function(selector:String, idx:Int, ?lowercase:Bool):SimpleHtmlDomNode {})
	public function find( selector:String , ?lowercase:Bool ):NativeArray;

	public function getAllAttributes():NativeArray;

	public function getAttribute( name:String ):String;

	public function setAttribute( name:String, value:String ):Void;

	public function hasAttribute( name:String ):Bool;

	public function removeAttribute( name:String ):Void;

	public function getElementById( id:String ):SimpleHtmlDomNode;

	@:overload(function(id:String,idx:Int):SimpleHtmlDomNode {})
	public function getElementsById( id:String ):NativeArray;

	public function getElementByTagName( name:String ):SimpleHtmlDomNode;

	@:overload(function(name:String,idx:Int):SimpleHtmlDomNode {})
	public function getElementsByTagName( name:String ):NativeArray;

	public function parentNode():SimpleHtmlDomNode;

	@:overload(function(idx:Int):SimpleHtmlDomNode {})
	public function childNodes():NativeArray;

	public function firstChild():SimpleHtmlDomNode;

	public function lastChild():SimpleHtmlDomNode;

	public function nextSibling():SimpleHtmlDomNode;

	public function previousSibling():SimpleHtmlDomNode;

	public function hasChildNodes():Bool;

	public function nodeName():String;

	public function appendChild( node:SimpleHtmlDomNode ):SimpleHtmlDomNode;
}

@:enum abstract HDomType(Int) {
	var HDOM_TYPE_ELEMENT = 1;
	var HDOM_TYPE_COMMENT = 2;
	var HDOM_TYPE_TEXT = 3;
	var HDOM_TYPE_ENDTAG = 4;
	var HDOM_TYPE_ROOT = 5;
	var HDOM_TYPE_UNKNOWN = 6;
}

@:enum abstract HDomQuote(Int) {
	var HDOM_QUOTE_DOUBLE = 0;
	var HDOM_QUOTE_SINGLE = 1;
	var HDOM_QUOTE_NO = 3;
}

@:enum abstract HDomInfo(Int) {
	var HDOM_INFO_BEGIN = 0;
	var HDOM_INFO_END = 1;
	var HDOM_INFO_QUOTE = 2;
	var HDOM_INFO_SPACE = 3;
	var HDOM_INFO_TEXT = 4;
	var HDOM_INFO_INNER = 5;
	var HDOM_INFO_OUTER = 6;
	var HDOM_INFO_ENDSPACE = 7;
}
