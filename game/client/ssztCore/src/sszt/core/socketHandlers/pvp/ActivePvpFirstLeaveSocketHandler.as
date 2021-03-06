package sszt.core.socketHandlers.pvp
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.interfaces.socket.IPackageOut;
	
	public class ActivePvpFirstLeaveSocketHandler extends BaseSocketHandler
	{
		public function ActivePvpFirstLeaveSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		override public function getCode():int
		{
			return ProtocolType.ACTIVE_PVP_FIRST_QUIT;
		}
		
		override public function handlePackage():void
		{
//			var successful:Boolean = _data.readBoolean();
//			var quitTime:int = _data.readInt();
//			if(successful)
//			{
//				GlobalData.selfPlayer.resourceWarQuitTime = quitTime;
//			}
			handComplete();
		}
		
		public static function send() : void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.ACTIVE_PVP_FIRST_QUIT);
			GlobalAPI.socketManager.send(pkg);
		} 
	}
}