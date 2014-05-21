package MainMenu
{
	import Assets.AssetsManager;

	public class MainMenuXMLManager
	{
		private const CONFIG_XML:String = "BoardsConfigXML";
		private const BOARD_CHILD:String = "board";
		
		private static var _instance:MainMenuXMLManager;
		
		private var _mainMenuConfig:XML;
		
		public function get MainMenuConfig():XML
		{
			return _mainMenuConfig;
		}
		
		public function get BoardChilds():XMLList
		{
			return _mainMenuConfig.child(BOARD_CHILD);
		}
		
		public function MainMenuXMLManager(key:SingletonKey)
		{
			if(!key)
			{
				throw new Error('Singleton, use the get instance method.');
			}
		}
		
		public static function getInstance():MainMenuXMLManager
		{
			if(_instance == null)
			{
				_instance = new MainMenuXMLManager(new SingletonKey);
				_instance._mainMenuConfig = AssetsManager.getXML(_instance.CONFIG_XML);
			}
			
			return _instance;
		}
	}
}

class SingletonKey{
}