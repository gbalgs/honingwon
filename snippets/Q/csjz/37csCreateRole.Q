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
Description=37CreateRole
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

/****�û����á����������ӳٻ����������ӳ�Խ�ߣ����������õ�Խ��****/
UserVar BSRVD = 1000 "�����ӳٻ�����Ĭ��1000��"
/****CLIENT_DELAY �ͻ��˲����ӳ�****/
Const CLTD = 500

Const MAIN_WIN_WIDTH = 650
Const MAIN_WIN_HEIGHT = 710

Const LOGIN_CLICK_POS_X = 28
Const LOGIN_CLICK_POS_Y = 17

Const NAME_CLICK_POS_X = 281
Const NAME_CLICK_POS_Y = 536

Const BTN_CREATE_X = 278
Const BTN_CREATE_Y = 585

Const TAB_CLOSE_CLICK_POS_X = 381
Const TAB_CLOSE_CLICK_POS_Y = 27

Dim tmpSubHwnd

//�����ڲ��رգ��Ͳ���(chrome tab����LoginPageHwnd�Ͳ���)
Dim ChromeHwnd, LoginPageHwnd

//��tab�仯���仯
Dim ChromeGameHwnd

Dim i

//��ȡChrome������
ChromeHwnd = Plugin.Window.Find("Chrome_WidgetWin_1", "entrance - Google Chrome")
TracePrint "��ȡChrome�����ڳɹ������Ϊ��" & ChromeHwnd	

//��ȡ��¼ҳ�档�ɻ�ȡ����ʱ��¼ҳ��tab���뼤�
tmpSubHwnd = Plugin.Window.FindEx(ChromeHwnd, 0, "Chrome_WidgetWin_0", 0)
LoginPageHwnd = Plugin.Window.FindEx(tmpSubHwnd, 0, "Chrome_RenderWidgetHostHWND", 0)
TracePrint "��ȡ��¼ҳ��ɹ������Ϊ��" & LoginPageHwnd	

Call Plugin.Window.Size(ChromeHwnd, MAIN_WIN_WIDTH, MAIN_WIN_HEIGHT)
Delay CLTD * 2
Call Plugin.Window.Move(ChromeHwnd, 0, 0)
Delay CLTD * 2
TracePrint "Chrome���ڴ�С��λ�������á�"

Rem go

//�����¼����link���������ӳ�
Call Plugin.Bkgnd.LeftClick(LoginPageHwnd, LOGIN_CLICK_POS_X, LOGIN_CLICK_POS_Y)
//ҳ�����+��¼ajax+��ת�ӳ�
Delay BSRVD * 2
//��ɫģ������ӳ�
Delay BSRVD * 7	

//������Ϸ����,��ȡ����̬�仯�š�chrome��Ϸ������
Call getChromeGameHwnd()

//����������������
Call Plugin.Bkgnd.LeftClick(ChromeGameHwnd, NAME_CLICK_POS_X, NAME_CLICK_POS_Y)
Delay CLTD

Dim num, nick
//������������
Rem start
Randomize
//�õ� 1~999999999 ֮���һ�������
num = Int((999999999 * Rnd) + 1)
//�ж���������Ƿ�8λ���֣��������8λ���֣�����������
If num<100000000 Then
    Goto start
End If 
nick = "s" & num

Call Plugin.Bkgnd.SendString(Hwnd, nick)
Delay CLTD * 2

//����
Call Plugin.Bkgnd.LeftClick(ChromeGameHwnd, BTN_CREATE_X, BTN_CREATE_Y)
Delay BSRVD * 5

//�رյ�ǰtab
Call Plugin.Bkgnd.LeftClick(ChromeHwnd, TAB_CLOSE_CLICK_POS_X, TAB_CLOSE_CLICK_POS_Y)
Delay CLTD

Goto go

Sub getChromeGameHwnd()
	//��ȡChromeGameHwnd���
	tmpSubHwnd = Plugin.Window.FindEx(ChromeHwnd, 0, "Chrome_WidgetWin_0", 0)
	tmpSubHwnd = Plugin.Window.FindEx(tmpSubHwnd, 0, "Chrome_RenderWidgetHostHWND", 0)
	tmpSubHwnd = Plugin.Window.FindEx(tmpSubHwnd, 0, "WrapperNativeWindowClass", 0)
	ChromeGameHwnd = Plugin.Window.FindEx(tmpSubHwnd, 0, "NativeWindowClass", 0)
	TracePrint "��ȡChrome game�ɹ������Ϊ��" & ChromeGameHwnd	
End Sub