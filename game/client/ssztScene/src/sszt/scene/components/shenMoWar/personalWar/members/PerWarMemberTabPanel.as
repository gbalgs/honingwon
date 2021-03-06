package sszt.scene.components.shenMoWar.personalWar.members
{
	import fl.controls.ScrollPolicy;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.container.MAlert;
	import sszt.ui.container.MTile;
	import sszt.ui.event.CloseEvent;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.mcache.btns.MCacheAsset1Btn;
	import sszt.ui.mcache.splits.MCacheSplit2Line;
	import sszt.ui.mcache.splits.MCacheSplit3Line;
	import sszt.ui.mcache.splits.MCacheSplit4Line;
	
	import sszt.core.data.GlobalData;
	import sszt.core.data.map.MapTemplateList;
	import sszt.core.manager.LanguageManager;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.scene.data.personalWar.menber.PerWarMembersItemInfo;
	import sszt.scene.data.shenMoWar.mainInfo.honoerInfo.ShenMoWarSceneItemInfo;
	import sszt.scene.data.shenMoWar.menbersInfo.ShenMoWarMembersItemInfo;
	import sszt.scene.data.shenMoWar.menbersInfo.ShenMoWarMenbersInfo;
	import sszt.scene.events.ScenePerWarUpdateEvent;
	import sszt.scene.events.SceneShenMoWarUpdateEvent;
	import sszt.scene.mediators.SceneWarMediator;
	import sszt.scene.socketHandlers.shenMoWar.ShenMoWarLeaveSocketHandler;
	import sszt.scene.socketHandlers.shenMoWar.ShenMoWarMemberListUpdateSocketHandler;
	
	public class PerWarMemberTabPanel extends Sprite implements IPerWarRewardsInterface
	{
		private var _bg:IMovieWrapper;
		private var _mediator:SceneWarMediator;
		private var _mTile:MTile;
		private var _itemList:Array;
		private var _warPeopleNumLabel:MAssetLabel;
		private var _selfItem:PerWarMemberItemView;
		
		private var _myWarBtn:MCacheAsset1Btn;
		private var _leaveBtn:MCacheAsset1Btn;
		
		public function PerWarMemberTabPanel(argMediator:SceneWarMediator)
		{
			super();
			_mediator = argMediator;
			initialView();
			//初始化数据层
			_mediator.perWarInfo.initPerWarMembersInfo();
			initialEvents();
			//向服务器请求数据
			if(MapTemplateList.isPerWarMap())
			{
				initialList(null);
			}
			else
			{
				_mediator.sendPerWarMemberList();
			}
		}
		
		private function initialView():void
		{
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.BORDER_6,new Rectangle(0,0,625,356)),
				new BackgroundInfo(BackgroundType.BAR_1,new Rectangle(3,4,619,22)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(46,6,11,17),new MCacheSplit3Line()),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(165,6,11,17),new MCacheSplit3Line()),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(211,6,11,17),new MCacheSplit3Line()),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(253,6,11,17),new MCacheSplit3Line()),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(373,6,11,17),new MCacheSplit3Line()),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(419,6,11,17),new MCacheSplit3Line()),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(500,6,11,17),new MCacheSplit3Line()),
				
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(3,56,595,2),new MCacheSplit2Line()),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(3,88,595,2),new MCacheSplit2Line()),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(3,120,595,2),new MCacheSplit2Line()),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(3,152,595,2),new MCacheSplit2Line()),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(3,184,595,2),new MCacheSplit2Line()),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(3,216,595,2),new MCacheSplit2Line()),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(3,248,595,2),new MCacheSplit2Line()),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(3,280,595,2),new MCacheSplit2Line()),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(3,312,595,2),new MCacheSplit2Line()),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(3,344,595,2),new MCacheSplit2Line()),
			]);
			addChild(_bg as DisplayObject);
			
			
			var label1:MAssetLabel = new MAssetLabel(LanguageManager.getWord("ssztl.scene.rank"),MAssetLabel.LABELTYPE14);
			label1.move(17,6);
			addChild(label1);
			var label2:MAssetLabel = new MAssetLabel(LanguageManager.getWord("ssztl.common.playerName"),MAssetLabel.LABELTYPE14);
			label2.move(90,6);
			addChild(label2);
			var label3:MAssetLabel = new MAssetLabel(LanguageManager.getWord("ssztl.scene.influence"),MAssetLabel.LABELTYPE14);
			label3.move(184,6);
			addChild(label3);
			var label4:MAssetLabel = new MAssetLabel(LanguageManager.getWord("ssztl.common.level2"),MAssetLabel.LABELTYPE14);
			label4.move(225,6);
			addChild(label4);
			var label5:MAssetLabel = new MAssetLabel(LanguageManager.getWord("ssztl.common.club2"),MAssetLabel.LABELTYPE14);
			label5.move(304,6);
			addChild(label5);
			var label6:MAssetLabel = new MAssetLabel(LanguageManager.getWord("ssztl.common.carrer3"),MAssetLabel.LABELTYPE14);
			label6.move(387,6);
			addChild(label6);
			var label7:MAssetLabel = new MAssetLabel(LanguageManager.getWord("ssztl.scene.score"),MAssetLabel.LABELTYPE14);
//			var label7:MAssetLabel = new MAssetLabel(LanguageManager.getWord("ssztl.scene.killCount"),MAssetLabel.LABELTYPE14);
			label7.move(439,6);
			addChild(label7);
			var label8:MAssetLabel = new MAssetLabel(LanguageManager.getWord("ssztl.common.operation"),MAssetLabel.LABELTYPE14);
			label8.move(540,6);
			addChild(label8);
			
			var label9:MAssetLabel = new MAssetLabel(LanguageManager.getWord("ssztl.scene.warPlayerNum"),MAssetLabel.LABELTYPE14);
			label9.move(10,369);
			addChild(label9);
			
			_warPeopleNumLabel = new MAssetLabel("",MAssetLabel.LABELTYPE1);
			_warPeopleNumLabel.move(90,369);
			addChild(_warPeopleNumLabel);
			
			_itemList = [];
			_mTile = new MTile(620,32);
			_mTile.itemGapH = _mTile.itemGapW = 0;
			_mTile.verticalScrollPolicy = ScrollPolicy.ON;
			_mTile.horizontalScrollPolicy = ScrollPolicy.OFF;
			_mTile.verticalScrollBar.lineScrollSize = 32;
			_mTile.setSize(615,288);
			_mTile.move(6,30);
			addChild(_mTile);
			
			_myWarBtn = new MCacheAsset1Btn(2,LanguageManager.getWord("ssztl.scene.myWarReport"));
			_myWarBtn.move(194,365);
			addChild(_myWarBtn);
			
			_leaveBtn = new MCacheAsset1Btn(2,LanguageManager.getWord("ssztl.scene.leaveWar"));
			_leaveBtn.move(318,365);
			addChild(_leaveBtn);
			_leaveBtn.enabled = false;
			if(MapTemplateList.isPerWarMap())
			{
				_leaveBtn.enabled = true;
			}
		}
		
		public function show():void
		{
		}
		
		public function hide():void
		{
			if(parent)parent.removeChild(this);
		}
		
		private function initialEvents():void
		{
			if(!MapTemplateList.isPerWarMap())
			{
				_mediator.perWarInfo.perWarMembersInfo.addEventListener(ScenePerWarUpdateEvent.PERWAR_MENBERS_LIST_UPDATE,initialList);
			}
			_myWarBtn.addEventListener(MouseEvent.CLICK,btnClickHandler);
			_leaveBtn.addEventListener(MouseEvent.CLICK,btnClickHandler);
		}
		
		private function removeEvents():void
		{
			if(!MapTemplateList.isPerWarMap())
			{
				_mediator.perWarInfo.perWarMembersInfo.removeEventListener(ScenePerWarUpdateEvent.PERWAR_MENBERS_LIST_UPDATE,initialList);
			}
			_myWarBtn.removeEventListener(MouseEvent.CLICK,btnClickHandler);
			_leaveBtn.removeEventListener(MouseEvent.CLICK,btnClickHandler);
		}
		
		private function btnClickHandler(e:MouseEvent):void
		{
			switch(e.currentTarget)
			{
				case _myWarBtn:
					_mediator.showPerWarMyWarInfoPanel();
					break;
				case _leaveBtn:
					leaveBtnHandler();
					break;
			}
		}
		
		private function leaveBtnHandler():void
		{
			if(!_mediator.sceneInfo.playerList.self.getIsCommon())
			{
				QuickTips.show(LanguageManager.getWord("ssztl.common.inWarState"));
				return;
			}
			//			MAlert.show("退出战场需要7分钟后才能进入，是否退出？",LanguageManager.getWord("ssztl.common.alertTitle"),MAlert.OK|MAlert.CANCEL,null,closeHandler);
			MAlert.show(LanguageManager.getWord("ssztl.scene.isSureLeaveWarScene"),LanguageManager.getWord("ssztl.common.alertTitle"),MAlert.OK|MAlert.CANCEL,null,closeHandler);
			function closeHandler(e:CloseEvent):void
			{
				if(e.detail == MAlert.OK)
				{
					_mediator.sendPerWarLeave();
					_mediator.module.perWarRewardsPanel.dispose();
					
					GlobalData.selfPlayer.scenePath = null;
					GlobalData.selfPlayer.scenePathTarget = null;
					GlobalData.selfPlayer.scenePathCallback = null;
					if(_mediator && _mediator.module.sceneInit.playerListController.getSelf())_mediator.module.sceneInit.playerListController.getSelf().stopMoving();
				}
			}
		}
		
		
		private function initialList(e:ScenePerWarUpdateEvent):void
		{
			clearList();
			for each(var i:PerWarMembersItemInfo in _mediator.perWarInfo.perWarMembersInfo.membersItemList)
			{
				var tmpItemView:PerWarMemberItemView = new PerWarMemberItemView(_mediator);
				tmpItemView.info = i;
				_itemList.push(tmpItemView);
				_mTile.appendItem(tmpItemView);
				if(i.userId == GlobalData.selfPlayer.userId)
				{
					if(_selfItem == null)
					{
						_selfItem = new PerWarMemberItemView(_mediator);
						_selfItem.x = 6;
						_selfItem.y = 318;
						addChild(_selfItem);
					}
					_selfItem.info = i;
				}
			}
			updateLabel();
		}
		
		private function updateLabel():void
		{
			_warPeopleNumLabel.text = _mediator.perWarInfo.perWarMembersInfo.currentPepNum.toString() + "/" + _mediator.perWarInfo.perWarMembersInfo.allPepNum.toString();
		}
		
		private function getItemView(argUserId:Number):PerWarMemberItemView
		{
			for each(var i:PerWarMemberItemView in _itemList)
			{
				if(i && i.info && (i.info.userId ==argUserId))
				{
					return i;
				}
			}
			return null;
		}
		
		private function clearList():void
		{
			_itemList.length = 0;
			_mTile.disposeItems();
		}
		
		public function move(argX:int, argY:int):void
		{
			x = argX;
			y = argY;
		}
		
		public function dispose():void
		{
			removeEvents();
			if(!MapTemplateList.isPerWarMap())
			{
				_mediator.perWarInfo.perWarMembersInfo.membersItemList = null;
				_mediator.perWarInfo.clearPerWarMembersInfo();
			}
			if(_bg)
			{
				_bg.dispose();
				_bg = null;
			}
			_mediator = null;
			if(_mTile)
			{
				_mTile.dispose();
				_mTile = null;
			}
			if(_selfItem)
			{
				_selfItem.dispose();
				_selfItem = null;
			}
			for each(var i:PerWarMemberItemView in _itemList)
			{
				if(i)
				{
					i.dispose();
					i = null;
				}
			}
			_itemList= null;
			_warPeopleNumLabel = null;
			
			if(_myWarBtn)
			{
				_myWarBtn.dispose();
				_myWarBtn = null;
			}
			if(_leaveBtn)
			{
				_leaveBtn.dispose();
				_leaveBtn = null;
			}
		}
	}
}