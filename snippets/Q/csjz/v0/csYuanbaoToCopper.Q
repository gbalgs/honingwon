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
MacroID=7900c1ed-6d19-48bf-9e43-4d03dca501bd
Description=yuanbaoToCopper
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
/****�û����á����������ӳٻ����������ӳ�Խ�ߣ����������õ�Խ��****/
UserVar BSRVD = 1000 "�����ӳٻ�����Ĭ��1000��"

/****CLIENT_DELAY �ͻ��˲����ӳ�****/
Const CLTD = 500

/****��ϷԪ�س�������Ϸ���°汾ʱ����****/
//====����ģ��====
//������������������
Const BAG_ROW_AMOUNT = 9
Const BAG_COL_AMOUNT = 6
//�������ӳߴ�
Const CELL_WIDTH = 48
Const CELL_HEIGHT = 48
//����ѡ��߶�
Const BAG_TAB_HEIGHT = 58

/****�������ô���****/
//���ӣ�
//If FromBagIndex > BagAmount Then 
//    MessageBox "��ʼ������Ų��ܴ��ڰ�������"
//    ExitScript
//End If

/****��������****/
//����ѭ��
Dim i, j, k

/**** APP ****/
Const MAIN_WIN_WIDTH = 900
Const MAIN_WIN_HEIGHT = 700

Dim MainHwnd,Hwnd
Dim SubHwnd, Sub2Hwnd, Sub3Hwnd, Sub4Hwnd
//��ȡIE�����ڣ���������ߴ�
MainHwnd = Plugin.Window.Find("IEFrame", 0)
Call Plugin.Window.Size(MainHwnd, MAIN_WIN_WIDTH, MAIN_WIN_HEIGHT)
Delay CLTD
//��ȡIE game���
SubHwnd = Plugin.Window.FindEx(MainHwnd, 0, "Frame Tab", 0)
Sub2Hwnd = Plugin.Window.FindEx(SubHwnd, 0, "TabWindowClass", 0)
Sub3Hwnd = Plugin.Window.FindEx(Sub2Hwnd, 0, "Shell DocObject View", 0)
Sub4Hwnd = Plugin.Window.FindEx(Sub3Hwnd, 0, "Internet Explorer_Server", 0)
Hwnd = Plugin.Window.FindEx(Sub4Hwnd, 0, "MacromediaFlashPlayerActiveX", 0)
TracePrint "��ȡIE game�ɹ������Ϊ��" & Hwnd
If Hwnd = 0 Then 
    ExitScript
End If