package Assets
{
	import flash.display.Bitmap;
	import flash.utils.Dictionary;
	
	import starling.textures.Texture;

	public class AssetsManager
	{
		[Embed(source="../../media/graphics/background_01.jpg")]
		public static const background_01:Class;
		
		[Embed(source="../../media/graphics/background_02.jpg")]
		public static const background_02:Class;
		
		public static var gameTextures:Dictionary = new Dictionary();
		
		public static function getTexture(name:String):Texture
		{
			if(gameTextures[name] == undefined) 
			{
				var bitmap:Bitmap = new AssetsManager[name]();
				gameTextures[name] = Texture.fromBitmap(bitmap);
			}
			return gameTextures[name];
		}
	}
}