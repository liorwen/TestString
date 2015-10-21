package model
{

	public class chipManager
	{
		private static var _instance:chipManager;

		public function chipManager(enforcer:SingletonEnforcer)
		{
		}

		public static function get instance():chipManager
		{
			if (!_instance)
				_instance = new chipManager(new SingletonEnforcer());
			return _instance;
		}
	}
}

internal class SingletonEnforcer
{
}
