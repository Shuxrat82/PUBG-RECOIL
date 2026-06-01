; ╔════════════════════════════════════════════════════════════════════════════════╗
; ║                     PUBG RECOIL CONTROL MACRO v5.0 PRO (OPTIMIZED)            ║
; ║                         AutoHotkey v2.0+                                      ║
; ║        ПРОФИЛИ ОРУЖИЙ | АВТО-ПРИЦЕЛ | NO RECOIL ALL WEAPONS                   ║
; ║      High Resolution Timer + Sub-pixel Accumulator + First Shot Kick          ║
; ╚════════════════════════════════════════════════════════════════════════════════╝

#Requires AutoHotkey v2.0
#SingleInstance Force
ListLines 0
KeyHistory 0
SetWinDelay 0
SetControlDelay 0
SetMouseDelay -1
SendMode "Input"
CoordMode "Mouse", "Screen"
try ProcessSetPriority "High"
A_MaxHotkeysPerInterval := 200

; Активация таймера высокого разрешения (1 мс)
DllCall("Winmm\timeBeginPeriod", "UInt", 1)
OnExit(ExitCleanup)
ExitCleanup(*) {
    try StopSpray()
    try ReleaseVirtualXButton2()
    DllCall("Winmm\timeEndPeriod", "UInt", 1)
}

; ════════════════════════════════════════════════════════════════════════════════
; ПРОВЕРКА ПРАВ
; ════════════════════════════════════════════════════════════════════════════════
if (!A_IsAdmin) {
    try {
        if (A_IsCompiled)
            Run "*RunAs `"" A_ScriptFullPath "`""
        else
            Run "*RunAs `"" A_AhkPath "`" `"" A_ScriptFullPath "`""
    } catch {
        MsgBox "Скрипт требует прав администратора!"
    }
    ExitApp
}

; ════════════════════════════════════════════════════════════════════════════════
; ПРОФИЛИ ОРУЖИЙ — ВСЕ ОРУЖИЯ PUBG
; ════════════════════════════════════════════════════════════════════════════════

global WeaponProfiles := [
    ; ── Автоматы (AR) ──
    {name: "M416",         scopes: [1.9, 2.8, 3.9, 4.5, 5.5]},
    {name: "ACE32",        scopes: [1.7, 2.7, 4.1, 4.8, 5.8]},
    {name: "AKM",          scopes: [2.0, 3.3, 4.8, 5.5, 6.5]},
    {name: "M762",         scopes: [2.2, 3.5, 5.3, 6.0, 7.0]},
    {name: "SCAR-L",       scopes: [1.5, 2.3, 3.5, 4.0, 5.0]},
    {name: "G36C",         scopes: [1.5, 2.3, 3.5, 4.0, 5.0]},
    {name: "QBZ",          scopes: [1.6, 2.5, 3.7, 4.3, 5.3]},
    {name: "GROZA",        scopes: [2.3, 3.6, 5.5, 0.0, 0.0]},
    {name: "AUG",          scopes: [1.4, 2.2, 3.3, 3.8, 4.8]},
    {name: "FAMAS",        scopes: [1.3, 2.0, 3.0, 3.5, 4.5]},
    {name: "Honey Badger", scopes: [1.4, 2.2, 3.3, 3.8, 4.8]},
    {name: "K2",           scopes: [1.6, 2.5, 3.7, 4.3, 5.3]},
    {name: "M16A4",        scopes: [1.5, 2.3, 3.4, 4.0, 5.0]},
    {name: "Mk47 Mutant",  scopes: [2.1, 3.2, 4.6, 5.3, 6.2]},
    ; ── Пистолеты-пулемёты (СМГ) ──
    {name: "UMP45",        scopes: [1.0, 1.6, 2.3, 0.0, 0.0]},
    {name: "Vector",       scopes: [1.1, 1.7, 2.5, 0.0, 0.0]},
    {name: "Micro UZI",    scopes: [0.8, 0.0, 0.0, 0.0, 0.0]},
    {name: "MP5K",         scopes: [1.0, 1.6, 2.3, 0.0, 0.0]},
    {name: "PP-19 Bizon",  scopes: [1.0, 1.5, 2.2, 0.0, 0.0]},
    {name: "Tommy Gun",    scopes: [1.3, 2.0, 0.0, 0.0, 0.0]},
    {name: "P90",          scopes: [0.9, 1.4, 2.0, 0.0, 0.0]},
    {name: "JS9",          scopes: [1.0, 1.5, 2.2, 0.0, 0.0]},
    {name: "MP9",          scopes: [0.9, 1.4, 0.0, 0.0, 0.0]},
    ; ── DMR (авто) ──
    {name: "VSS",          scopes: [0.0, 0.0, 0.0, 1.6, 0.0]},
    ; ── Пулемёты (LMG) ──
    {name: "DP-28",        scopes: [1.8, 2.8, 4.0, 4.7, 5.7]},
    {name: "M249",         scopes: [2.0, 3.0, 4.5, 5.2, 6.2]},
    {name: "MG3",          scopes: [2.1, 3.2, 4.7, 5.4, 6.4]},
    ; ── DMR (самозарядные) ──
    {name: "Mini-14",      scopes: [1.2, 2.0, 3.0, 3.5, 4.5]},
    {name: "SLR",          scopes: [1.8, 2.8, 4.2, 5.0, 6.0]},
    {name: "SKS",          scopes: [1.6, 2.5, 3.8, 4.5, 5.5]},
    {name: "Mk12",         scopes: [1.3, 2.1, 3.2, 3.8, 4.8]},
    {name: "Mk14",         scopes: [1.9, 3.0, 4.4, 5.2, 6.3]},
    {name: "QBU",          scopes: [1.3, 2.1, 3.1, 3.7, 4.6]},
    {name: "Dragunov",     scopes: [1.8, 2.8, 4.1, 4.9, 5.9]},
    {name: "M110",         scopes: [1.7, 2.6, 3.9, 4.6, 5.5]}
]

global ScopeNames := ["1x", "2x", "3x", "4x", "6x"]
global ConfigFile := A_ScriptDir "\recoil_profiles.ini"

; smoothFactor: 0.10 (макс. плавно) → 1.00 (моментальная реакция). Тяжёлые/быстрые = выше; медленные DMR = ниже.
global WeaponTuning := Map(
    "M416",         {interval: 8, firstShotKick: 1.34, firstShotTime: 150, smoothFactor: 0.58},
    "ACE32",        {interval: 8, firstShotKick: 1.36, firstShotTime: 155, smoothFactor: 0.58},
    "AKM",          {interval: 7, firstShotKick: 1.42, firstShotTime: 165, smoothFactor: 0.68},
    "M762",         {interval: 7, firstShotKick: 1.46, firstShotTime: 170, smoothFactor: 0.70},
    "SCAR-L",       {interval: 8, firstShotKick: 1.30, firstShotTime: 145, smoothFactor: 0.52},
    "G36C",         {interval: 8, firstShotKick: 1.30, firstShotTime: 145, smoothFactor: 0.52},
    "QBZ",          {interval: 8, firstShotKick: 1.32, firstShotTime: 148, smoothFactor: 0.55},
    "GROZA",        {interval: 7, firstShotKick: 1.48, firstShotTime: 172, smoothFactor: 0.70},
    "AUG",          {interval: 8, firstShotKick: 1.28, firstShotTime: 142, smoothFactor: 0.50},
    "FAMAS",        {interval: 7, firstShotKick: 1.38, firstShotTime: 148, smoothFactor: 0.62},
    "Honey Badger", {interval: 8, firstShotKick: 1.28, firstShotTime: 142, smoothFactor: 0.50},
    "K2",           {interval: 8, firstShotKick: 1.32, firstShotTime: 148, smoothFactor: 0.55},
    "M16A4",        {interval: 9, firstShotKick: 1.26, firstShotTime: 140, isDMR: true, dmrInterval: 300, smoothFactor: 0.48},
    "Mk47 Mutant",  {interval: 9, firstShotKick: 1.34, firstShotTime: 150, isDMR: true, dmrInterval: 250, smoothFactor: 0.55},
    "UMP45",        {interval: 9, firstShotKick: 1.18, firstShotTime: 120, smoothFactor: 0.48},
    "Vector",       {interval: 8, firstShotKick: 1.22, firstShotTime: 125, smoothFactor: 0.52},
    "Micro UZI",    {interval: 8, firstShotKick: 1.16, firstShotTime: 115, smoothFactor: 0.50},
    "MP5K",         {interval: 8, firstShotKick: 1.20, firstShotTime: 122, smoothFactor: 0.50},
    "PP-19 Bizon",  {interval: 9, firstShotKick: 1.17, firstShotTime: 118, smoothFactor: 0.48},
    "Tommy Gun",    {interval: 9, firstShotKick: 1.21, firstShotTime: 124, smoothFactor: 0.50},
    "P90",          {interval: 8, firstShotKick: 1.15, firstShotTime: 112, smoothFactor: 0.48},
    "JS9",          {interval: 8, firstShotKick: 1.18, firstShotTime: 120, smoothFactor: 0.50},
    "MP9",          {interval: 8, firstShotKick: 1.14, firstShotTime: 110, smoothFactor: 0.48},
    "VSS",          {interval: 9, firstShotKick: 1.12, firstShotTime: 110, isDMR: true, dmrInterval: 85,  smoothFactor: 0.45},
    "DP-28",        {interval: 8, firstShotKick: 1.32, firstShotTime: 155, smoothFactor: 0.60},
    "M249",         {interval: 7, firstShotKick: 1.40, firstShotTime: 165, smoothFactor: 0.65},
    "MG3",          {interval: 7, firstShotKick: 1.45, firstShotTime: 172, smoothFactor: 0.65},
    "Mini-14",      {interval: 9, firstShotKick: 1.15, firstShotTime: 120, isDMR: true, dmrInterval: 100, smoothFactor: 0.45},
    "SLR",          {interval: 10, firstShotKick: 1.25, firstShotTime: 140, isDMR: true, dmrInterval: 160, smoothFactor: 0.42},
    "SKS",          {interval: 10, firstShotKick: 1.22, firstShotTime: 135, isDMR: true, dmrInterval: 160, smoothFactor: 0.42},
    "Mk12",         {interval: 9, firstShotKick: 1.18, firstShotTime: 125, isDMR: true, dmrInterval: 110, smoothFactor: 0.45},
    "Mk14",         {interval: 9, firstShotKick: 1.28, firstShotTime: 135, isDMR: true, dmrInterval: 85,  smoothFactor: 0.48},
    "QBU",          {interval: 9, firstShotKick: 1.14, firstShotTime: 118, isDMR: true, dmrInterval: 110, smoothFactor: 0.45},
    "Dragunov",     {interval: 10, firstShotKick: 1.24, firstShotTime: 138, isDMR: true, dmrInterval: 155, smoothFactor: 0.42},
    "M110",         {interval: 10, firstShotKick: 1.22, firstShotTime: 135, isDMR: true, dmrInterval: 145, smoothFactor: 0.42}
)

ValidateWeaponData() {
    global WeaponProfiles, WeaponTuning, ConfigFile
    for _, wp in WeaponProfiles {
        if (!WeaponTuning.Has(wp.name))
            OutputDebug "Recoil: нет WeaponTuning для " wp.name "`n"
        prev := 0.0
        for v in wp.scopes {
            if (v > 0.0 && v < prev)
                OutputDebug "Recoil: отдача по прицелам не растёт у " wp.name "`n"
            if (v > 0.0)
                prev := v
        }
    }
}

; ════════════════════════════════════════════════════════════════════════════════
; НАСТРОЙКИ
; ════════════════════════════════════════════════════════════════════════════════

global CurrentWeapon := 1
global CurrentScope := 1
global RecoilStrength := 1.9
global RecoilMin := 0.1
global RecoilMax := 20.0
global RecoilStep := 0.1
global RecoilInterval := 8
global ShiftMultiplier := 1.20
global FirstShotKick   := 1.5
global FirstShotTime   := 150
global RecoilSmoothFactor := 0.55
global IntervalMin := 6
global IntervalMax := 15
global FirstShotKickMin := 1.00
global FirstShotKickMax := 2.20
global FirstShotTimeMin := 80
global FirstShotTimeMax := 280
global DmrIntervalMin := 40
global DmrIntervalMax := 400
global SmoothFactorMin := 0.10   ; максимальная плавность
global SmoothFactorMax := 1.00   ; моментальная реакция (без сглаживания)

global PlayerStance := "STAND"
global CrouchMultiplier := 0.80
global ProneMultiplier := 0.40

global MacroEnabled := false  ; ✅ ИСПРАВЛЕНО: было true
global LButtonToXButton2 := false
global VirtualXButton2Down := false
global SprayStartTime := 0
global RemainderY := 0.0
global SmoothedRecoil := 0.0
global IsSpraying := false
global ManualAdjust := 0.0
global CalibTargetIndex := 1
global CalibTargetNames := ["RCL", "INT", "KICK", "TIME", "DMR", "SMF"]

; ════════════════════════════════════════════════════════════════════════════════
; ФУНКЦИИ ПРОФИЛЕЙ
; ════════════════════════════════════════════════════════════════════════════════

ApplyWeaponProfile() {
    global CurrentWeapon, CurrentScope, RecoilStrength, ManualAdjust, WeaponProfiles, RecoilMin, RecoilMax
    wp := WeaponProfiles[CurrentWeapon]
    ApplyCurrentWeaponTuning()
    baseRecoil := wp.scopes[CurrentScope]
    if (baseRecoil == 0.0) {
        loop wp.scopes.Length {
            idx := wp.scopes.Length - A_Index + 1
            if (wp.scopes[idx] != 0.0) {
                CurrentScope := idx
                baseRecoil := wp.scopes[idx]
                break
            }
        }
    }
    RecoilStrength := Round(baseRecoil + ManualAdjust, 1)
    if (RecoilStrength < RecoilMin)
        RecoilStrength := RecoilMin
    if (RecoilStrength > RecoilMax)
        RecoilStrength := RecoilMax
    UpdateOverlay()
}

ApplyCurrentWeaponTuning() {
    global CurrentWeapon, RecoilInterval, FirstShotKick, FirstShotTime, RecoilSmoothFactor, WeaponTuning
    wp := WeaponProfiles[CurrentWeapon]
    if (WeaponTuning.Has(wp.name)) {
        tuning := WeaponTuning[wp.name]
        RecoilInterval := tuning.interval
        FirstShotKick := tuning.firstShotKick
        FirstShotTime := tuning.firstShotTime
        RecoilSmoothFactor := tuning.smoothFactor
    }
}

SelectWeapon(index) {
    global CurrentWeapon, ManualAdjust
    if (index < 1 || index > WeaponProfiles.Length)
        return
    CurrentWeapon := index
    ManualAdjust := 0.0
    ApplyWeaponProfile()
    SoundBeep(900, 50)
}

NextWeapon() {
    global CurrentWeapon, ManualAdjust
    CurrentWeapon := CurrentWeapon >= WeaponProfiles.Length ? 1 : CurrentWeapon + 1
    ManualAdjust := 0.0
    ApplyWeaponProfile()
    SoundBeep(900, 50)
}

PrevWeapon() {
    global CurrentWeapon, ManualAdjust
    CurrentWeapon := CurrentWeapon <= 1 ? WeaponProfiles.Length : CurrentWeapon - 1
    ManualAdjust := 0.0
    ApplyWeaponProfile()
    SoundBeep(700, 50)
}

NextScope() {
    global CurrentScope
    wp := WeaponProfiles[CurrentWeapon]
    newScope := CurrentScope
    loop wp.scopes.Length {
        tryScope := Mod(CurrentScope + A_Index - 1, wp.scopes.Length) + 1
        if (wp.scopes[tryScope] != 0.0) {
            newScope := tryScope
            break
        }
    }
    if (newScope != CurrentScope) {
        CurrentScope := newScope
        ApplyWeaponProfile()
        SoundBeep(1000, 40)
    }
}

PrevScope() {
    global CurrentScope
    wp := WeaponProfiles[CurrentWeapon]
    newScope := CurrentScope
    loop wp.scopes.Length {
        tryScope := Mod(CurrentScope - A_Index - 1 + wp.scopes.Length, wp.scopes.Length) + 1
        if (wp.scopes[tryScope] != 0.0) {
            newScope := tryScope
            break
        }
    }
    if (newScope != CurrentScope) {
        CurrentScope := newScope
        ApplyWeaponProfile()
        SoundBeep(800, 40)
    }
}

; ════════════════════════════════════════════════════════════════════════════════
; ИНТЕРФЕЙС
; ════════════════════════════════════════════════════════════════════════════════

global RecoilGui := Gui("+AlwaysOnTop -Caption +ToolWindow +E0x20 +E0x08000000")
RecoilGui.BackColor := "000000"
RecoilGui.SetFont("s10 c00FF00 w700", "Segoe UI")
global RecoilText := RecoilGui.Add("Text", "w220 Center", "")
RecoilGui.Show("x" . (A_ScreenWidth - 235) . " y0 NoActivate")
WinSetTransColor("000000 200", RecoilGui)
SetTimer(KeepOverlayOnTop, 1000)
ApplyWeaponProfile()

IsGameActive() {
    return WinActive("ahk_exe TslGame.exe")
}

IsCursorVisible() {
    static mode
    CoordMode "Mouse", "Screen"
    MouseGetPos(&xPos, &yPos)
    return xPos >= A_ScreenWidth - 100 || yPos <= 100
}

KeepOverlayOnTop() {
    if (MacroEnabled && RecoilGui)
        try DllCall("SetWindowPos", "Ptr", RecoilGui.Hwnd, "Ptr", -1, "Int", 0, "Int", 0, "Int", 0, "Int", 0, "UInt", 0x0013)
}

ApplyOverlayChrome() {
    global RecoilGui
    if (RecoilGui)
        DllCall("SetWindowPos", "Ptr", RecoilGui.Hwnd, "Ptr", -1, "Int", 0, "Int", 0, "Int", 0, "Int", 0, "UInt", 0x0013)
}

UpdateOverlay() {
    global RecoilStrength, RecoilText, LButtonToXButton2, CurrentWeapon, CurrentScope, MacroEnabled
    if (RecoilText) {
        wp := WeaponProfiles[CurrentWeapon]
        disp := wp.name . "|" . ScopeNames[CurrentScope] . "|" . Format("{:.1f}", RecoilStrength)
        if (LButtonToXButton2)
            disp .= "|RMP"
        if (!MacroEnabled)
            disp := "[OFF] " . disp
        RecoilText.Value := disp
    }
}

; ════════════════════════════════════════════════════════════════════════════════
; СБРОС НАСТРОЕК
; ════════════════════════════════════════════════════════════════════════════════

ResetAllSettingsToDefaults() {
    global CurrentWeapon, CurrentScope, RecoilStrength, ManualAdjust, RecoilInterval
    global FirstShotKick, FirstShotTime, RecoilSmoothFactor, ShiftMultiplier
    global CrouchMultiplier, ProneMultiplier, LButtonToXButton2, PlayerStance
    
    CurrentWeapon := 1
    CurrentScope := 1
    ManualAdjust := 0.0
    RecoilInterval := 8
    FirstShotKick := 1.5
    FirstShotTime := 150
    RecoilSmoothFactor := 0.55
    ShiftMultiplier := 1.20
    CrouchMultiplier := 0.80
    ProneMultiplier := 0.40
    LButtonToXButton2 := false
    PlayerStance := "STAND"
    
    ApplyWeaponProfile()
    SoundBeep(1500, 150)
    MsgBox "✅ ВСЕ НАСТРОЙКИ СБРОШЕНЫ!`nВсе параметры вернулись в исходное состояние.", "Сброс успешен", "48"
}

; ════════════════════════════════════════════════════════════════════════════════
; ЛОГИКА КОМПЕНСАЦИИ ОТДАЧИ
; ════════════════════════════════════════════════════════════════════════════════

ReleaseVirtualXButton2() {
    global VirtualXButton2Down
    if (VirtualXButton2Down) {
        SendInput "{XButton2 Up}"
        VirtualXButton2Down := false
    }
}

PressVirtualXButton2() {
    global VirtualXButton2Down
    if (!VirtualXButton2Down) {
        SendInput "{XButton2 Down}"
        VirtualXButton2Down := true
    }
}

ApplyRecoil() {
    global RemainderY, IsSpraying, MacroEnabled, RecoilStrength, ShiftMultiplier
    global SprayStartTime, FirstShotTime, FirstShotKick, RecoilSmoothFactor, SmoothedRecoil
    global PlayerStance, CrouchMultiplier, ProneMultiplier
    Critical
    if (!MacroEnabled || !IsGameActive() || IsCursorVisible()) {
        StopSpray()
        return
    }

    if (!IsSpraying)
        return

    if (!GetKeyState("LButton", "P") && !GetKeyState("XButton2", "P")) {
        StopSpray()
        return
    }

    elapsed := A_TickCount - SprayStartTime
    curStrength := RecoilStrength

    if (PlayerStance == "CROUCH")
        curStrength *= CrouchMultiplier
    else if (PlayerStance == "PRONE")
        curStrength *= ProneMultiplier

    if (GetKeyState("Shift", "P"))
        curStrength *= ShiftMultiplier

    if (elapsed < FirstShotTime) {
        firstShotProgress := elapsed / FirstShotTime
        curStrength *= 1 + ((FirstShotKick - 1) * (1 - firstShotProgress))
    }

    if (SmoothedRecoil <= 0.0)
        SmoothedRecoil := curStrength
    else
        SmoothedRecoil += (curStrength - SmoothedRecoil) * RecoilSmoothFactor

    totalY := SmoothedRecoil + RemainderY
    moveY := Round(totalY)
    RemainderY := totalY - moveY

    if (moveY != 0)
        DllCall("user32\mouse_event", "UInt", 0x0001, "Int", 0, "Int", moveY, "UInt", 0, "Ptr", 0)
}

AutoFire() {
    global MacroEnabled, LButtonToXButton2
    Critical
    if (!MacroEnabled || !IsGameActive() || IsCursorVisible()) {
        SetTimer AutoFire, 0
        StopSpray()
        return
    }

    lbDown := GetKeyState("LButton", "P")
    xb2Down := GetKeyState("XButton2", "P")
    if (!lbDown && !xb2Down) {
        SetTimer AutoFire, 0
        StopSpray()
        return
    }

    Click
}

StartSpray() {
    global SprayStartTime, RemainderY, SmoothedRecoil, IsSpraying, MacroEnabled, RecoilInterval
    if (!MacroEnabled || !IsGameActive() || IsCursorVisible())
        return
    if (IsSpraying)
        return
    IsSpraying := true
    SprayStartTime := A_TickCount
    RemainderY := 0.0
    SmoothedRecoil := 0.0
    SetTimer ApplyRecoil, RecoilInterval
}

StopSpray() {
    global IsSpraying, RemainderY, SmoothedRecoil
    SetTimer ApplyRecoil, 0
    SetTimer AutoFire, 0
    if (!IsSpraying) {
        ReleaseVirtualXButton2()
        return
    }
    IsSpraying := false
    RemainderY := 0.0
    SmoothedRecoil := 0.0
    ReleaseVirtualXButton2()
}

; ════════════════════════════════════════════════════════════════════════════════
; ХОТКЕИ — ГЛОБАЛЬНЫЕ
; ════════════════════════════════════════════════════════════════════════════════

ToggleMacro() {
    global MacroEnabled, RecoilGui, LButtonToXButton2
    MacroEnabled := !MacroEnabled
    if (MacroEnabled) {
        RecoilGui.Show("NoActivate")
        ApplyOverlayChrome()
        UpdateOverlay()
        SoundBeep(1200, 100)
    } else {
        LButtonToXButton2 := false
        RecoilGui.Hide()
        SoundBeep(400, 100)
        StopSpray()
        ReleaseVirtualXButton2()
    }
}

F9::ToggleMacro()
^CapsLock::ToggleMacro()

; ★ F12 - Сброс ВСЕ настроек по умолчанию
F12::ResetAllSettingsToDefaults()

; F4 - Альтернативный сброс (опционально)
F4::ResetAllSettingsToDefaults()

; ════════════════════════════════════════════════════════════════════════════════
; ХОТКЕИ ДЛЯ ТОНКОЙ НАСТРОЙКИ — ТОЛЬКО КОГДА МАКРО ВКЛЮЧЕНО
; ════════════════════════════════════════════════════════════════════════════════

#HotIf MacroEnabled

; Увеличить/уменьшить отдачу (Numpad + и -)
NumpadAdd:: {
    global RecoilStrength, RecoilMax, ManualAdjust, RecoilStep
    if (RecoilStrength < RecoilMax) {
        ManualAdjust := Round(ManualAdjust + RecoilStep, 1)
        ApplyWeaponProfile()
        SoundBeep(800, 50)
    } else {
        SoundBeep(600, 50)
    }
}

NumpadSub:: {
    global RecoilStrength, RecoilMin, ManualAdjust, RecoilStep
    if (RecoilStrength > RecoilMin) {
        ManualAdjust := Round(ManualAdjust - RecoilStep, 1)
        ApplyWeaponProfile()
        SoundBeep(500, 50)
    } else {
        SoundBeep(300, 50)
    }
}

; Выбор оружий — Numpad 1-9, 0
Numpad1::SelectWeapon(1)
Numpad2::SelectWeapon(2)
Numpad3::SelectWeapon(3)
Numpad4::SelectWeapon(4)
Numpad5::SelectWeapon(5)
Numpad6::SelectWeapon(6)
Numpad7::SelectWeapon(7)
Numpad8::SelectWeapon(8)
Numpad9::SelectWeapon(9)
Numpad0::SelectWeapon(10)

; Переключение прицела (Numpad / и *)
NumpadDiv::NextScope()
NumpadMult::PrevScope()

#HotIf

; ════════════════════════════════════════════════════════════════════════════════
; РЕЖИМ REMAP (LButton → XButton2)
; ════════════════════════════════════════════════════════════════════════════════

#HotIf WinActive("ahk_exe TslGame.exe") && MacroEnabled

$*k:: {
    if (!IsGameActive()) {
        SendInput "{Blind}{k}"
        return
    }

    Critical
    global LButtonToXButton2, IsSpraying

    if (IsSpraying) {
        StopSpray()
        if (LButtonToXButton2)
            SendInput "{XButton2 Up}"
    }

    LButtonToXButton2 := !LButtonToXButton2
    UpdateOverlay()
    if (LButtonToXButton2)
        SoundBeep(1000, 50)
    else
        SoundBeep(600, 50)
    Critical "Off"
}

#HotIf

; ════════════════════════════════════════════════════════════════════════════════
; РЕЖИМ REMAP АКТИВЕН (LButton → XButton2)
; ════════════════════════════════════════════════════════════════════════════════

#HotIf WinActive("ahk_exe TslGame.exe") && LButtonToXButton2

$*LButton:: {
    SendInput "{XButton2 Down}"
    if (MacroEnabled) {
        StartSpray()
        SetTimer AutoFire, 40
    }
}

$*LButton Up:: {
    SendInput "{XButton2 Up}"
    StopSpray()
}

#HotIf

; ════════════════════════════════════════════════════════════════════════════════
; ОБЫЧНЫЙ РЕЖИМ (LButton активен)
; ════════════════════════════════════════════════════════════════════════════════

#HotIf WinActive("ahk_exe TslGame.exe") && !LButtonToXButton2

*~LButton:: {
    if (!MacroEnabled)
        return
    StartSpray()
}

*~LButton Up:: {
    StopSpray()
}

#HotIf

; ════════════════════════════════════════════════════════════════════════════════
; АЛЬТЕРНАТИВНАЯ КНОПКА СТРЕЛЬБЫ (XButton2)
; ════════════════════════════════════════════════════════════════════════════════

#HotIf WinActive("ahk_exe TslGame.exe")

$*~XButton2:: {
    if (!MacroEnabled || LButtonToXButton2)
        return
    StartSpray()
    SetTimer AutoFire, 40
}

$*~XButton2 Up:: {
    if (LButtonToXButton2)
        return
    StopSpray()
}

#HotIf

; ════════════════════════════════════════════════════════════════════════════════
; EMERGENCY EXIT
; ════════════════════════════════════════════════════════════════════════════════

^+q::ExitApp
