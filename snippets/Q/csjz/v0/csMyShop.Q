[General]
SyntaxVersion=2
BeginHotkey=121
BeginHotkeyMod=0
PauseHotkey=0
PauseHotkeyMod=0
StopHotkey=123
StopHotkeyMod=0
RunOnce=1
EnableWindow=
MacroID=503b9450-0d52-4053-a33a-eed2dbd486be
Description=csMyShop
Enable=0
AutoRun=0
[Repeat]
Type=0
Number=1
[SetupUI]
Type=2
QUI=
[Relative]
SetupOCXFile=
[Comment]

[Script]
//todo
//1��Ϊʲô���ڲ�����ǰ�ˣ��ڽű����й����У����ڻ����Զ�������ǰ�棿��chrome���𰸣�fuck chrome��IE9û���⡣
//2��û������ǰ̨����SayString �ĺ�̨�������𰸣��У�Plugin.Bkgnd.SendString(Hwnd, "abc")
//4��UserVar PRICE=0 "�����۸�" ���ѽ����

//3���Դ���Ϸ������̨���˫����������Ч������Ϸ������ԭ����
//5����֧���϶���chrome��
//6���Դ���Ϸ�����˫��֧�ֲ��á�chrome��

UserVar PRICE = 0 "��Ʒ�ϼܼ۸�"

Const MAIN_WIN_WIDTH = 900
Const MAIN_WIN_HEIGHT = 700

Const BAG_KEY = 66

Const MY_STORE_POS_X = 570
Const MY_STORE_POS_Y = 537

Const MY_STORE_CELL_MAX = 48

Const ITEM_POS_X = 515
Const ITEM_POS_Y = 131

Const ACCOUNT_FIELD_CLICK_POS_X = 446
Const ACCOUNT_FIELD_CLICK_POS_Y = 300

Const PRICE_FIELD_CLICK_POS_X = 446
Const PRICE_FIELD_CLICK_POS_Y = 328

Const CONFIRM_BUTTON_CLICK_POS_X = 371
Const CONFIRM_BUTTON_CLICK_POS_Y = 375

Const KEY_BACKSPACE = 8

//IE������
MainHwnd = Plugin.Window.Find("IEFrame", 0)
//�̶������ڴ�С����Ҫע����ǣ�IE�����ڽ���Ҫ����һ�£����ͳһ����IE�����޸���ͬ����ʾ���ã�ʹ����ͬ��OS����
Call Plugin.Window.Size(MainHwnd, MAIN_WIN_WIDTH, MAIN_WIN_HEIGHT)
Delay 1000
TracePrint "���ڴ�С�����á�"

//��ȡgame���
SubHwnd = Plugin.Window.FindEx(MainHwnd, 0, "Frame Tab", 0)
Sub2Hwnd = Plugin.Window.FindEx(SubHwnd, 0, "TabWindowClass", 0)
Sub3Hwnd = Plugin.Window.FindEx(Sub2Hwnd, 0, "Shell DocObject View", 0)
Sub4Hwnd = Plugin.Window.FindEx(Sub3Hwnd, 0, "Internet Explorer_Server", 0)
Hwnd = Plugin.Window.FindEx(Sub4Hwnd, 0, "MacromediaFlashPlayerActiveX", 0)
TracePrint "��ȡgame�ɹ������Ϊ��" & Hwnd
If Hwnd = 0 Then 
	ExitScript
End If


//open my bag
Call Plugin.Bkgnd.KeyPress(Hwnd, BAG_KEY)
Delay 1000

//open my store 
Call Plugin.Bkgnd.LeftClick(Hwnd, MY_STORE_POS_X, MY_STORE_POS_Y)
Delay 1000

Dim i
For i = 1 to MY_STORE_CELL_MAX
  Call SellItemFromPos(ITEM_POS_X, ITEM_POS_Y)
  TracePrint "��"&i&"����Ʒ���ϼ�"
Next

Sub SellItemFromPos(posX, posY)

	//move to the item and click it
	Call Plugin.Bkgnd.LeftClick(Hwnd, posX, posY)
	Delay 500
	// to sell
	Call Plugin.Bkgnd.LeftClick(Hwnd, posX + 66, posY)
	Delay 500
	
	//fill the account field
	Call Plugin.Bkgnd.LeftClick(Hwnd, ACCOUNT_FIELD_CLICK_POS_X, ACCOUNT_FIELD_CLICK_POS_Y)
	Delay 500
	//delete three char
 	Call PressKeyRepeatedly(Hwnd, KEY_BACKSPACE, 3, 200)	
	//enter account 1
	Call Plugin.Bkgnd.SendString(Hwnd, "1")
	Delay 500
	
	//fill the price field
	Call Plugin.Bkgnd.LeftClick(Hwnd, PRICE_FIELD_CLICK_POS_X, PRICE_FIELD_CLICK_POS_Y)
	Delay 500	
	//delete three char
 	Call PressKeyRepeatedly(Hwnd, KEY_BACKSPACE, 3, 200) 	
	//enter price
	Call Plugin.Bkgnd.SendString(Hwnd, PRICE)
	Delay 500
	
	//to confirm
	Call Plugin.Bkgnd.LeftClick(Hwnd, CONFIRM_BUTTON_CLICK_POS_X, CONFIRM_BUTTON_CLICK_POS_y)
End Sub

/*
* ָ���������ָ����ָ���Ĵ���
* @param hwnd
* @param key
* @param times
* @param interval
*/
Sub PressKeyRepeatedly(hwnd, key, times, interval)
	For times
		Call Plugin.Bkgnd.KeyPress(hwnd, key)
		Delay interval
	Next
End Sub


Sub TestRun()
	TracePrint "��ʼ�Զ��ܲ���"
	For 15
		Call Plugin.Bkgnd.LeftClick(Hwnd, 306, 400)
		TracePrint "one step"
		Delay 2000
	Next
End Sub