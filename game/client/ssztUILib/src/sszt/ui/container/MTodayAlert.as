package sszt.ui.container
{
	import fl.controls.CheckBox;
	import fl.core.InvalidationType;
	import fl.core.UIComponent;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.ui.Keyboard;
	
	import sszt.ui.UIManager;
	import sszt.ui.event.CloseEvent;
	import sszt.ui.mcache.btns.MCacheAssetBtn1;
	import sszt.ui.mcache.titles.MCacheTitle1;
	import sszt.ui.styles.TextFormatType;
	import sszt.ui.styles.TextGlowFilterType;
	
	import ssztui.ui.WinTitleHintAsset;
	
	public class MTodayAlert extends MPanel3
	{
		public static const YES:uint = 0x0001;
		public static const NO:uint = 0x0002;
		public static const OK:uint = 0x0004;
		public static const CANCEL:int = 0x0008;
		public static const AGREE:int = 0x0010;
		public static const REFUSE:int = 0x0020;
		public static const CHECK:int = 0x0040;
		
		public static var YES_LABEL:String = "是";
		public static var NO_LABEL:String = "否";
		public static var OK_LABEL:String = "确定";
		public static var CANCEL_LABEL:String = "取消";
		public static var AGREE_LABEL:String = "同意";
		public static var REFUSE_LABEL:String = "拒绝";
		public static var CHECK_LABEL:String = "查看";
		
		private static const DEFAULT_STYLE:Object = {upSkin:AlertSkinAsset,titleUpSkin:null};
		
		protected var _buttons:Array;
		protected var _okBtn:DisplayObject;
		protected var _cancelBtn:DisplayObject;
		protected var _yesBtn:DisplayObject;
		protected var _noBtn:DisplayObject;
		protected var _agreeBtn:DisplayObject;
		protected var _refuseBtn:DisplayObject;
		protected var _checkBtn:DisplayObject;
		
		private var _titleText:String;
		private var _titleTxt:TextField;
		private var _contentTxt:TextField;
		private var _button_space:int = 6;      //按钮间的距离
		private var _flags:uint;
		private var _message:String;
		private var _textAlign:String;
		private var _setWidth:Number;
		private var _hadSetBtn:Boolean;
		private var _applyStyle:Boolean;
		private var _checkBox:CheckBox;
		
		public static var buttonWidth:int = 60;
		public static var buttonHeight:int = 32;
//		public static var okLabel:int = 1;
//		public static var cancelLabel:int = 2;
//		public static var yesLabel:int = 1;
//		public static var noLabel:int = 2;
//		public static var agreeLabel:int = 1;
//		public static var refuseLabel:int = 2;
		
		private static const MAX_TEXTWIDTH:int = 370;
		private static const MIN_TEXTWIDTH:int = 240;
		private static const MAX_BUTTONWIDTH:int = 100;
		public static var _chbflagArr:Array = [];
		private static var priority:int = 1;
		private static var _mtype:int = 0;
		private static var _closeHandler:Function;
		
		public function MTodayAlert(type:int,message:String = "",title:String = "",flags:uint = 4,parent:DisplayObjectContainer = null,closeHandler:Function = null,textAlign:String = "center",width:Number = -1,closeAble:Boolean = true,appStyle:Boolean = true)
		{
			_closeHandler = closeHandler;
			_titleText = title;
			_message = message;
			_applyStyle = appStyle;
			_flags = flags;
			_textAlign = textAlign;
			_setWidth = width;
			_titleTxt = new TextField();
			_titleTxt.mouseEnabled = _titleTxt.mouseWheelEnabled = false;
			super(new MCacheTitle1("",new Bitmap(new WinTitleHintAsset())),true,-1,closeAble);
			_paddingTop = 25;
			initEvent();
		}
		/**
		 * 
		 * @param type 1:宠物喂养 2:一小时加速 3:技能书刷新
		 * 
		 */		
		public static function show(type:int,message:String = "",title:String = "",flags:uint = 4,parent:DisplayObjectContainer = null,closeHandler:Function = null,textAlign:String = "center",width:Number = -1,closeAble:Boolean = true,applyStyle:Boolean = true):void
		{
			
			_mtype = type;
			if(_chbflagArr[type]==1)
			{
				_closeHandler = closeHandler;
				doCallBack(OK);
			}
			else
			{
				priority++;
				var alert:MTodayAlert = new MTodayAlert(type,message,title,flags,parent,closeHandler,textAlign,width,closeAble,applyStyle);
				if(parent)parent.addChild(alert);
				else UIManager.PARENT.addChild(alert);
				alert.listenKey();
				//				return alert;
			}
		
		}
		
		override protected function configUI():void
		{
			super.configUI();
			
			setCenter();
			
			_contentTxt = new TextField();
			_contentTxt.wordWrap = true;
			_contentTxt.mouseEnabled = _contentTxt.mouseWheelEnabled = false;
			var format:TextFormat = new TextFormat("SimSun",12,0xffffff);
			_contentTxt.setTextFormat(format);
			_contentTxt.defaultTextFormat = format;
			addContent(_contentTxt);
			
			_checkBox = new CheckBox();
			_checkBox.move(20,80);
			_checkBox.buttonMode = true;
			_checkBox.useHandCursor = true;
			_checkBox.label = "本次登录不再提示";
			_checkBox.width = 180;
			addContent(_checkBox);
			_checkBox.setStyle("textFormat",new TextFormat("SimSun",12,0xFF9900));
			
			_buttons = createButtons(_flags);
		}
		
		override protected function drawLayout():void
		{
			if(_titleText == null) return;
			_titleTxt.text = _titleText;
			_titleTxt.filters = [TextGlowFilterType.FILTER1];
			_titleTxt.setTextFormat(TextFormatType.FORMAT2);
			
			_contentTxt.htmlText = _message;
			if(_applyStyle)
			{
				var contentTxtFormat:TextFormat = TextFormatType.cloneFormat1();
				contentTxtFormat.align = _textAlign;
				_contentTxt.setTextFormat(contentTxtFormat);
			}
			if(_setWidth > MAX_TEXTWIDTH)
			{
				_contentTxt.width = _setWidth;
			}
			else
			{
				_contentTxt.width = Math.min(_contentTxt.textWidth,MAX_TEXTWIDTH);
				_contentTxt.width = Math.max(_contentTxt.width,(buttonWidth * 2 + _button_space),MIN_TEXTWIDTH);
			}
			_contentTxt.height = _contentTxt.textHeight + _paddingTop + 14;
			
			var bgWidth:Number = _paddingWidth*2 + _contentTxt.width + 40;
			var bgHeight:Number = _contentTxt.height + 50; //_paddingTop + _paddingBottom + _contentTxt.height + buttonHeight + _titleHeight + 20;
			setContentSize(bgWidth,bgHeight);
			
			var count:int = _buttons.length;
			var buttonsWidth:int = buttonWidth * count + (count-1) * _button_space;
			if((buttonsWidth + _paddingWidth * 2) > bgWidth)
			{
				bgWidth = buttonsWidth + _paddingWidth * 2 + 30;
				_contentTxt.width = buttonsWidth;
				setContentSize(bgWidth,bgHeight);
			}
			_titleTxt.width = _titleTxt.textWidth + 20;
			_titleTxt.height = 22;
//			_titleTxt.x = (bgWidth - _titleTxt.width) / 2 + 10;
//			_titleTxt.y = _paddingTop;
			_contentTxt.x = _paddingWidth + 20;
			_contentTxt.y = _paddingTop;
			var btnX:int = (bgWidth + _paddingWidth - buttonsWidth)/2;
			for each(var b:DisplayObject in _buttons)
			{
				b.x = btnX;
				btnX += buttonWidth + _button_space;
				b.y = _contentTxt.y + _contentTxt.height + 11;
				addContent(b);
			}
			_checkBox.move(25,_contentTxt.y + _contentTxt.height-16);
			super.drawLayout();
		}
		
		protected function initEvent():void
		{
			for each(var b:DisplayObject in _buttons)
			{
				b.addEventListener(MouseEvent.CLICK,btnClickHandler);
			}
			_checkBox.addEventListener(MouseEvent.CLICK,selectCheckHandler)
		}
		
		private function selectCheckHandler(evt:MouseEvent):void
		{
			if(evt.currentTarget as TextField)
				_checkBox.selected = !_checkBox.selected;
			_chbflagArr[_mtype] = 1;
		}
		public function listenKey():void
		{
			if(stage){}
			else if(UIManager.PARENT == null)
			{
				throw new Error("Parent null");
			}
			else if(UIManager.PARENT.stage == null)
			{
				throw new Error("stage null");
			}
			if(UIManager.PARENT && UIManager.PARENT.stage)
				UIManager.PARENT.stage.addEventListener(KeyboardEvent.KEY_UP,keyUp1Handler,false,priority);
		}
		
		protected function removeEvent():void
		{
			for each(var b:DisplayObject in _buttons)
			{
				b.removeEventListener(MouseEvent.CLICK,btnClickHandler);
				b = null;
			}
			UIManager.PARENT.stage.removeEventListener(KeyboardEvent.KEY_UP,keyUp1Handler);
			_checkBox.removeEventListener(MouseEvent.CLICK,selectCheckHandler)
		}
		
		private function btnClickHandler(e:MouseEvent):void
		{
			var flag:uint;
			switch(e.currentTarget)
			{
				case _okBtn:
					flag = OK;
					break;
				case _yesBtn:
					flag = YES;
					break;
				case _cancelBtn:
					flag = CANCEL;
					break;
				case _noBtn:
					flag = NO;
					break;
				case _agreeBtn:
					flag = AGREE;
					break;
				case _refuseBtn:
					flag = REFUSE;
					break;
				case _checkBtn:
					flag = CHECK;
					break;
			}
			doCallBack(flag);
			if(flag == CHECK) return;
			dispose();
		}
		
		private function keyUp1Handler(evt:KeyboardEvent):void
		{
			evt.stopImmediatePropagation();
			if(evt.keyCode == Keyboard.ENTER)
			{
				doEnterHandler();
			}
			else if(evt.keyCode == Keyboard.ESCAPE)
			{
				doEscHandler();
			}
		}
		
		override public function doEnterHandler():void
		{
			var flag:uint = 10000;
			if(_okBtn)flag = OK;
			else if(_yesBtn)flag = YES;
			else if(_agreeBtn)flag = AGREE;
			if(flag != 10000)
			{
				doCallBack(flag);
			}
			dispose();
		}
		
		override public function doEscHandler():void
		{
			var flag:uint = 10000;
			if(_cancelBtn)flag = CANCEL;
			else if(_noBtn)flag = NO;
			else if(_refuseBtn)flag = REFUSE;
			if(flag != 10000)
			{
				doCallBack(flag);
			}
			dispose();
		}
		
		public static function doCallBack(flag:uint):void
		{
			if(_closeHandler != null)
			{
				_closeHandler(new CloseEvent(CloseEvent.CLOSE,false,false,flag));
			}
		}
		
		public function setMessage(message:String):void
		{
			if(_contentTxt == null) return;
			_message = message;
			invalidate(InvalidationType.SIZE);
		}
		
		private function createButtons(flag:int):Array
		{
			var btns:Array = [];
			if(flag & OK)
			{
				if(!_okBtn)
					_okBtn = createBtn(OK);
				btns.push(_okBtn);
			}
			if(flag & YES)
			{
				if(!_yesBtn)
					_yesBtn = createBtn(YES);
				btns.push(_yesBtn);
			}
			if(flag & CANCEL)
			{
				if(!_cancelBtn)
					_cancelBtn = createBtn(CANCEL);
				btns.push(_cancelBtn);
			}
			if(flag & NO)
			{
				if(!_noBtn)
					_noBtn = createBtn(NO);
				btns.push(_noBtn);
			}
			if(flag & AGREE)
			{
				if(!_agreeBtn)
					_agreeBtn = createBtn(AGREE);
				btns.push(_agreeBtn);
			}
			if(flag & REFUSE)
			{
				if(!_refuseBtn)
					_refuseBtn = createBtn(REFUSE);
				btns.push(_refuseBtn);
			}
			if(flag & CHECK)
			{
				if(!_checkBtn)
					_checkBtn = createBtn(CHECK);
				btns.push(_checkBtn);
			}
			return btns;
		}
		
		override protected function closeClickHandler(evt:MouseEvent):void
		{
			doEscHandler();
		}
		
		private function createBtn(type:int):DisplayObject
		{
			var la:String = "";
			switch(type)
			{
				case OK:
					la = OK_LABEL;
					break;
				case CANCEL:
					la = CANCEL_LABEL;
					break;
				case YES:
					la = YES_LABEL;
					break;
				case NO:
					la = NO_LABEL;
					break;
				case AGREE:
					la = AGREE_LABEL;
					break;
				case REFUSE:
					la = REFUSE_LABEL;
					break;
				case CHECK:
					la = CHECK_LABEL;
					break;
			}
			var btn:MCacheAssetBtn1 = new MCacheAssetBtn1(0,2,la);
			return btn;
		}

		
		override protected function innerEscHandler():void
		{
			var flag:uint = 10000;
			if(_cancelBtn)flag = CANCEL;
			else if(_noBtn)flag = NO;
			else if(_refuseBtn)flag = REFUSE;
			if(flag != 10000)
			{
				doCallBack(flag);
			}
			super.innerEscHandler();
		}
		
		override public function dispose():void
		{
			validate();
			removeEvent();
			_contentTxt = null;
			_buttons = null;
			_closeHandler = null;			
			super.dispose();
			_checkBox = null;
		}
		
		public static function getStyleDefinition():Object
		{
			return mergeStyles(DEFAULT_STYLE,UIComponent.getStyleDefinition());
		}
	}
}