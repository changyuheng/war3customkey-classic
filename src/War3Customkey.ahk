;隱藏通知區域圖示 (Tray Icon)

#NoTrayIcon



;執行本程式時，跳出說明視窗 (GUI) ，若關閉此視窗則離開本程式。

Gui, 2:Font, Norm, Georgia
Gui, Add, Text,, [ = 開啟友方單位血量持續顯示
Gui, Add, Text,, ] = 開啟敵方單位血量持續顯示
Gui, Add, Text,, Ctrl + Q = 終止血量持續顯示
Gui, Add, Text,,
Gui, Add, Checkbox, Checked vMyVar7, Tab = 第1格物品欄的熱鍵
Gui, Add, Checkbox, Checked vMyVar8, Caps Lock = 第2格物品欄的熱鍵
Gui, Add, Checkbox, Checked vMyVar4, Left Win-key = 第3格物品欄的熱鍵
Gui, Add, Text,,
Gui, Add, Text,, Ctrl + F11 = 背景自動連線到Battle.Net
Gui, Add, Text,, F12 = 停止自動連線
Gui, Add, Text,,
Gui, Add, Button, default, 變更快速鍵設定
Gui, Add, Text, x+50 yp+10 cBlue gLabel_Webpage vURL_Link1, @張昱珩
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



; Ctrl + F11 自動連線到 Battle.Net ， F12 終止
;不論Warcraft III視窗是否在最上層，即使將其最小化，也有效。

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



;以下所有指令皆只在 Warcraft III 視窗在最上層時作用

#IfWinActive ahk_class Warcraft III



;預先把各物品欄快速鍵做好 Mapping 。
;更改第一、二、三個物品欄的熱鍵為 Tab 、 Caps Lock、Left Windows Logo Key
;用 CapsLock::Send {Numpad8} 而不用 CapsLock::Numpad8 是有原因的：
;如果直接將 Caps Lock layout 成 Num 4，則 Caps Lock 鍵會完全失去功能，
;此時將沒有任何按鍵能切換 Caps 的燈號。
;而「將 Caps Lock 定義成送出 Num 8 訊號的熱鍵」，則可以使得 Caps Lock 鍵在
;按有組合按鍵時仍保有其切換 Caps 燈號的功能。實例：單獨按下 Caps Lock 將送出
;Num 7 的訊號，且不會切換 Caps 的燈號。而按下 Alt + Caps Lock 時，則可以達
;到切換 Caps 燈號的功能。

Tab::Send {Numpad7}
Hotkey, Tab, Toggle, Off
CapsLock::Send {Numpad8}
Hotkey, Capslock, Toggle, Off
Lwin::Send {Numpad4}
Hotkey, Lwin, Toggle, Off
Return



;此功能可令血條常駐
;按一下 [ 形同持續按著 [ 不放，按一下 ] 形同持續按著 ] 不放， Ctrl + Q 終止。

;blood <= 0 終止
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



;當按下「變更快速鍵設定」按鈕後，執行 If 判斷式。
;If 判斷式用以控制各按鍵事先決定好的 mapping 是否運作。

Button變更快速鍵設定:

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



;當按下「停止所有功能並關閉」按鈕後，關閉本程式

Button停止所有功能並關閉:
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
