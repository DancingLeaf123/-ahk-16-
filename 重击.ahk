#Persistent ; 确保脚本在后台持续运行 (Ensures the script keeps running in the background)
#SingleInstance force ; 确保脚本只有一个实例在运行 (Ensures only one instance of the script runs)

; --- 配置区域 (Configuration Area) ---
HoldDuration := 135      ; 鼠标左键按住的持续时间 (毫秒)
                         ; (Mouse left button hold duration (milliseconds). Adjust for Wanderer's charged attack timing.)
MinPauseAfterRelease := 1 ; 随机生成的“松开后停顿时间”的最小值 (毫秒)
                         ; (Minimum value for the randomized "pause after release" (milliseconds))
MaxPauseAfterRelease := 5 ; 随机生成的“松开后停顿时间”的最大值 (毫秒)
                         ; (Maximum value for the randomized "pause after release" (milliseconds))
TimerInterval := 1      ; 脚本检查是否执行下一次点击的频率 (毫秒)。
                         ; 实际的攻击间隔大约是 HoldDuration + 随机的PauseAfterRelease。
                         ; (How often (milliseconds) the script checks to perform the next action.
                         ; Actual attack cycle time is approximately HoldDuration + randomized PauseAfterRelease.)

; --- 全局变量 (Global Variables) ---
Global Toggle := false   ; 用于切换宏的开关状态，初始为关闭 (Macro toggle state (true = ON, false = OFF), initially off.)

; --- 热键定义 (Hotkey Definition) ---
; 使用 ` (重音符/反引号键) 来切换宏的开关状态。
; (Use the ` (Grave Accent) key to toggle the macro ON or OFF.)
; $`:: ; Grave Accent key (`)
$t:: ; 't' key
    Toggle := !Toggle ; 按下 ` 键时，切换Toggle变量的布尔值 (true变为false, false变为true)
                      ; (When the ` key is pressed, toggle the boolean value of the Toggle variable.)

    If Toggle
    {
        ToolTip, Charged Attack Macro: ON
        ; 启动定时器，周期性调用 PerformChargedAttack 子程序
        ; (Start the timer to periodically call PerformChargedAttack)
        SetTimer, PerformChargedAttack, %TimerInterval%
    }
    Else
    {
        ToolTip, Charged Attack Macro: OFF
        SetTimer, PerformChargedAttack, Off ; 关闭定时器 (Stop the timer)
    }
    ; 1秒后移除提示信息 (Remove tooltip after 1 second)
    SetTimer, RemoveToolTip, -1000
Return

; --- 执行重击的子程序 (Perform Charged Attack Subroutine) ---
PerformChargedAttack:
    If (!Toggle) ; 如果宏状态为关闭 (Toggle为false)，则直接返回，不执行任何操作
                 ; (If the macro state is off (Toggle is false), do nothing.)
        Return

    ; (可选) 检查当前活动窗口是否为原神，以避免在其他程序中误触发
    ; 您需要将 "Genshin Impact" 或 "原神" 替换为游戏窗口的精确标题 (通常显示在窗口左上角)
    ; 如果需要此功能，请取消下面 IfWinActive 行和对应大括号的注释
    ; (Optional: Check if Genshin Impact is the active window to avoid misfires in other programs.)
    ; (You'll need to replace "Genshin Impact" or "原神" with the exact window title of your game.)
    ; (Uncomment the IfWinActive line and its corresponding braces if you want to use this feature.)

    ; IfWinActive, 原神 ; 例如 "Genshin Impact" 或 "原神" (e.g., "Genshin Impact" or "原神")
    ; {
        MouseClick, Left, , , 1, 0, D  ; 按下鼠标左键不松开 (D = Down)
                                      ; (Press and hold left mouse button (D = Down))
        Sleep, %HoldDuration%          ; 按住指定时间 (Hold for the specified duration)

        MouseClick, Left, , , 1, 0, U  ; 松开鼠标左键 (U = Up)
                                      ; (Release left mouse button (U = Up))
        
        ; 生成一个在 MinPauseAfterRelease 和 MaxPauseAfterRelease之间的随机数作为本次的停顿时间
        ; (Generate a random number between MinPauseAfterRelease and MaxPauseAfterRelease for this pause)
        Random, CurrentPauseAfterRelease, %MinPauseAfterRelease%, %MaxPauseAfterRelease%
        Sleep, %CurrentPauseAfterRelease% ; 松开后停顿随机生成的时间 (Pause for the randomly generated duration after release)
    ; }
    ; Else
    ; {
    ;    ; 如果不希望在非游戏窗口执行，当Toggle为ON但窗口不匹配时，定时器依然会运行，
    ;    ; 但不会执行点击。如果你希望在这种情况下也关闭定时器，逻辑会更复杂一些。
    ;    ; (If the game window is not active and Toggle is ON, the timer will still run,
    ;    ; but no clicks will be performed. If you want to stop the timer in this case,
    ;    ; the logic would need to be more complex, potentially by checking IfWinActive in the hotkey section too.)
    ; }
Return

; --- 移除提示信息的子程序 (Subroutine to remove tooltip) ---
RemoveToolTip:
    ToolTip
Return

; (可选) 添加一个退出脚本的热键，例如按 Ctrl + Esc 退出，方便测试
; (Optional: Add a hotkey to exit the script, e.g., press Ctrl + Esc for easy testing or closing.)
; ^Esc:: ; Ctrl + Esc
;    ExitApp
; Return
