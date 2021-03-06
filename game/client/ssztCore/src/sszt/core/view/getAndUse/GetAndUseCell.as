package sszt.core.view.getAndUse
{
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import sszt.constData.LayerType;
	import sszt.core.data.item.ItemTemplateInfo;
	import sszt.core.view.cell.BaseCell;
	import sszt.core.view.tips.TipsUtil;
	import sszt.interfaces.character.ILayerInfo;
	
	public class GetAndUseCell extends BaseCell
	{
		public function GetAndUseCell(info:ILayerInfo=null, showLoading:Boolean=true, autoDisposeLoader:Boolean=true, fillBg:int=-1)
		{
			super(info, showLoading, autoDisposeLoader, fillBg);
		}
		
		override protected function showTipHandler(evt:MouseEvent):void
		{
			if(info)TipsUtil.getInstance().show(ItemTemplateInfo(info),null,new Rectangle(this.localToGlobal(new Point(_figureBound.x,_figureBound.y)).x,this.localToGlobal(new Point(_figureBound.x,_figureBound.y)).y,_figureBound.width,_figureBound.height));
		}
		
		override protected function initFigureBound():void
		{
			_figureBound = new Rectangle(3,3,44,44);
		}
		
		override protected function hideTipHandler(evt:MouseEvent):void
		{
			if(info)TipsUtil.getInstance().hide();
		}
		override protected function getLayerType():String
		{
			return LayerType.STORE_ICON; 
		}
	}
}