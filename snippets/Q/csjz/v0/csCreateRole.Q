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
MacroID=ae4c6bec-b566-4965-9ada-c632003f1898
Description=csCreateRole
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
//�˳���¼����������, ѭ����¼�������Խ�������⣬�������ʺ��б����������ʺ�

/****�û����á����������ӳٻ����������ӳ�Խ�ߣ����������õ�Խ��****/
UserVar BSRVD = 1000 "�����ӳٻ�����Ĭ��1000��"
/****CLIENT_DELAY �ͻ��˲����ӳ�****/
Const CLTD = 500

Const MAIN_WIN_WIDTH = 650
Const MAIN_WIN_HEIGHT = 710

Const LOGOUT_CLICK_POS_X = 94
Const LOGOUT_CLICK_POS_Y = 18

Const LOGIN_CLICK_POS_X = 28
Const LOGIN_CLICK_POS_Y = 17

Const CHROME_GAME_TAB_CLICK_POS_X = 285
Const CHROME_GAME_TAB_CLICK_POS_Y = 31

Const LOGIN_FORM_SUBMIT_CLICK_POS_X = 64
Const LOGIN_FORM_SUBMIT_CLICK_POS_Y = 34

Const LOGIN_FORM_INPUT_X = 138
Const LOGIN_FORM_INPUT_Y = 8

Const NAME_CLICK_POS_X = 281
Const NAME_CLICK_POS_Y = 535

Const BTN_CREATE_X = 276
Const BTN_CREATE_Y = 585

Const TAB_CLOSE_CLICK_POS_X = 381
Const TAB_CLOSE_CLICK_POS_Y = 27

//�����ڲ��رգ��Ͳ���(chrome tab����LoginPageHwnd�Ͳ���)
Dim ChromeHwnd, LoginPageHwnd
Dim LSubHwnd

//��tab�仯���仯
Dim ChromeGameHwnd,LoginFormPageHwnd
Dim CGSubHwnd, LFSubHwnd

Dim LoginAlertHwnd,GameAlertHwnd

Dim i

//��ȡChrome������
ChromeHwnd = Plugin.Window.Find("Chrome_WidgetWin_1", "entrance - Google Chrome")
TracePrint "��ȡChrome�����ڳɹ������Ϊ��" & ChromeHwnd	

//��ȡ��¼ҳ�档�ɻ�ȡ����ʱ��¼ҳ��tab���뼤�
LSubHwnd = Plugin.Window.FindEx(ChromeHwnd, 0, "Chrome_WidgetWin_0", 0)
LoginPageHwnd = Plugin.Window.FindEx(LSubHwnd, 0, "Chrome_RenderWidgetHostHWND", 0)
TracePrint "��ȡ��¼ҳ��ɹ������Ϊ��" & LoginPageHwnd	

Call Plugin.Window.Size(ChromeHwnd, MAIN_WIN_WIDTH, MAIN_WIN_HEIGHT)
Delay CLTD * 2
Call Plugin.Window.Move(ChromeHwnd, 0, 0)
Delay CLTD * 2
TracePrint "Chrome���ڴ�С��λ�������á�"

Rem go

//�˳���¼���������ӳ�
Call Plugin.Bkgnd.LeftClick(LoginPageHwnd, LOGOUT_CLICK_POS_X, LOGOUT_CLICK_POS_Y)
Delay CLTD
Call Plugin.Bkgnd.LeftClick(LoginPageHwnd, LOGOUT_CLICK_POS_X, LOGOUT_CLICK_POS_Y)
Delay CLTD
Delay BSRVD * 2
TracePrint "���˳���¼"

//�����¼����link���������ӳ٣�fuck����Ȼ�ں�̨�򿪵�¼����tabҳ��
Call Plugin.Bkgnd.LeftClick(LoginPageHwnd, LOGIN_CLICK_POS_X, LOGIN_CLICK_POS_Y)
Delay BSRVD * 2
//ȷ���л�������¼����tabҳ
Call Plugin.Bkgnd.LeftClick(ChromeHwnd, CHROME_GAME_TAB_CLICK_POS_X, CHROME_GAME_TAB_CLICK_POS_Y)
Delay CLTD
TracePrint "ȷ���л�������¼����tabҳ"

//��ȡ����̬�仯�š��ĵ�¼����ҳ
Call getLoginFormPageHwnd()

//Dim GetColor
//���û�ʺ����˳��ű�
//GetColor = Plugin.Bkgnd.GetPixelColor(LoginFormPageHwnd, 540, 5)
//If GetColor = 000000 Then 
//	TracePrint "has no acc left"
//	EndScript
//End If

//������������
Call Plugin.Bkgnd.LeftClick(LoginFormPageHwnd, LOGIN_FORM_INPUT_X, LOGIN_FORM_INPUT_Y)
Delay CLTD

//LoginFormPageHwnd�ͻ������Ͻ��������
Dim offsetX,offsetY
Dim Rec,MyArray
Rec = Plugin.Window.GetClientRect(LoginFormPageHwnd)	
//����������ڷָ��ַ���,���������������ֳ������ַ���
MyArray = Split(Rec, "|")
//������佫�ַ���ת������ֵ
offsetX = Clng(MyArray(0)) : offsetY = Clng(MyArray(1))

MoveTo LOGIN_FORM_INPUT_X + offsetX, LOGIN_FORM_INPUT_Y + offsetY
LeftDoubleClick 1

//ctrl+c
KeyDown "Ctrl", 1
Delay CLTD
KeyPress "C", 1
Delay CLTD
KeyUp "Ctrl", 1
Delay CLTD

//�����¼��ť��¼���������ӳ٣�
Call Plugin.Bkgnd.LeftClick(LoginFormPageHwnd, LOGIN_FORM_SUBMIT_CLICK_POS_X, LOGIN_FORM_SUBMIT_CLICK_POS_X)
Delay BSRVD

Call getLoginAlertHwnd()
//���������������������군�ˣ����ü��±���¼�ʺţ��ٰ��ʺ��б���һ���ʺ�ɾ��
//����������ʲôԭ��
If (LoginAlertHwnd > 0) Then 
	Call Plugin.Bkgnd.KeyPress(LoginAlertHwnd, 13)
	Delay CLTD
	Call RunApp("notepad++")
	Delay CLTD * 2
	Dim NotepadHwnd,NotepadEditHwnd
	NotepadHwnd = Plugin.Window.Find("Notepad++", 0)
	TracePrint "NotepadHwnd"&NotepadHwnd
	NotepadEditHwnd = Plugin.Window.FindEx(NotepadHwnd, 0, "Scintilla", 0)
	TracePrint "NotepadEditHwnd"&NotepadEditHwnd
	Call Plugin.Bkgnd.LeftClick(NotepadEditHwnd, 152, 9)
	Delay CLTD
	Call PressKeyRepeatedly(NotepadEditHwnd, 8, 10, 200)
	Call PressKeyRepeatedly(NotepadEditHwnd, 46, 1, 200)
	Call Plugin.Window.Active(NotepadHwnd)
	Delay CLTD
	KeyDown "Ctrl", 1
	Delay CLTD
	KeyPress "S", 1
	Delay CLTD
	KeyUp "Ctrl", 1
	Delay CLTD
	KeyDown "Alt", 1
	Delay CLTD
	KeyPress "F4", 1
	Delay CLTD
	KeyUp "Alt", 1
	Delay CLTD	
Else 

	TracePrint "�ȴ�ҳ����ת"
	//�ȴ�ҳ����ת
	Delay CLTD * 2
	
	TracePrint "��Ϸ��Դ����ʱ��ܳ����������ӳ� BSRVD * 10"
	//��Ϸ��Դ����ʱ��ܳ����������ӳ�
	Delay BSRVD * 10
	
	Call getGameAlertHwnd()
	
	//������֡���ӹ�����¼��Ϸ������
	If (GameAlertHwnd > 0) Then 
		Call Plugin.Bkgnd.KeyPress(GameAlertHwnd, 13)
		Delay CLTD
	Else
		//������Ϸ����,��ȡ����̬�仯�š�chrome��Ϸ������
		Call getChromeGameHwnd()
		
		//����������������
		Call Plugin.Bkgnd.LeftClick(ChromeGameHwnd, NAME_CLICK_POS_X, NAME_CLICK_POS_Y)
		Delay CLTD
		
		//ctrl+v
		KeyDown "Ctrl", 1
		Delay CLTD
		KeyPress "V", 1
		Delay CLTD
		KeyUp "Ctrl", 1
		Delay CLTD
		
		//����
		Call Plugin.Bkgnd.LeftClick(ChromeGameHwnd, BTN_CREATE_X, BTN_CREATE_Y)
		Delay BSRVD * 2
	End If
End If

//�رյ�ǰtab
Call Plugin.Bkgnd.LeftClick(ChromeHwnd, TAB_CLOSE_CLICK_POS_X, TAB_CLOSE_CLICK_POS_Y)
Delay CLTD

Goto go

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

Sub getChromeGameHwnd()
	//��ȡChromeGameHwnd���
	CGSubHwnd = Plugin.Window.FindEx(ChromeHwnd, 0, "Chrome_WidgetWin_0", 0)
	CGSubHwnd = Plugin.Window.FindEx(CGSubHwnd, 0, "Chrome_RenderWidgetHostHWND", 0)
	CGSubHwnd = Plugin.Window.FindEx(CGSubHwnd, 0, "WrapperNativeWindowClass", 0)
	ChromeGameHwnd = Plugin.Window.FindEx(CGSubHwnd, 0, "NativeWindowClass", 0)
	TracePrint "��ȡChrome game�ɹ������Ϊ��" & ChromeGameHwnd	
End Sub

Sub getLoginFormPageHwnd()
	//��ȡ��¼����ҳ
	LFSubHwnd = Plugin.Window.FindEx(ChromeHwnd, 0, "Chrome_WidgetWin_0", 0)
	LoginFormPageHwnd = Plugin.Window.FindEx(LFSubHwnd, 0, "Chrome_RenderWidgetHostHWND", 0)
	TracePrint "��ȡ��¼����ҳ�ɹ������Ϊ��" & LoginFormPageHwnd	
End Sub

Sub getLoginAlertHwnd()
	//��ȡ��¼����
	LoginAlertHwnd = Plugin.Window.Find("Chrome_WidgetWin_1", "login.qule.com �ϵ���ҳ��ʾ��")
	TracePrint "��ȡ��¼����ɹ������Ϊ��" & LoginAlertHwnd	
End Sub

Sub getGameAlertHwnd()
	//��ȡ��¼��������Ϸ����
	GameAlertHwnd = Plugin.Window.Find("Chrome_WidgetWin_1", "9.qule.com �ϵ���ҳ��ʾ��")
	TracePrint "��ȡ��¼����Ϸ����ɹ������Ϊ��" & GameAlertHwnd	
End Sub