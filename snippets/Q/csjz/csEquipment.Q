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
MacroID=b15cc405-d70d-45e3-862b-8537033a3951
Description=csEquipment
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
//�������ֽ�
//����:
//a ͬһʱ��ֻ�ܽ��е�һ�������������߷ֽ⣩
//b �����ý�ɫӵ�а���������
//c �����ô�ָ��������λ�ÿ�ʼ������Ĭ�ϴӵ�һ��������1��1�п�ʼ��
//d �����������ӳ�
//todo
//a �����÷ֽ�ѡ�ȫ���ֽ⣬���ֽ⼫Ʒ����Ʒ�Ķ���ͼ��)��
//b ����ģʽ�����ã��������ֽ⡢���������Ϸֽ⣩
//c �ű�����ǰ����Ҫ�㿪�����塣˼·���Ȼس̡��ٴ򿪵�ͼ�ҵ�npc���������ͣ����ҵ�NPC���󣬵����
//d �����ý�Ҫ�����İ�����������Ĭ�ϴ��������һ������

UserVar BSRVD = 1000 "�����ӳٻ�����Ĭ��1000��"

UserVar BagAmount = 4 "��ɫӵ�а�����������Ĭ��4����"
UserVar Fun = DropList{"������":"identify"|"���ֽ�":"resolve"} = 0 "��ѡ���ܣ�Ĭ��ѡ�������"
UserVar FromBagIndex = 1 "�ӵڼ���������ʼ������Ĭ��Ϊ1��"
UserVar FromRowIndex = 1 "�ӵڼ��п�ʼ������Ĭ��Ϊ1��"
UserVar FromColIndex = 1 "�ӵڼ��п�ʼ������Ĭ��Ϊ1��"

Const FUN_LIST_VAL_IDENTIFY = "identify"
Const FUN_LIST_VAL_RESOLVE = "resolve"

//CLIENT_DELAY
Const CLTD = 500

Const BAG_COL_AMOUNT = 6
Const BAG_ROW_AMOUNT = 9

Const CELL_WIDTH = 48
Const CELL_HEIGHT = 48

Const BAG_TAB_HEIGHT = 58

Const MAIN_WIN_WIDTH = 900
Const MAIN_WIN_HEIGHT = 700

Const IDENTIFY_UI_ENTRANCE_X = 448
Const IDENTIFY_UI_ENTRANCE_Y = 421

Const RESOLVE_UI_ENTRANCE_X = 450
Const RESOLVE_UI_ENTRANCE_Y = 461

Const IDENTIFY_EX_X = 152
Const IDENTIFY_EX_Y = 533

Const BAG_FIRST_CELL_X = 515
Const BAG_FIRST_CELL_Y = 111

Const BTN_IDENTIFY_X = 289
Const BTN_IDENTIFY_Y = 530

Const BTN_RESOLVE_X = 291 
Const BTN_RESOLVE_Y = 529

Const FIRST_BAG_X = 812
Const FIRST_BAG_Y = 131

//�������ô���
If FromBagIndex > BagAmount Then 
    MessageBox "��ʼ������Ų��ܴ��ڰ�������"
    ExitScript
End If

If FromRowIndex > BAG_ROW_AMOUNT Then 
    MessageBox "��ʼ����Ų��ܴ���������"
    ExitScript
End If

If FromColIndex > BAG_COL_AMOUNT Then 
    MessageBox "��ʼ����Ų��ܴ���������"
    ExitScript
End If

Dim i, j, k

Dim tmpCellPosX, tmpCellPosY
Dim tmpBagTabPosX,tmpBagTabPosY


//IE������
MainHwnd = Plugin.Window.Find("IEFrame", 0)
Call Plugin.Window.Size(MainHwnd, MAIN_WIN_WIDTH, MAIN_WIN_HEIGHT)
Delay CLTD
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

If Fun = FUN_LIST_VAL_IDENTIFY Then	
    Call Identify()	
Else 
    Call Resolve()
End If

Sub Identify()
    TracePrint FUN_LIST_VAL_IDENTIFY
	
    Call Plugin.Bkgnd.LeftClick(Hwnd, IDENTIFY_UI_ENTRANCE_X, IDENTIFY_UI_ENTRANCE_Y)
    TracePrint "open identify tab"
    Delay CLTD * 4
	
    Call Plugin.Bkgnd.LeftClick(Hwnd, IDENTIFY_EX_X, IDENTIFY_EX_Y)
    TracePrint "select use YuanBao"
    Delay CLTD	
	
    For k = FromBagIndex To BagAmount
        //���ѡ���k������
        Call getBagPosByIndex(k)
        Call Plugin.Bkgnd.LeftClick(Hwnd, tmpBagTabPosX, tmpBagTabPosY)
        Delay CLTD
		
        For i = FromRowIndex To BAG_ROW_AMOUNT
        	If i = BAG_ROW_AMOUNT Then 
        		FromRowIndex = 1
        	End If
            For j = FromColIndex To BAG_COL_AMOUNT
                If j = BAG_COL_AMOUNT Then 
                    FromColIndex = 1
                End If
                Call getCellPos(i, j)
                Call IdentifyEquipFromCellPos(tmpCellPosX, tmpCellPosY)
            Next	
        Next
    Next	
End Sub

Sub Resolve()
    TracePrint FUN_LIST_VAL_RESOLVE
	
    Call Plugin.Bkgnd.LeftClick(Hwnd, RESOLVE_UI_ENTRANCE_X, RESOLVE_UI_ENTRANCE_Y)
    TracePrint "open resolve tab"
    Delay CLTD * 4
	
    For k = FromBagIndex To BagAmount
        //���ѡ���k������
        Call getBagPosByIndex(k)
        Call Plugin.Bkgnd.LeftClick(Hwnd, tmpBagTabPosX, tmpBagTabPosY)
        Delay CLTD
        For i = FromRowIndex To BAG_ROW_AMOUNT
        	If i = BAG_ROW_AMOUNT Then 
        		FromRowIndex = 1
        	End If
            For j = FromColIndex To BAG_COL_AMOUNT
                If j = BAG_COL_AMOUNT Then 
                    FromColIndex = 1
                End If
                Call getCellPos(i, j)
                Call ResolveEquipFromCellPos(tmpCellPosX, tmpCellPosY)
            Next	
        Next		
    Next	
End Sub

Sub ResolveEquipFromCellPos(posX, posY)
    Call Plugin.Bkgnd.LeftClick(Hwnd, posX, posY)
    Delay 20
    Call Plugin.Bkgnd.LeftClick(Hwnd, posX, posY)
    Delay 20
    Call Plugin.Bkgnd.LeftClick(Hwnd, posX, posY)
    Delay 20
    Call Plugin.Bkgnd.LeftClick(Hwnd, posX, posY)
    Delay 20
    TracePrint "select an equipment"
    Delay CLTD
    Call Plugin.Bkgnd.LeftClick(Hwnd, BTN_RESOLVE_X, BTN_RESOLVE_Y)
    TracePrint "click btn to resolve"
    Delay CLTD * 4
    Delay BSRVD * 3
	
End Sub

Sub IdentifyEquipFromCellPos(posX, posY)
    Call Plugin.Bkgnd.LeftClick(Hwnd, posX, posY)
    Delay 20
    Call Plugin.Bkgnd.LeftClick(Hwnd, posX, posY)
    Delay 20
    Call Plugin.Bkgnd.LeftClick(Hwnd, posX, posY)
    Delay 20
    Call Plugin.Bkgnd.LeftClick(Hwnd, posX, posY)
    Delay 20
    TracePrint "select an equipment"
    Delay CLTD
    Call Plugin.Bkgnd.LeftClick(Hwnd, BTN_IDENTIFY_X, BTN_IDENTIFY_Y)
    TracePrint "click btn to identify"
    Delay CLTD * 4
    Delay BSRVD * 3
    Call Plugin.Bkgnd.LeftClick(Hwnd, BTN_IDENTIFY_X, BTN_IDENTIFY_Y)
    TracePrint "get the equipment"
    Delay BSRVD * 3	
	
End Sub

Sub getCellPos(row, col)
    Dim offsetX, offsetY
    offsetX = CELL_WIDTH * (col - 1)
    offsetY = CELL_HEIGHT * (row - 1)	
    tmpCellPosX = BAG_FIRST_CELL_X + offsetX
    tmpCellPosY = BAG_FIRST_CELL_Y + offsetY
    TracePrint "cell " & row & "," & col & " pos:" & tmpCellPosX & ", "& tmpCellPosY
End Sub

Sub getBagPosByIndex(index)
    Dim offsetX, offsetY
    offsetX = 0
    offsetY = BAG_TAB_HEIGHT * (index - 1)
    tmpBagTabPosX = FIRST_BAG_X + offsetX
    tmpBagTabPosY = FIRST_BAG_Y + offsetY
    TracePrint "bagTab " & index & " pos:" & tmpBagTabPosX & ", "& tmpBagTabPosY
End Sub