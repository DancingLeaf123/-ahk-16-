#Persistent ; 确保脚本在后台持续运行
#SingleInstance force ; 确保脚本只有一个实例在运行

; --- 配置区域 (Configuration Area) ---
HoldDuration := 135      ; 鼠标左键按住的持续时间 (毫秒)
MinPauseAfterRelease := 1 ; 随机生成的“松开后停顿时间”的最小值 (毫秒)
MaxPauseAfterRelease := 5 ; 随机生成的“松开后停顿时间”的最大值 (毫秒)
TimerInterval := 1      ; 脚本检查是否执行下一次点击的频率 (毫秒)。

; --- 全局变量 (Global Variables) ---
Global Toggle := false   ; 用于切换宏的开关状态，初始为关闭

; --- 上下文相关热键定义 (Context-Sensitive Hotkey Definition) ---
; 下面的热键 $t:: 仅在 YuanShen.exe 进程的窗口为活动窗口时生效
#IfWinActive ahk_exe YuanShen.exe
$t:: ; 't' key
    Toggle := !Toggle ; 切换宏的开关状态

    If Toggle ; 如果宏被开启
    {
        ToolTip, Macro ON (YuanShen.exe Active)
        SetTimer, RemoveToolTip, -1500          ; 1.5秒后移除此提示
        SetTimer, PerformChargedAttack, %TimerInterval% ; 启动攻击循环的定时器
    }
    Else ; 如果宏被关闭
    {
        ToolTip, Macro OFF (YuanShen.exe Active)
        SetTimer, RemoveToolTip, -1500           ; 1.5秒后移除此提示
        SetTimer, PerformChargedAttack, Off ; 关闭攻击循环的定时器
    }
Return
#IfWinActive ; 重置上下文，使后续的热键 (如果有的话) 或脚本行为恢复全局性

; --- 执行重击的子程序 (Perform Charged Attack Subroutine) ---
PerformChargedAttack:
    If (!Toggle) ; 如果宏已关闭 (Toggle为false)，则不执行任何操作
        Return

    ; 再次检查以确保仅当 YuanShen.exe 进程的窗口是活动窗口时，才执行鼠标点击
    ; 这是一个双重保险，因为热键本身已经有了上下文限制。
    IfWinActive, ahk_exe YuanShen.exe
    {
        MouseClick, Left, , , 1, 0, D  ; 按下鼠标左键不松开
        Sleep, %HoldDuration%          ; 按住指定时间

        MouseClick, Left, , , 1, 0, U  ; 松开鼠标左键
        
        Random, CurrentPauseAfterRelease, %MinPauseAfterRelease%, %MaxPauseAfterRelease%
        Sleep, %CurrentPauseAfterRelease% ; 松开后停顿随机生成的时间
    }
Return

; --- 移除提示信息的子程序 (Subroutine to remove tooltip) ---
RemoveToolTip:
    ToolTip ; 清除当前的 ToolTip
Return

; (可选) 添加一个退出脚本的热键，例如按 Ctrl + Esc 退出
; ^Esc::
;    ExitApp
; Return
