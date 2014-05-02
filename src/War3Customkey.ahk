;���óq���ϰ�ϥ� (Tray Icon)

#NoTrayIcon



;���楻�{���ɡA���X�������� (GUI) �A�Y�����������h���}���{���C

Gui, 2:Font, Norm, Georgia
Gui, Add, Text,, [ = �}�Ҥͤ����q�������
Gui, Add, Text,, ] = �}�ҼĤ����q�������
Gui, Add, Text,, Ctrl + Q = �פ��q�������
Gui, Add, Text,,
Gui, Add, Checkbox, Checked vMyVar7, Tab = ��1�檫�~�檺����
Gui, Add, Checkbox, Checked vMyVar8, Caps Lock = ��2�檫�~�檺����
Gui, Add, Checkbox, Checked vMyVar4, Left Win-key = ��3�檫�~�檺����
Gui, Add, Text,,
Gui, Add, Text,, Ctrl + F11 = �I���۰ʳs�u��Battle.Net
Gui, Add, Text,, F12 = ����۰ʳs�u
Gui, Add, Text,,
Gui, Add, Button, default, �ܧ�ֳt��]�w
Gui, Add, Text, x+50 yp+10 cBlue gLabel_Webpage vURL_Link1, @�i�RҲ
Gui, Show

; ######## Hyperlink Underlink GUI Code #####################################
  ; Retrieve scripts PID
  Process, Exist
  pid_this := ErrorLevel

  ; Retrieve unique ID number (HWND/handle)
  WinGet, hw_gui, ID, ahk_class AutoHotkeyGUI ahk_pid %pid_this%

  ; Call "HandleMessage" when script receives WM_SETCURSOR message
  WM_SETCURSOR = 0x20
  OnMessage(WM_SETCURSOR, "HandleMessage")

  ; Call "HandleMessage" when script receives WM_MOUSEMOVE message
  WM_MOUSEMOVE = 0x200
  OnMessage(WM_MOUSEMOVE, "HandleMessage")
; ######## End Of Hyperlink Underlink GUI Code ##############################

Return

GuiClose:
ExitApp



Label_Webpage:
  Run http://changyuheng.github.io/
Return



; Ctrl + F11 �۰ʳs�u�� Battle.Net �A F12 �פ�
;����Warcraft III�����O�_�b�̤W�h�A�Y�ϱN��̤p�ơA�]���ġC

DetectHiddenWindows, On
^F11::
Loop
{
ControlSend ,,{B}{Space}, Warcraft III
GetKeyState, state, F12, P
If state = D
    break
Sleep, 100
}
Return



;�H�U�Ҧ����O�ҥu�b Warcraft III �����b�̤W�h�ɧ@��

#IfWinActive ahk_class Warcraft III



;�w����U���~��ֳt�䰵�n Mapping �C
;���Ĥ@�B�G�B�T�Ӫ��~�檺���䬰 Tab �B Caps Lock�BLeft Windows Logo Key
;�� CapsLock::Send {Numpad8} �Ӥ��� CapsLock::Numpad8 �O����]���G
;�p�G�����N Caps Lock layout �� Num 4�A�h Caps Lock ��|�������h�\��A
;���ɱN�S������������� Caps ���O���C
;�ӡu�N Caps Lock �w�q���e�X Num 8 �T��������v�A�h�i�H�ϱo Caps Lock ��b
;�����զX����ɤ��O������� Caps �O�����\��C��ҡG��W���U Caps Lock �N�e�X
;Num 7 ���T���A�B���|���� Caps ���O���C�ӫ��U Alt + Caps Lock �ɡA�h�i�H�F
;����� Caps �O�����\��C

Tab::Send {Numpad7}
Hotkey, Tab, Toggle, Off
CapsLock::Send {Numpad8}
Hotkey, Capslock, Toggle, Off
Lwin::Send {Numpad4}
Hotkey, Lwin, Toggle, Off
Return



;���\��i�O����`�n
;���@�U [ �ΦP������� [ ����A���@�U ] �ΦP������� ] ����A Ctrl + Q �פ�C

;blood <= 0 �פ�
SetEnv, blood, 1
Return
^q::
SetEnv, blood, -1
Send {[ Up}{] Up}
Return

If (blood > 0)
{
    ~[ Up::Send {Blind}{[ Down}
    ~] Up::Send {Blind}{] Down}
}
Else
{
    SetEnv, blood, 1
}
Return



;����U�u�ܧ�ֳt��]�w�v���s��A���� If �P�_���C
;If �P�_���ΥH����U����ƥ��M�w�n�� mapping �O�_�B�@�C

Button�ܧ�ֳt��]�w:

Gui, Submit, NoHide

If MyVar7 = 1
{
  Hotkey, Tab, Toggle, On
}
Else
{
  Hotkey, Tab, Toggle, Off
}

If MyVar8 = 1
{
  Hotkey, Capslock, Toggle, On
}
Else
{
  Hotkey, Capslock, Toggle, Off
}

If MyVar4 = 1
{
  Hotkey, Lwin, Toggle, On
}
Else
{
  Hotkey, Lwin, Toggle, Off
}
Return



;����U�u����Ҧ��\��������v���s��A�������{��

Button����Ҧ��\�������:
ExitApp



; ######## Hyperlink Underlink Function #####################################
HandleMessage(p_w, p_l, p_m, p_hw)
  {
    global   WM_SETCURSOR, WM_MOUSEMOVE,
    static   URL_hover, h_cursor_hand, h_old_cursor, CtrlIsURL, LastCtrl

    If (p_m = WM_SETCURSOR)
      {
        If URL_hover
          Return, true
      }
    Else If (p_m = WM_MOUSEMOVE)
      {
        ; Mouse cursor hovers URL text control
        StringLeft, CtrlIsURL, A_GuiControl, 3
        If (CtrlIsURL = "URL")
          {
            If URL_hover=
              {
                Gui, Font, cBlue underline
                GuiControl, Font, %A_GuiControl%
                LastCtrl = %A_GuiControl%

                h_cursor_hand := DllCall("LoadCursor", "uint", 0, "uint", 32649)

                URL_hover := true
              }
              h_old_cursor := DllCall("SetCursor", "uint", h_cursor_hand)
          }
        ; Mouse cursor doesn't hover URL text control
        Else
          {
            If URL_hover
              {
                Gui, Font, norm cBlue
                GuiControl, Font, %LastCtrl%

                DllCall("SetCursor", "uint", h_old_cursor)

                URL_hover=
              }
          }
      }
  }
; ######## End Of Hyperlink Underlink Function ##############################
