package Assets
{
	import flash.display.Bitmap;
	import flash.utils.Dictionary;
	
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;

	public class AssetsManager
	{
		[Embed(source="../../media/textures/maintexture.png")]
		public static const mainAtlasTexture:Class;
		
		[Embed(source="../../media/textures/maintexture.xml", mimeType="application/octet-stream")]
		public static const mainAtlasXML:Class;
		
		public static var gameTextures:Dictionary = new Dictionary();
		public static var gameXMLs:Dictionary = new Dictionary();
		public static var gameAtlas:Dictionary = new Dictionary();
		
		public static function getTexture(name:String):Texture
		{
			if(gameTextures[name] == undefined) 
			{
				var bitmap:Bitmap = new AssetsManager[name]();
				gameTextures[name] = Texture.fromBitmap(bitmap);
			}
			return gameTextures[name];
		}
		
		public static function getXML(name:String):XML
		{
			if(gameXMLs[name] == undefined)
			{
				var xml:XML = XML(new AssetsManager[name]());
				gameXMLs[name] = xml;
			}
			return gameXMLs[name];
		}
		
		public static function getAtlas(name:String):TextureAtlas
		{
			if(gameAtlas[name] == undefined)
			{
				var texture:Texture = getTexture(name + "Texture");
				var xml:XML = getXML(name + "XML");
				gameAtlas[name] = new TextureAtlas(texture, xml);
			}
			return gameAtlas[name];
		}
	}
}