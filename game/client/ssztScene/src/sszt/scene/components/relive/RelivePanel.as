package sszt.scene.components.relive
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Rectangle;
	import flash.text.TextFormatAlign;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	
	import sszt.constData.CategoryType;
	import sszt.constData.VipType;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.map.MapTemplateList;
	import sszt.core.data.scene.BaseRoleInfoUpdateEvent;
	import sszt.core.data.scene.BaseRoleStateType;
	import sszt.core.data.scene.BaseSceneObjInfoUpdateEvent;
	import sszt.core.data.scene.PlayerStateUpdateEvent;
	import sszt.core.manager.LanguageManager;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.scene.data.types.PlayerHangupType;
	import sszt.scene.mediators.ReliveMediator;
	import sszt.scene.socketHandlers.SkillReliveSocketHandler;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.container.MAlert;
	import sszt.ui.container.MPanel;
	import sszt.ui.event.CloseEvent;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.mcache.btns.MCacheAsset3Btn;
	import sszt.ui.mcache.titles.MCacheTitle1;
	
	import ssztui.ui.TitleTraceryAsset;
	import ssztui.ui.WinTitleHintAsset;

	public class RelivePanel extends MPanel
	{
		private var _mediator:ReliveMediator;
		
		private var _bg:IMovieWrapper;
		
		private var _countryBtn:MCacheAsset3Btn;
		private var _localBtn:MCacheAsset3Btn;
		private var _localFull:MCacheAsset3Btn;
		private var _timer:Timer;
//		private var _hadSend:Boolean;
		private var _hanguping:Boolean;
		private var _sendTime:int;
		
		private var _reliveMalert:MAlert;
		
		public function RelivePanel(mediator:ReliveMediator)
		{
			_mediator = mediator;
//			var title:Bitmap;
//			if(GlobalData.domain.hasDefinition("sszt.scene.ReliveAsset"))
//			{
//				title = new Bitmap(new (GlobalData.domain.getDefinition("sszt.scene.ReliveAsset") as Class)());
//			}
			super(new MCacheTitle1("",new Bitmap(new WinTitleHintAsset())),true,0,false);
		}
		
		override protected function configUI():void
		{
			super.configUI();
			setContentSize(256,160);
			
			_bg = BackgroundUtils.setBackground([
//				new BackgroundInfo(BackgroundType.BORDER_2,new Rectangle(0,0,256,164)),
//				new BackgroundInfo(BackgroundType.BAR_4,new Rectangle(5,5,240,22)),
				new BackgroundInfo(BackgroundType.BORDER_3,new Rectangle(9,4,238,148)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(25,23,205,11),new Bitmap(new TitleTraceryAsset() as BitmapData)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(85,21,166,20),new MAssetLabel(LanguageManager.getWord("ssztl.scene.chooseReliveModle"),MAssetLabel.LABEL_TYPE22,TextFormatAlign.LEFT))
			]);
			addContent(_bg as DisplayObject);
			
			_countryBtn = new MCacheAsset3Btn(3,LanguageManager.getWord("ssztl.scene.birthTownRelive3"));
			_countryBtn.move(28,48);
			addContent(_countryBtn);
			_localBtn = new MCacheAsset3Btn(3,LanguageManager.getWord("ssztl.scene.curPlaceReliveLeftTime",10));
			_localBtn.move(28,78);
			addContent(_localBtn);
			_localBtn.enabled = false;
			_localFull = new MCacheAsset3Btn(3,LanguageManager.getWord("ssztl.scene.curPlaceRelive"));
			_localFull.move(28,108);
			addContent(_localFull);
			
			_timer = new Timer(1000,60);
			_timer.addEventListener(TimerEvent.TIMER,timerHandler);
//			_timer.addEventListener(TimerEvent.TIMER_COMPLETE,timerCompleteHandler);
			_timer.start();
			
			_hanguping = false;
			
			initEvent();
						
			checkHangup();
		}
		
		public function setSpecial():void
		{
			_localBtn.enabled = _localFull.enabled = false;
//			if(_timer) _timer.removeEventListener(TimerEvent.TIMER_COMPLETE,timerCompleteHandler);
		}
		
		private function initEvent():void
		{
			_countryBtn.addEventListener(MouseEvent.CLICK,countryClickHandler);
			_localBtn.addEventListener(MouseEvent.CLICK,localClickHandler);
			_localFull.addEventListener(MouseEvent.CLICK,localFullClickHandler);
			_mediator.sceneModule.sceneInfo.playerList.self.state.addEventListener(PlayerStateUpdateEvent.STATE_CHANGE,playerStateUpdateHandler);
			_mediator.sceneModule.sceneInfo.playerList.self.addEventListener(BaseSceneObjInfoUpdateEvent.SCENEREMOVE,selfSceneRemoveHandler);
			GlobalAPI.keyboardApi.getKeyListener().addEventListener(KeyboardEvent.KEY_UP,keyUpHandler1,false,2);
		}
		
		private function removeEvent():void
		{
			_countryBtn.removeEventListener(MouseEvent.CLICK,countryClickHandler);
			_localBtn.removeEventListener(MouseEvent.CLICK,localClickHandler);
			_localFull.removeEventListener(MouseEvent.CLICK,localFullClickHandler);
			if(_mediator.sceneModule.sceneInfo.playerList.self)
			{
				_mediator.sceneModule.sceneInfo.playerList.self.state.removeEventListener(PlayerStateUpdateEvent.STATE_CHANGE,playerStateUpdateHandler);
				_mediator.sceneModule.sceneInfo.playerList.self.removeEventListener(BaseSceneObjInfoUpdateEvent.SCENEREMOVE,selfSceneRemoveHandler);
			}
			GlobalAPI.keyboardApi.getKeyListener().removeEventListener(KeyboardEvent.KEY_UP,keyUpHandler1);
		}
		
		private function keyUpHandler1(evt:KeyboardEvent):void
		{
			evt.stopImmediatePropagation();
		}
		
		private function selfSceneRemoveHandler(evt:BaseSceneObjInfoUpdateEvent):void
		{
			if(_mediator.sceneModule.sceneInfo.playerList.self)
			{
				_mediator.sceneModule.sceneInfo.playerList.self.state.removeEventListener(PlayerStateUpdateEvent.STATE_CHANGE,playerStateUpdateHandler);
				_mediator.sceneModule.sceneInfo.playerList.self.removeEventListener(BaseSceneObjInfoUpdateEvent.SCENEREMOVE,selfSceneRemoveHandler);
			}
		}
		
		private function checkHangup():void
		{
			//挂机中
			if(_mediator.sceneInfo.playerList.self.getIsHangup())
			{
				if(_mediator.sceneInfo.hangupData.autoRelive && GlobalData.selfPlayer.getVipType() == VipType.BESTVIP)
				{
					doYuanBaoRelive();
					_hanguping = true;
				}
			}
		}
		
		private function doYuanBaoRelive():void
		{
//			if(getTimer() - _sendTime < 1000)return;
			if(GlobalData.bagInfo.getItemById(CategoryType.RELIVE_DRUG).length > 0)
			{
//				_hadSend = true;
				_mediator.relive(3);
				_sendTime = getTimer();
				dispose();
			}
			else if(GlobalData.selfPlayer.userMoney.yuanBao >= 10)
			{
//				if(_hadSend)return;
//				_hadSend = true;
				_mediator.relive(3);
				_sendTime = getTimer();
				dispose();
			}
			else
			{
				QuickTips.show(LanguageManager.getWord("ssztl.common.yuanBaoNotEnough2"));
			}
		}
		
		private function countryClickHandler(evt:MouseEvent):void
		{
//			if(_hadSend)return;
//			if(getTimer() - _sendTime < 1000)return;
//			if(GlobalData.copyEnterCountList.isInCopy || MapTemplateList.isAcrossBossMap())
//			{
				MAlert.show(LanguageManager.getWord("ssztl.scene.outCopyRelive"),LanguageManager.getWord("ssztl.common.alertTitle"),MAlert.OK|MAlert.CANCEL,null,alertCloseHandler);
//			}else
//			{
//				doCountryRelive()
//			}
			function alertCloseHandler(evt:CloseEvent):void
			{
				if(evt.detail == MAlert.OK)
				{
					doCountryRelive()
				}
			}
			function doCountryRelive():void
			{
//				_hadSend = true;
				_mediator.relive(1);
				_sendTime = getTimer();
				dispose();
			}	
		}
		
		private function localClickHandler(evt:MouseEvent):void
		{
//			if(_hadSend)return;
//			_hadSend = true;
			if(getTimer() - _sendTime < 1000)return;
			_mediator.relive(2);
			_sendTime = getTimer();
			dispose();
		}
		private function localFullClickHandler(evt:MouseEvent):void
		{
			doYuanBaoRelive();
		}
		
		private function timerHandler(evt:TimerEvent):void
		{
			var n:int = 60 - _timer.currentCount;			
			_countryBtn.setLabel(LanguageManager.getWord("ssztl.scene.birthTownRelive4",n));
			if(n - 50 > 0)
				_localBtn.setLabel(LanguageManager.getWord("ssztl.scene.curPlaceReliveLeftTime",n - 50));
			else
			{
				_localBtn.setLabel(LanguageManager.getWord("ssztl.scene.curPlaceRelive2"));
				_localBtn.enabled = true;
			}
			if(n <= 0)
			{
				_mediator.relive(1);
				_sendTime = getTimer();
				dispose();
				true;
			}
		}
//		private function timerCompleteHandler(evt:TimerEvent):void
//		{
//			_localBtn.enabled = true;
//		}
		
		override public function doEscHandler():void{}
		
		private function playerStateUpdateHandler(e:PlayerStateUpdateEvent):void
		{
			if(!_mediator.sceneModule.sceneInfo.playerList.self.getIsDead())
			{
				if(_hanguping)
				{
					_mediator.sceneModule.sceneMediator.setHangup();
				}
				dispose();
			}
		}
		
		public function showAlert(nick:String):void
		{
			if(_reliveMalert)_reliveMalert.dispose();
			_reliveMalert = MAlert.show(nick + LanguageManager.getWord("ssztl.scene.sureRelive"),LanguageManager.getWord("ssztl.common.alertTitle"),MAlert.OK | MAlert.CANCEL,null,closeHandler);
		}
		
		private function closeHandler(e:CloseEvent):void
		{
			if(e.detail == MAlert.OK)
			{
				SkillReliveSocketHandler.send();
			}
		}
		
		override public function dispose():void
		{
			if(_bg)
			{
				_bg.dispose();
				_bg = null;
			}
			removeEvent();
			if(_timer)
			{
				_timer.removeEventListener(TimerEvent.TIMER,timerHandler);
//				_timer.removeEventListener(TimerEvent.TIMER_COMPLETE,timerCompleteHandler);
				_timer.stop();
				_timer = null;
			}
			if(_countryBtn)
			{
				_countryBtn.dispose();
				_countryBtn = null;
			}
			if(_localBtn)
			{
				_localBtn.dispose();
				_localBtn = null;
			}
			if(_localFull)
			{
				_localFull.dispose();
				_localFull = null;
			}
			if(_reliveMalert)
			{
				_reliveMalert.dispose();
				_reliveMalert = null;
			}
			super.dispose();
		}
	}
}