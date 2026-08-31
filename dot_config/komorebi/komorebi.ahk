#Requires AutoHotkey v2.0
#SingleInstance Force

; Start komorebi only if it's not already running. This makes the script
; safe whether you launch it directly, via YASB (which already starts
; komorebi), or via Windows startup.
if !ProcessExist("komorebi.exe") {
    RunWait("komorebic.exe start", , "Hide")
    Sleep(1000)
}

; Hide the Windows taskbar via `thide start`.
; thide is a CLI tool that executes its subcommand and exits, so no
; ProcessExist guard is needed (the process won't be running afterwards).
Sleep(1500)            ; brief pause so YASB/komorebi can settle first
Run('thide start', , "Hide")

Run("komorebic.exe mouse-follows-focus disable",, "Hide")


; =============================================================================
; 1. PATH SETUP
; =============================================================================
; If komorebi is in your PATH, just "komorebic.exe" is fine. 
; If not, replace this with the full path like: "C:\Users\YourName\AppData\Local\bin\komorebic.exe"
global komorebic_path := "komorebic.exe"

; This function ensures every command runs correctly and hidden
K(cmd) {
    try {
        Run(komorebic_path . " " . cmd, , "Hide")
    } catch Error as e {
        MsgBox("Failed to run komorebi command: " . cmd . "`n`nError: " . e.Message)
    }
}

; =============================================================================
; 2. FOCUS & MOVEMENT (Alt + Arrows)
; =============================================================================
!Left::K("focus left")
!Down::K("focus down")
!Up::K("focus up")
!Right::K("focus right")

; Move windows (Alt + Shift + Arrows)
!+Left::K("move left")
!+Down::K("move down")
!+Up::K("move up")
!+Right::K("move right")

; =============================================================================
; 3. STACKING / HIDING (The "Hide Behind" setup)
; =============================================================================
; Stack current window onto the one to the left (Alt + S)
^!Left::K("stack left")
^!Right::K("stack right")
^!Up::K("stack up")
^!Down::K("stack down")
; Cycle through windows hidden behind (Alt + [ and Alt + ])
![::K("cycle-stack previous")
!]::K("cycle-stack next")

; Pull window out of a stack (Alt + U)
!u::K("unstack")

; =============================================================================
; 4. Window Management
; =============================================================================
!f::K("toggle-float")
!o::K("toggle-monocle")
!m::K("minimize")
;!+m::K("restore-windows")
!w::K("toggle-workspace-layer")
!t::K("toggle-transparency")
!p::K("toggle-pause")           ; Alt+P  pause/unpause komorebi tiling on focused workspace


; =============================================================================
; 5. ULTRAWIDE & WORKSPACES
; =============================================================================
!Enter::K("promote-swap")     ; Promote to Center
#^!Left::K("promote-window left")
#^!Right::K("promote-window right") 
!=::K("resize-axis horizontal increase") 
!-::K("resize-axis horizontal decrease") 
!+=::K("resize-axis vertical increase") 
!+-::K("resize-axis vertical decrease") 


!1::K("focus-workspace 0")
!2::K("focus-workspace 1")
!3::K("focus-workspace 2")
!4::K("focus-workspace 3")

!+1::Run("komorebic.exe move-to-workspace 0", , "Hide")
!+2::Run("komorebic.exe move-to-workspace 1", , "Hide")
!+3::Run("komorebic.exe move-to-workspace 2", , "Hide")
!+4::Run("komorebic.exe move-to-workspace 3", , "Hide")

; =============================================================================
; 6. UTILITIES
; =============================================================================
!+r::K("reload-configuration")
!+q::K("close")
!+m::K("toggle-mouse-follows-focus")

; Cycle to the next layout style
!+.:: {
    static toggle := false
    toggle := !toggle
    
    if toggle {
        k("change-layout ultrawide-vertical-stack")
    } else {
        k("change-layout columns")
    }
}

; Ctrl + Alt + T to launch WezTerm
^!t:: {
    Run('"C:\Program Files\WezTerm\wezterm-gui.exe"')
}

; Ctrl+Alt+X: full teardown — stop komorebi, thide, yasb, then exit this AHK script.
^!x:: {
    try RunWait('komorebic.exe stop', , 'Hide')
    try RunWait('thide stop', , 'Hide')
    try RunWait('yasbc.exe stop', , 'Hide')
    ExitApp()
}