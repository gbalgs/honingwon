package sszt.rank.components.views.activity
{
	import fl.controls.ScrollPolicy;
	
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import sszt.core.data.GlobalData;
	import sszt.core.manager.LanguageManager;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.rank.components.itemView.pvp.PVPRankItemView;
	import sszt.rank.components.views.RankViewImpl;
	import sszt.rank.data.RankInfo;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.container.MTile;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.label.MBackgroundLabel;
	import sszt.ui.mcache.splits.MCacheSplit1Line;
	
	public class PVPRankView extends RankViewImpl
	{
		private var _bg:IMovieWrapper;
		private var _rankInfos:RankInfo;
		private var _itemInfoList:Array;
		
		private var _resultViewList:Array;
		private var _tile:MTile;	
		private var _curItemView:PVPRankItemView;
		
		private var _colWidth:Array = [51,130,60,114,110];
		
		public function PVPRankView(rankInfos:RankInfo)
		{
			_rankInfos = rankInfos;
			initView();
		}
		
		private function initView():void
		{
			var colX:Array = [];
			for(var i:int=0; i<_colWidth.length; i++)
			{
				colX.push(i>0?colX[i-1]+_colWidth[i]:_colWidth[0]+i*2);
			}
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(colX[0],1,2,20),new MCacheSplit1Line()),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(colX[1],1,2,20),new MCacheSplit1Line()),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(colX[2],1,2,20),new MCacheSplit1Line()),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(colX[3],1,2,20),new MCacheSplit1Line())
			]);
			addChild(_bg as DisplayObject);
			
			addChild(MBackgroundLabel.getDisplayObject(new Rectangle(0,3,  _colWidth[0],16),new MAssetLabel(LanguageManager.getWord("ssztl.scene.rank"),MAssetLabel.LABEL_TYPE_TITLE2)));
			addChild(MBackgroundLabel.getDisplayObject(new Rectangle(colX[0]+2,3,_colWidth[1],16),new MAssetLabel(LanguageManager.getWord("ssztl.common.role"),MAssetLabel.LABEL_TYPE_TITLE2)));
			addChild(MBackgroundLabel.getDisplayObject(new Rectangle(colX[1]+2,3,_colWidth[2],16),new MAssetLabel(LanguageManager.getWord("ssztl.common.carrer"),MAssetLabel.LABEL_TYPE_TITLE2)));
			addChild(MBackgroundLabel.getDisplayObject(new Rectangle(colX[2]+2,3,_colWidth[3],16),new MAssetLabel(LanguageManager.getWord("ssztl.common.clubName"),MAssetLabel.LABEL_TYPE_TITLE2)));
			addChild(MBackgroundLabel.getDisplayObject(new Rectangle(colX[3]+2,3,_colWidth[4],16),new MAssetLabel(LanguageManager.getWord("ssztl.common.pvpWinNub"),MAssetLabel.LABEL_TYPE_TITLE2)));
			
			_tile = new MTile(475,28,1);
			_tile.verticalScrollPolicy = ScrollPolicy.OFF;
			_tile.itemGapH = _tile.itemGapW = 0;
			_tile.move(0,23);
			_tile.setSize(475,280);
			addChild(_tile);
		}
		
		public function setData():void{
			if(_itemInfoList)
			{
				clear();
			}
			_itemInfoList = _rankInfos.getCurrRankInfo(1);
			_resultViewList = [];
			var i:int;
			var itemView:PVPRankItemView;
			var flag:Boolean;
			for(i = 0; i < _itemInfoList.length; i++)
			{
				itemView = new PVPRankItemView(_itemInfoList[i]);
				itemView.addEventListener(MouseEvent.CLICK,itemClickHandler);
				_resultViewList.push(itemView);
				_tile.appendItem(itemView);
				//如果当前页有玩家自己
				if(_itemInfoList[i].userId == GlobalData.selfPlayer.userId)
				{
					curItemChange(itemView);
					flag = true;
				}
			}
			//如果当前页没有玩家自己
			if(!flag)
			{
				curItemChange(_resultViewList[0]);
			}
		}
		
		private function clear():void
		{
			var itemView:PVPRankItemView;
			for each(itemView in _resultViewList)
			{
				itemView.removeEventListener(MouseEvent.CLICK,itemClickHandler);
			}
			_tile.disposeItems();
			_itemInfoList = null;
			_resultViewList = null;
		}
		
		private function itemClickHandler(evt:MouseEvent):void
		{
			curItemChange(evt.currentTarget as PVPRankItemView);
		}
		
		private function curItemChange(item:PVPRankItemView):void
		{
			item.select = true;
		}
		
		override public function hide():void
		{
			super.hide();
			_curItemView = null;
		}
		
		override public function dispose():void
		{
			removeEvents();
			if(_bg)
			{
				_bg.dispose();
				_bg = null;
			}
			
			if(_tile)
			{
				_tile.dispose();
				_tile = null;
			}
			
			if(_resultViewList)
			{
				for each(var itemView:PVPRankItemView in _resultViewList)
				{
					itemView.dispose();
					itemView = null;
				}
				_resultViewList = null;
			}
			super.dispose();
			_rankInfos = null;
			_curItemView = null;
		}
	}
}