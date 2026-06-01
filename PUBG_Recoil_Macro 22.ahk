; ╔════════════════════════════════════════════════════════════════[...]
; ║                     PUBG RECOIL CONTROL MACRO v5.0 PRO (OPTIMIZED)          ║
; ║                         AutoHotkey v2.0+                                    ║
; ║        ПРОФИЛИ ОРУЖИЙ | АВТО-ПРИЦЕЛ | NO RECOIL ALL WEAPONS                 ║
; ║      High Resolution Timer + Sub-pixel Accumulator + First Shot Kick        ║
; ╚════════════════════════════════════════════════════════════════[...]

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

; ══════════════════════════════════════════════════════════════════[...]
; ПРОВЕРКА ПРАВ
; ══════════════════════════════════════════════════════════════════[...]
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

; ══════════════════════════════════════════════════════════════════[...]
; ПРОФИЛИ ОРУЖИЙ — ВСЕ ОРУЖИЯ PUBG
; ══════════════════════════════════════════════════════════════════[...]

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

; ══════════════════════════════════════════════════════════════════[...]
; ЗНАЧЕНИЯ ПО УМОЛЧАНИЮ (для сброса)
; ══════════════════════════════════════════════════════════════════[...]

global DefaultWeaponProfiles := Map(
    "M416",         {scopes: [1.9, 2.8, 3.9, 4.5, 5.5]},
    "ACE32",        {scopes: [1.7, 2.7, 4.1, 4.8, 5.8]},
    "AKM",          {scopes: [2.0, 3.3, 4.8, 5.5, 6.5]},
    "M762",         {scopes: [2.2, 3.5, 5.3, 6.0, 7.0]},
    "SCAR-L",       {scopes: [1.5, 2.3, 3.5, 4.0, 5.0]},
    "G36C",         {scopes: [1.5, 2.3, 3.5, 4.0, 5.0]},
    "QBZ",          {scopes: [1.6, 2.5, 3.7, 4.3, 5.3]},
    "GROZA",        {scopes: [2.3, 3.6, 5.5, 0.0, 0.0]},
    "AUG",          {scopes: [1.4, 2.2, 3.3, 3.8, 4.8]},
    "FAMAS",        {scopes: [1.3, 2.0, 3.0, 3.5, 4.5]},
    "Honey Badger", {scopes: [1.4, 2.2, 3.3, 3.8, 4.8]},
    "K2",           {scopes: [1.6, 2.5, 3.7, 4.3, 5.3]},
    "M16A4",        {scopes: [1.5, 2.3, 3.4, 4.0, 5.0]},
    "Mk47 Mutant",  {scopes: [2.1, 3.2, 4.6, 5.3, 6.2]},
    "UMP45",        {scopes: [1.0, 1.6, 2.3, 0.0, 0.0]},
    "Vector",       {scopes: [1.1, 1.7, 2.5, 0.0, 0.0]},
    "Micro UZI",    {scopes: [0.8, 0.0, 0.0, 0.0, 0.0]},
    "MP5K",         {scopes: [1.0, 1.6, 2.3, 0.0, 0.0]},
    "PP-19 Bizon",  {scopes: [1.0, 1.5, 2.2, 0.0, 0.0]},
    "Tommy Gun",    {scopes: [1.3, 2.0, 0.0, 0.0, 0.0]},
    "P90",          {scopes: [0.9, 1.4, 2.0, 0.0, 0.0]},
    "JS9",          {scopes: [1.0, 1.5, 2.2, 0.0, 0.0]},
    "MP9",          {scopes: [0.9, 1.4, 0.0, 0.0, 0.0]},
    "VSS",          {scopes: [0.0, 0.0, 0.0, 1.6, 0.0]},
    "DP-28",        {scopes: [1.8, 2.8, 4.0, 4.7, 5.7]},
    "M249",         {scopes: [2.0, 3.0, 4.5, 5.2, 6.2]},
    "MG3",          {scopes: [2.1, 3.2, 4.7, 5.4, 6.4]},
    "Mini-14",      {scopes: [1.2, 2.0, 3.0, 3.5, 4.5]},
    "SLR",          {scopes: [1.8, 2.8, 4.2, 5.0, 6.0]},
    "SKS",          {scopes: [1.6, 2.5, 3.8, 4.5, 5.5]},
    "Mk12",         {scopes: [1.3, 2.1, 3.2, 3.8, 4.8]},
    "Mk14",         {scopes: [1.9, 3.0, 4.4, 5.2, 6.3]},
    "QBU",          {scopes: [1.3, 2.1, 3.1, 3.7, 4.6]},
    "Dragunov",     {scopes: [1.8, 2.8, 4.1, 4.9, 5.9]},
    "M110",         {scopes: [1.7, 2.6, 3.9, 4.6, 5.5]}
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

; ══════════════════════════════════════════════════════════════════[...]
; НАСТРОЙКИ
; ══════════════════════════════════════════════════════════════════[...]

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

; ══════════════════════════════════════════════════════════════════[...]
; ФУНКЦИИ ПРОФИЛЕЙ
; ══════════════════════════════════════════════════════════════════[...]

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
        ; ✅ ИСПРАВЛЕНО: добавлен fallback если все скопы нулевые
        if (baseRecoil == 0.0) {
            CurrentScope := 1
            baseRecoil := 1.0
        }
    }
    RecoilStrength := Round(baseRecoil + ManualAdjust, 1)
    if (RecoilStrength < RecoilMin)
        RecoilStrength := RecoilMin
    if (RecoilStrength > RecoilMax)
        RecoilStrength := RecoilMax
    UpdateOverlay()
    RestartSprayTimersIfActive()
}

; ✅ ИСПРАВЛЕНО: Объединена дублирующаяся логика
ResetWeaponState() {
    global CurrentScope, ManualAdjust
    CurrentScope := 1
    ManualAdjust := 0.0
}

SelectWeapon(index) {
    global CurrentWeapon, WeaponProfiles
    if (index < 1 || index > WeaponProfiles.Length)
        return
    CurrentWeapon := index
    ResetWeaponState()
    ApplyWeaponProfile()
    SoundBeep(900, 50)
}

NextWeapon() {
    global CurrentWeapon, WeaponProfiles
    CurrentWeapon := CurrentWeapon >= WeaponProfiles.Length ? 1 : CurrentWeapon + 1
    ResetWeaponState()
    ApplyWeaponProfile()
    SoundBeep(900, 50)
}

PrevWeapon() {
    global CurrentWeapon, WeaponProfiles
    CurrentWeapon := CurrentWeapon <= 1 ? WeaponProfiles.Length : CurrentWeapon - 1
    ResetWeaponState()
    ApplyWeaponProfile()
    SoundBeep(700, 50)
}

NextScope() {
    global CurrentWeapon, CurrentScope, WeaponProfiles
    wp := WeaponProfiles[CurrentWeapon]
    newScope := CurrentScope
    loop wp.scopes.Length {
        ; ✅ ИСПРАВЛЕНО: +A_Index (не +A_Index-1) — пропускаем текущий прицел
        tryScope := Mod(CurrentScope + A_Index - 1, wp.scopes.Length) + 1
        if (tryScope != CurrentScope && wp.scopes[tryScope] != 0.0) {
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
    global CurrentWeapon, CurrentScope, WeaponProfiles
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

; ══════════════════════════════════════════════════════════════════[...]
; ИНТЕРФЕЙС
; ══════════════════════════════════════════════════════════════════[...]

ApplyCurrentWeaponTuning() {
    global CurrentWeapon, WeaponProfiles, WeaponTuning, RecoilInterval, FirstShotKick, FirstShotTime, RecoilSmoothFactor
    wp := WeaponProfiles[CurrentWeapon]
    if (WeaponTuning.Has(wp.name)) {
        tuning := WeaponTuning[wp.name]
        RecoilInterval    := tuning.interval
        FirstShotKick     := tuning.firstShotKick
        FirstShotTime     := tuning.firstShotTime
        if (tuning.HasOwnProp("smoothFactor"))
            RecoilSmoothFactor := tuning.smoothFactor
    }
}

ProfileSectionName(weaponName) {
    section := StrReplace(weaponName, " ", "_")
    section := StrReplace(section, "-", "_")
    section := StrReplace(section, ".", "_")
    return "Weapon_" section
}

LoadProfilesFromIni() {
    global ConfigFile, WeaponProfiles, WeaponTuning, IntervalMin, IntervalMax
    global FirstShotKickMin, FirstShotKickMax, FirstShotTimeMin, FirstShotTimeMax
    global DmrIntervalMin, DmrIntervalMax, SmoothFactorMin, SmoothFactorMax
    global CrouchMultiplier, ProneMultiplier, ShiftMultiplier
    if (!FileExist(ConfigFile))
        return

    for _, wp in WeaponProfiles {
        section := ProfileSectionName(wp.name)
        loop wp.scopes.Length {
            defaultVal := wp.scopes[A_Index]
            rawVal := IniRead(ConfigFile, section, "Scope" A_Index, defaultVal)
            if IsNumber(rawVal) {
                scopeVal := Round(Number(rawVal), 1)
                if (scopeVal >= 0.0 && scopeVal <= 20.0)
                    wp.scopes[A_Index] := scopeVal
            }
        }

        if (WeaponTuning.Has(wp.name)) {
            tuning := WeaponTuning[wp.name]

            rawInterval := IniRead(ConfigFile, section, "Interval", tuning.interval)
            if IsNumber(rawInterval) {
                interval := Round(Number(rawInterval))
                if (interval >= IntervalMin && interval <= IntervalMax)
                    tuning.interval := interval
            }

            rawKick := IniRead(ConfigFile, section, "FirstShotKick", tuning.firstShotKick)
            if IsNumber(rawKick) {
                kick := Round(Number(rawKick), 2)
                if (kick >= FirstShotKickMin && kick <= FirstShotKickMax)
                    tuning.firstShotKick := kick
            }

            rawTime := IniRead(ConfigFile, section, "FirstShotTime", tuning.firstShotTime)
            if IsNumber(rawTime) {
                shotTime := Round(Number(rawTime))
                if (shotTime >= FirstShotTimeMin && shotTime <= FirstShotTimeMax)
                    tuning.firstShotTime := shotTime
            }

            if (tuning.HasOwnProp("dmrInterval")) {
                rawDmr := IniRead(ConfigFile, section, "DmrInterval", tuning.dmrInterval)
                if IsNumber(rawDmr) {
                    dmrMs := Round(Number(rawDmr))
                    if (dmrMs >= DmrIntervalMin && dmrMs <= DmrIntervalMax)
                        tuning.dmrInterval := dmrMs
                }
            }

            if (tuning.HasOwnProp("smoothFactor")) {
                rawSmooth := IniRead(ConfigFile, section, "SmoothFactor", tuning.smoothFactor)
                if IsNumber(rawSmooth) {
                    smooth := Round(Number(rawSmooth), 2)
                    if (smooth >= SmoothFactorMin && smooth <= SmoothFactorMax)
                        tuning.smoothFactor := smooth
                }
            }
        }
    }

    rawCrouch := IniRead(ConfigFile, "Settings", "CrouchMultiplier", 0.80)
    if IsNumber(rawCrouch) {
        val := Round(Number(rawCrouch), 2)
        if (val >= 0.1 && val <= 2.0)
            CrouchMultiplier := val
    }
    rawProne := IniRead(ConfigFile, "Settings", "ProneMultiplier", 0.40)
    if IsNumber(rawProne) {
        val := Round(Number(rawProne), 2)
        if (val >= 0.1 && val <= 2.0)
            ProneMultiplier := val
    }
    rawShift := IniRead(ConfigFile, "Settings", "ShiftMultiplier", 1.20)
    if IsNumber(rawShift) {
        val := Round(Number(rawShift), 2)
        if (val >= 0.5 && val <= 3.0)
            ShiftMultiplier := val
    }
}

EnsureIniWeaponSections() {
    global ConfigFile, WeaponProfiles
    if (!FileExist(ConfigFile))
        SaveProfilesToIni()
    else {
        for _, wp in WeaponProfiles {
            section := ProfileSectionName(wp.name)
            if (!IniRead(ConfigFile, section, "Scope1", "")) {
                SaveProfilesToIni()
                break
            }
        }
    }
}

SaveProfilesToIni() {
    global ConfigFile, WeaponProfiles, WeaponTuning
    global CrouchMultiplier, ProneMultiplier, ShiftMultiplier
    for _, wp in WeaponProfiles {
        section := ProfileSectionName(wp.name)
        loop wp.scopes.Length {
            IniWrite(Round(wp.scopes[A_Index], 1), ConfigFile, section, "Scope" A_Index)
        }

        if (WeaponTuning.Has(wp.name)) {
            tuning := WeaponTuning[wp.name]
            IniWrite(tuning.interval, ConfigFile, section, "Interval")
            IniWrite(Format("{:.2f}", tuning.firstShotKick), ConfigFile, section, "FirstShotKick")
            IniWrite(tuning.firstShotTime, ConfigFile, section, "FirstShotTime")
            if (tuning.HasOwnProp("dmrInterval"))
                IniWrite(tuning.dmrInterval, ConfigFile, section, "DmrInterval")
            if (tuning.HasOwnProp("smoothFactor"))
                IniWrite(Format("{:.2f}", tuning.smoothFactor), ConfigFile, section, "SmoothFactor")
        }
    }

    IniWrite(Format("{:.2f}", CrouchMultiplier), ConfigFile, "Settings", "CrouchMultiplier")
    IniWrite(Format("{:.2f}", ProneMultiplier), ConfigFile, "Settings", "ProneMultiplier")
    IniWrite(Format("{:.2f}", ShiftMultiplier), ConfigFile, "Settings", "ShiftMultiplier")
}

; ✅ ИСПРАВЛЕНО: быстрое сохранение только текущего оружия (без лагов при калибровке)
SaveCurrentWeaponToIni() {
    global ConfigFile, WeaponProfiles, WeaponTuning, CurrentWeapon
    wp := WeaponProfiles[CurrentWeapon]
    section := ProfileSectionName(wp.name)
    loop wp.scopes.Length {
        IniWrite(Round(wp.scopes[A_Index], 1), ConfigFile, section, "Scope" A_Index)
    }
    if (WeaponTuning.Has(wp.name)) {
        tuning := WeaponTuning[wp.name]
        IniWrite(tuning.interval, ConfigFile, section, "Interval")
        IniWrite(Format("{:.2f}", tuning.firstShotKick), ConfigFile, section, "FirstShotKick")
        IniWrite(tuning.firstShotTime, ConfigFile, section, "FirstShotTime")
        if (tuning.HasOwnProp("dmrInterval"))
            IniWrite(tuning.dmrInterval, ConfigFile, section, "DmrInterval")
        if (tuning.HasOwnProp("smoothFactor"))
            IniWrite(Format("{:.2f}", tuning.smoothFactor), ConfigFile, section, "SmoothFactor")
    }
}

; ══════════════════════════════════════════════════════════════════[...]
; F12 — СБРОС ВСЕХ НАСТРОЕК ПО УМОЛЧАНИЮ
; ══════════════════════════════════════════════════════════════════[...]

ResetAllSettingsToDefaults() {
    global WeaponProfiles, WeaponTuning, DefaultWeaponProfiles
    global CrouchMultiplier, ProneMultiplier, ShiftMultiplier
    global CurrentWeapon, CurrentScope, ManualAdjust, CalibTargetIndex
    
    ; Сброс координат оружий до значений по умолчанию
    for _, wp in WeaponProfiles {
        if (DefaultWeaponProfiles.Has(wp.name)) {
            defaults := DefaultWeaponProfiles[wp.name]
            loop defaults.scopes.Length {
                wp.scopes[A_Index] := defaults.scopes[A_Index]
            }
        }
    }
    
    ; Сброс параметров оружий до значений по умолчанию в WeaponTuning
    ResetWeaponTuningDefaults()
    
    ; Сброс множителей
    CrouchMultiplier := 0.80
    ProneMultiplier := 0.40
    ShiftMultiplier := 1.20
    
    ; Сброс выбора оружия и калибровки
    CurrentWeapon := 1
    CurrentScope := 1
    ManualAdjust := 0.0
    CalibTargetIndex := 1
    
    ; Сохранение всех изменений в INI файл
    SaveProfilesToIni()
    
    ; Перезагрузить профили и обновить интерфейс
    ApplyWeaponProfile()
    UpdateOverlay()
    
    ; Звуковое уведомление
    SoundBeep(1500, 150)  ; Высокий звук для подтверждения
    SoundBeep(1000, 100)  ; Второй звук
    SoundBeep(500, 100)   ; Третий звук
}

ResetWeaponTuningDefaults() {
    global WeaponTuning
    
    WeaponTuning["M416"].interval := 8
    WeaponTuning["M416"].firstShotKick := 1.34
    WeaponTuning["M416"].firstShotTime := 150
    WeaponTuning["M416"].smoothFactor := 0.58
    
    WeaponTuning["ACE32"].interval := 8
    WeaponTuning["ACE32"].firstShotKick := 1.36
    WeaponTuning["ACE32"].firstShotTime := 155
    WeaponTuning["ACE32"].smoothFactor := 0.58
    
    WeaponTuning["AKM"].interval := 7
    WeaponTuning["AKM"].firstShotKick := 1.42
    WeaponTuning["AKM"].firstShotTime := 165
    WeaponTuning["AKM"].smoothFactor := 0.68
    
    WeaponTuning["M762"].interval := 7
    WeaponTuning["M762"].firstShotKick := 1.46
    WeaponTuning["M762"].firstShotTime := 170
    WeaponTuning["M762"].smoothFactor := 0.70
    
    WeaponTuning["SCAR-L"].interval := 8
    WeaponTuning["SCAR-L"].firstShotKick := 1.30
    WeaponTuning["SCAR-L"].firstShotTime := 145
    WeaponTuning["SCAR-L"].smoothFactor := 0.52
    
    WeaponTuning["G36C"].interval := 8
    WeaponTuning["G36C"].firstShotKick := 1.30
    WeaponTuning["G36C"].firstShotTime := 145
    WeaponTuning["G36C"].smoothFactor := 0.52
    
    WeaponTuning["QBZ"].interval := 8
    WeaponTuning["QBZ"].firstShotKick := 1.32
    WeaponTuning["QBZ"].firstShotTime := 148
    WeaponTuning["QBZ"].smoothFactor := 0.55
    
    WeaponTuning["GROZA"].interval := 7
    WeaponTuning["GROZA"].firstShotKick := 1.48
    WeaponTuning["GROZA"].firstShotTime := 172
    WeaponTuning["GROZA"].smoothFactor := 0.70
    
    WeaponTuning["AUG"].interval := 8
    WeaponTuning["AUG"].firstShotKick := 1.28
    WeaponTuning["AUG"].firstShotTime := 142
    WeaponTuning["AUG"].smoothFactor := 0.50
    
    WeaponTuning["FAMAS"].interval := 7
    WeaponTuning["FAMAS"].firstShotKick := 1.38
    WeaponTuning["FAMAS"].firstShotTime := 148
    WeaponTuning["FAMAS"].smoothFactor := 0.62
    
    WeaponTuning["Honey Badger"].interval := 8
    WeaponTuning["Honey Badger"].firstShotKick := 1.28
    WeaponTuning["Honey Badger"].firstShotTime := 142
    WeaponTuning["Honey Badger"].smoothFactor := 0.50
    
    WeaponTuning["K2"].interval := 8
    WeaponTuning["K2"].firstShotKick := 1.32
    WeaponTuning["K2"].firstShotTime := 148
    WeaponTuning["K2"].smoothFactor := 0.55
    
    WeaponTuning["M16A4"].interval := 9
    WeaponTuning["M16A4"].firstShotKick := 1.26
    WeaponTuning["M16A4"].firstShotTime := 140
    WeaponTuning["M16A4"].dmrInterval := 300
    WeaponTuning["M16A4"].smoothFactor := 0.48
    
    WeaponTuning["Mk47 Mutant"].interval := 9
    WeaponTuning["Mk47 Mutant"].firstShotKick := 1.34
    WeaponTuning["Mk47 Mutant"].firstShotTime := 150
    WeaponTuning["Mk47 Mutant"].dmrInterval := 250
    WeaponTuning["Mk47 Mutant"].smoothFactor := 0.55
    
    WeaponTuning["UMP45"].interval := 9
    WeaponTuning["UMP45"].firstShotKick := 1.18
    WeaponTuning["UMP45"].firstShotTime := 120
    WeaponTuning["UMP45"].smoothFactor := 0.48
    
    WeaponTuning["Vector"].interval := 8
    WeaponTuning["Vector"].firstShotKick := 1.22
    WeaponTuning["Vector"].firstShotTime := 125
    WeaponTuning["Vector"].smoothFactor := 0.52
    
    WeaponTuning["Micro UZI"].interval := 8
    WeaponTuning["Micro UZI"].firstShotKick := 1.16
    WeaponTuning["Micro UZI"].firstShotTime := 115
    WeaponTuning["Micro UZI"].smoothFactor := 0.50
    
    WeaponTuning["MP5K"].interval := 8
    WeaponTuning["MP5K"].firstShotKick := 1.20
    WeaponTuning["MP5K"].firstShotTime := 122
    WeaponTuning["MP5K"].smoothFactor := 0.50
    
    WeaponTuning["PP-19 Bizon"].interval := 9
    WeaponTuning["PP-19 Bizon"].firstShotKick := 1.17
    WeaponTuning["PP-19 Bizon"].firstShotTime := 118
    WeaponTuning["PP-19 Bizon"].smoothFactor := 0.48
    
    WeaponTuning["Tommy Gun"].interval := 9
    WeaponTuning["Tommy Gun"].firstShotKick := 1.21
    WeaponTuning["Tommy Gun"].firstShotTime := 124
    WeaponTuning["Tommy Gun"].smoothFactor := 0.50
    
    WeaponTuning["P90"].interval := 8
    WeaponTuning["P90"].firstShotKick := 1.15
    WeaponTuning["P90"].firstShotTime := 112
    WeaponTuning["P90"].smoothFactor := 0.48
    
    WeaponTuning["JS9"].interval := 8
    WeaponTuning["JS9"].firstShotKick := 1.18
    WeaponTuning["JS9"].firstShotTime := 120
    WeaponTuning["JS9"].smoothFactor := 0.50
    
    WeaponTuning["MP9"].interval := 8
    WeaponTuning["MP9"].firstShotKick := 1.14
    WeaponTuning["MP9"].firstShotTime := 110
    WeaponTuning["MP9"].smoothFactor := 0.48
    
    WeaponTuning["VSS"].interval := 9
    WeaponTuning["VSS"].firstShotKick := 1.12
    WeaponTuning["VSS"].firstShotTime := 110
    WeaponTuning["VSS"].dmrInterval := 85
    WeaponTuning["VSS"].smoothFactor := 0.45
    
    WeaponTuning["DP-28"].interval := 8
    WeaponTuning["DP-28"].firstShotKick := 1.32
    WeaponTuning["DP-28"].firstShotTime := 155
    WeaponTuning["DP-28"].smoothFactor := 0.60
    
    WeaponTuning["M249"].interval := 7
    WeaponTuning["M249"].firstShotKick := 1.40
    WeaponTuning["M249"].firstShotTime := 165
    WeaponTuning["M249"].smoothFactor := 0.65
    
    WeaponTuning["MG3"].interval := 7
    WeaponTuning["MG3"].firstShotKick := 1.45
    WeaponTuning["MG3"].firstShotTime := 172
    WeaponTuning["MG3"].smoothFactor := 0.65
    
    WeaponTuning["Mini-14"].interval := 9
    WeaponTuning["Mini-14"].firstShotKick := 1.15
    WeaponTuning["Mini-14"].firstShotTime := 120
    WeaponTuning["Mini-14"].dmrInterval := 100
    WeaponTuning["Mini-14"].smoothFactor := 0.45
    
    WeaponTuning["SLR"].interval := 10
    WeaponTuning["SLR"].firstShotKick := 1.25
    WeaponTuning["SLR"].firstShotTime := 140
    WeaponTuning["SLR"].dmrInterval := 160
    WeaponTuning["SLR"].smoothFactor := 0.42
    
    WeaponTuning["SKS"].interval := 10
    WeaponTuning["SKS"].firstShotKick := 1.22
    WeaponTuning["SKS"].firstShotTime := 135
    WeaponTuning["SKS"].dmrInterval := 160
    WeaponTuning["SKS"].smoothFactor := 0.42
    
    WeaponTuning["Mk12"].interval := 9
    WeaponTuning["Mk12"].firstShotKick := 1.18
    WeaponTuning["Mk12"].firstShotTime := 125
    WeaponTuning["Mk12"].dmrInterval := 110
    WeaponTuning["Mk12"].smoothFactor := 0.45
    
    WeaponTuning["Mk14"].interval := 9
    WeaponTuning["Mk14"].firstShotKick := 1.28
    WeaponTuning["Mk14"].firstShotTime := 135
    WeaponTuning["Mk14"].dmrInterval := 85
    WeaponTuning["Mk14"].smoothFactor := 0.48
    
    WeaponTuning["QBU"].interval := 9
    WeaponTuning["QBU"].firstShotKick := 1.14
    WeaponTuning["QBU"].firstShotTime := 118
    WeaponTuning["QBU"].dmrInterval := 110
    WeaponTuning["QBU"].smoothFactor := 0.45
    
    WeaponTuning["Dragunov"].interval := 10
    WeaponTuning["Dragunov"].firstShotKick := 1.24
    WeaponTuning["Dragunov"].firstShotTime := 138
    WeaponTuning["Dragunov"].dmrInterval := 155
    WeaponTuning["Dragunov"].smoothFactor := 0.42
    
    WeaponTuning["M110"].interval := 10
    WeaponTuning["M110"].firstShotKick := 1.22
    WeaponTuning["M110"].firstShotTime := 135
    WeaponTuning["M110"].dmrInterval := 145
    WeaponTuning["M110"].smoothFactor := 0.42
}

; F7/F8 — калибровка профиля, сохраняет на диск
AdjustCurrentScopeRecoil(delta) {
    global CurrentWeapon, CurrentScope, WeaponProfiles, ManualAdjust, RecoilMin, RecoilMax
    wp := WeaponProfiles[CurrentWeapon]
    if (wp.scopes[CurrentScope] == 0.0) {
        wp.scopes[CurrentScope] := RecoilMin
    }
    oldVal := wp.scopes[CurrentScope]
    newVal := Round(oldVal + delta, 1)
    if (newVal < RecoilMin)
        newVal := RecoilMin
    if (newVal > RecoilMax)
        newVal := RecoilMax
    if (newVal == oldVal)
        return false

    wp.scopes[CurrentScope] := newVal
    ManualAdjust := 0.0
    ApplyWeaponProfile()
    SaveCurrentWeaponToIni()
    return true
}

; ✅ Home/Delete: временная поправка через ManualAdjust — не меняет профиль,
; сбрасывается автоматически при смене оружия / перезапуске макроса
AdjustManualRecoil(delta) {
    global ManualAdjust, RecoilStrength, RecoilMin, RecoilMax
    oldStrength := RecoilStrength
    newStrength := Round(RecoilStrength + delta, 1)
    if (newStrength < RecoilMin)
        newStrength := RecoilMin
    if (newStrength > RecoilMax)
        newStrength := RecoilMax
    if (newStrength == oldStrength)
        return false
    ManualAdjust := Round(ManualAdjust + (newStrength - oldStrength), 1)
    ApplyWeaponProfile()
    return true
}

AdjustCurrentWeaponInterval(delta) {
    global CurrentWeapon, WeaponProfiles, WeaponTuning, IntervalMin, IntervalMax
    wp := WeaponProfiles[CurrentWeapon]
    if (!WeaponTuning.Has(wp.name))
        return false
    tuning := WeaponTuning[wp.name]
    oldVal := tuning.interval
    newVal := oldVal + delta
    if (newVal < IntervalMin)
        newVal := IntervalMin
    if (newVal > IntervalMax)
        newVal := IntervalMax
    if (newVal == oldVal)
        return false
    tuning.interval := newVal
    ApplyWeaponProfile()
    RestartSprayTimersIfActive()
    SaveCurrentWeaponToIni()  ; ✅ ИСПРАВЛЕНО: только текущее оружие
    return true
}

AdjustCurrentFirstShotKick(delta) {
    global CurrentWeapon, WeaponProfiles, WeaponTuning, FirstShotKickMin, FirstShotKickMax
    wp := WeaponProfiles[CurrentWeapon]
    if (!WeaponTuning.Has(wp.name))
        return false
    tuning := WeaponTuning[wp.name]
    oldVal := tuning.firstShotKick
    newVal := Round(oldVal + delta, 2)
    if (newVal < FirstShotKickMin)
        newVal := FirstShotKickMin
    if (newVal > FirstShotKickMax)
        newVal := FirstShotKickMax
    if (newVal == oldVal)
        return false
    tuning.firstShotKick := newVal
    ApplyWeaponProfile()
    SaveCurrentWeaponToIni()  ; ✅ ИСПРАВЛЕНО: только текущее оружие
    return true
}

AdjustCurrentFirstShotTime(delta) {
    global CurrentWeapon, WeaponProfiles, WeaponTuning, FirstShotTimeMin, FirstShotTimeMax
    wp := WeaponProfiles[CurrentWeapon]
    if (!WeaponTuning.Has(wp.name))
        return false
    tuning := WeaponTuning[wp.name]
    oldVal := tuning.firstShotTime
    newVal := oldVal + delta
    if (newVal < FirstShotTimeMin)
        newVal := FirstShotTimeMin
    if (newVal > FirstShotTimeMax)
        newVal := FirstShotTimeMax
    if (newVal == oldVal)
        return false
    tuning.firstShotTime := newVal
    ApplyWeaponProfile()
    SaveCurrentWeaponToIni()  ; ✅ ИСПРАВЛЕНО: только текущее оружие
    return true
}

AdjustCurrentDmrInterval(delta) {
    global CurrentWeapon, WeaponProfiles, WeaponTuning, DmrIntervalMin, DmrIntervalMax, IsSpraying
    wp := WeaponProfiles[CurrentWeapon]
    if (!WeaponTuning.Has(wp.name))
        return false
    tuning := WeaponTuning[wp.name]
    if (!tuning.HasOwnProp("dmrInterval"))
        return false
    oldVal := tuning.dmrInterval
    newVal := oldVal + delta
    if (newVal < DmrIntervalMin)
        newVal := DmrIntervalMin
    if (newVal > DmrIntervalMax)
        newVal := DmrIntervalMax
    if (newVal == oldVal)
        return false
    tuning.dmrInterval := newVal
    if (IsSpraying && IsDMRActive())
        SetTimer(AutoFire, GetAutoFireInterval())
    ApplyWeaponProfile()
    SaveCurrentWeaponToIni()
    return true
}

AdjustCurrentSmoothFactor(delta) {
    global CurrentWeapon, WeaponProfiles, WeaponTuning, SmoothFactorMin, SmoothFactorMax, RecoilSmoothFactor
    wp := WeaponProfiles[CurrentWeapon]
    if (!WeaponTuning.Has(wp.name))
        return false
    tuning := WeaponTuning[wp.name]
    if (!tuning.HasOwnProp("smoothFactor"))
        return false
    oldVal := tuning.smoothFactor
    newVal := Round(oldVal + delta, 2)
    if (newVal < SmoothFactorMin)
        newVal := SmoothFactorMin
    if (newVal > SmoothFactorMax)
        newVal := SmoothFactorMax
    if (newVal == oldVal)
        return false
    tuning.smoothFactor := newVal
    RecoilSmoothFactor  := newVal
    SaveCurrentWeaponToIni()
    return true
}

CycleCalibrationTarget() {
    global CalibTargetIndex, CalibTargetNames
    loop CalibTargetNames.Length {
        CalibTargetIndex := CalibTargetIndex >= CalibTargetNames.Length ? 1 : CalibTargetIndex + 1
        if (CalibTargetIndex != 5 || WeaponHasDmrInterval())
            break
    }
    UpdateOverlay()
}

AdjustCalibrationValue(direction) {
    global CalibTargetIndex
    switch CalibTargetIndex {
        case 1:
            return AdjustCurrentScopeRecoil(direction * 0.1)
        case 2:
            return AdjustCurrentWeaponInterval(direction)
        case 3:
            return AdjustCurrentFirstShotKick(direction * 0.02)
        case 4:
            return AdjustCurrentFirstShotTime(direction * 5)
        case 5:
            return AdjustCurrentDmrInterval(direction * 5)
        case 6:
            return AdjustCurrentSmoothFactor(direction * 0.05)
    }
    return false
}

CalibrationKeyDown(direction) {
    ; ✅ ИСПРАВЛЕНО: убрана мёртвая проверка MacroEnabled (хоткеи уже под #HotIf MacroEnabled)
    if AdjustCalibrationValue(direction)
        SoundBeep(direction > 0 ? 930 : 650, 45)
    else
        SoundBeep(380, 80)
}

SetOverlayFont(ctrl, color := "FFFFFF") {
    ctrl.SetFont("s9 c" color, "Segoe UI")
}

MeasureOverlayTextWidth(text) {
    static measureGui := 0, measureCtrl := 0
    if (!measureGui) {
        measureGui := Gui("-Caption +ToolWindow")
        measureGui.SetFont("s9", "Segoe UI")
        measureCtrl := measureGui.Add("Text", , "")
    }
    measureCtrl.Value := text
    measureCtrl.GetPos(, , &w)
    return Max(w, StrLen(text) * 7) + 10
}

; Прозрачность фона: 0 = полностью прозрачно, 255 = без прозрачности (140 ≈ 45% прозрачности)
global OverlayAlpha := 140

ApplyOverlayChrome() {
    global RecoilGui, OverlayAlpha
    if (!RecoilGui)
        return
    WinSetTransparent(OverlayAlpha, RecoilGui)
}

LayoutOverlay() {
    global RecoilGui, OverlayHeight
    global CtrlStatus, CtrlDiv1, CtrlWeapon, CtrlDiv2, CtrlRecoil, CtrlDiv3, CtrlStance, CtrlDiv4, CtrlCalib
    if (!RecoilGui)
        return
    gap := 4
    padLeft := 8
    padRight := 18
    textY := 3
    textH := OverlayHeight - 4
    x := padLeft
    for ctrl in [CtrlStatus, CtrlDiv1, CtrlWeapon, CtrlDiv2, CtrlRecoil, CtrlDiv3, CtrlStance, CtrlDiv4, CtrlCalib] {
        w := MeasureOverlayTextWidth(ctrl.Value)
        ctrl.Move(x, textY, w, textH)
        x += w + gap
    }
    totalW := x - gap + padRight
    RecoilGui.GetPos(, &gy)
    RecoilGui.Show("x" (A_ScreenWidth - totalW - 10) " y" gy " w" totalW " h" OverlayHeight " NoActivate")
    ApplyOverlayChrome()
}

global OverlayHeight := 22
global RecoilGui := Gui("+AlwaysOnTop -Caption +ToolWindow +E0x20 +E0x08000000")
RecoilGui.BackColor := "0A0A0A"
global CtrlStatus := RecoilGui.Add("Text", "x6 y3", "● OFF")
global CtrlDiv1   := RecoilGui.Add("Text", "x+3 y3", "|")
global CtrlWeapon := RecoilGui.Add("Text", "x+3 y3", "M416 (1x)")
global CtrlDiv2   := RecoilGui.Add("Text", "x+3 y3", "|")
global CtrlRecoil := RecoilGui.Add("Text", "x+3 y3", "R:1.9")
global CtrlDiv3   := RecoilGui.Add("Text", "x+3 y3", "|")
global CtrlStance := RecoilGui.Add("Text", "x+3 y3", "STAND")
global CtrlDiv4   := RecoilGui.Add("Text", "x+3 y3", "|")
global CtrlCalib  := RecoilGui.Add("Text", "x+3 y3", "CAL:RCL=1.9")
SetOverlayFont(CtrlStatus, "66FF66")
SetOverlayFont(CtrlDiv1, "B0B0B0")
SetOverlayFont(CtrlWeapon, "FFFFFF")
SetOverlayFont(CtrlDiv2, "B0B0B0")
SetOverlayFont(CtrlRecoil, "80FFFF")
SetOverlayFont(CtrlDiv3, "B0B0B0")
SetOverlayFont(CtrlStance, "66FF66")
SetOverlayFont(CtrlDiv4, "B0B0B0")
SetOverlayFont(CtrlCalib, "FFD54F")
RecoilGui.Show("x" (A_ScreenWidth - 200) " y6 w1 h" OverlayHeight " NoActivate")
ApplyOverlayChrome()
SetTimer(KeepOverlayOnTop, 1000)
LoadProfilesFromIni()
ValidateWeaponData()
ApplyWeaponProfile()
EnsureIniWeaponSections()
SetTimer(LayoutOverlay, -1)

IsGameActive() {
    return WinActive("ahk_exe TslGame.exe")
}

IsDMRActive() {
    global CurrentWeapon, WeaponProfiles, WeaponTuning
    wp := WeaponProfiles[CurrentWeapon]
    if (WeaponTuning.Has(wp.name)) {
        tuning := WeaponTuning[wp.name]
        return tuning.HasOwnProp("isDMR") && tuning.isDMR
    }
    return false
}

WeaponHasDmrInterval(weaponName := "") {
    global CurrentWeapon, WeaponProfiles, WeaponTuning
    if (weaponName = "")
        weaponName := WeaponProfiles[CurrentWeapon].name
    if (!WeaponTuning.Has(weaponName))
        return false
    return WeaponTuning[weaponName].HasOwnProp("dmrInterval")
}

GetWeaponDmrInterval() {
    global CurrentWeapon, WeaponProfiles, WeaponTuning
    wp := WeaponProfiles[CurrentWeapon]
    if (WeaponTuning.Has(wp.name)) {
        tuning := WeaponTuning[wp.name]
        if (tuning.HasOwnProp("dmrInterval"))
            return tuning.dmrInterval
    }
    return 0
}

; Только RMP перехватывает ЛКМ; DMR стреляет через ~LButton + AutoFire
IsRmpLButtonMode() {
    global LButtonToXButton2
    return LButtonToXButton2
}

RestartSprayTimersIfActive() {
    global IsSpraying, RecoilInterval
    if (!IsSpraying)
        return
    SetTimer(ApplyRecoil, RecoilInterval)
    if (IsDMRActive())
        SetTimer(AutoFire, GetAutoFireInterval())
}

GetAutoFireInterval() {
    global CurrentWeapon, WeaponProfiles, WeaponTuning
    wp := WeaponProfiles[CurrentWeapon]
    if (WeaponTuning.Has(wp.name)) {
        tuning := WeaponTuning[wp.name]
        if (tuning.HasOwnProp("dmrInterval"))
            return tuning.dmrInterval
    }
    return 40
}

IsCursorVisible() {
    structSize := 16 + A_PtrSize
    buf := Buffer(structSize, 0)
    NumPut("UInt", structSize, buf, 0)
    if DllCall("GetCursorInfo", "Ptr", buf) {
        flags := NumGet(buf, 4, "UInt")
        return (flags & 0x1) != 0
    }
    return false
}

KeepOverlayOnTop() {
    global MacroEnabled, RecoilGui
    if (MacroEnabled && RecoilGui)
        try DllCall("SetWindowPos", "Ptr", RecoilGui.Hwnd, "Ptr", -1, "Int", 0, "Int", 0, "Int", 0, "Int", 0, "UInt", 0x0013)
}

UpdateOverlay() {
    global RecoilStrength, LButtonToXButton2, CurrentWeapon, CurrentScope
    global WeaponProfiles, ScopeNames, RecoilInterval, FirstShotKick, FirstShotTime, RecoilSmoothFactor
    global CalibTargetIndex, CalibTargetNames, PlayerStance, MacroEnabled
    global CtrlStatus, CtrlWeapon, CtrlRecoil, CtrlStance, CtrlCalib, RecoilGui
    if (!RecoilGui)
        return
        
    wp := WeaponProfiles[CurrentWeapon]
    
    ; 1. Статус макроса
    if (MacroEnabled) {
        SetOverlayFont(CtrlStatus, "66FF66")
        CtrlStatus.Value := "● ON"
    } else {
        SetOverlayFont(CtrlStatus, "FF5555")
        CtrlStatus.Value := "● OFF"
    }
    
    ; 2. Выбранное оружие и прицел
    dispWeapon := wp.name " (" ScopeNames[CurrentScope] ")"
    if (IsDMRActive())
        dispWeapon .= " [DMR]"
    else if (LButtonToXButton2)
        dispWeapon .= " [RMP]"
    CtrlWeapon.Value := dispWeapon
    
    ; 3. Текущая сила отдачи
    CtrlRecoil.Value := "R:" Format("{:.1f}", RecoilStrength)
    
    ; 4. Положение (Stance)
    CtrlStance.Value := PlayerStance
    if (PlayerStance == "STAND") {
        SetOverlayFont(CtrlStance, "66FF66")
    } else if (PlayerStance == "CROUCH") {
        SetOverlayFont(CtrlStance, "FFAA33")
    } else if (PlayerStance == "PRONE") {
        SetOverlayFont(CtrlStance, "FF5555")
    }
    
    ; 5. Параметры калибровки
    switch CalibTargetIndex {
        case 1:
            calibVal := Format("{:.1f}", RecoilStrength)
        case 2:
            calibVal := RecoilInterval
        case 3:
            calibVal := Format("{:.2f}", FirstShotKick)
        case 4:
            calibVal := FirstShotTime
        case 5:
            calibVal := WeaponHasDmrInterval(wp.name) ? GetWeaponDmrInterval() : "n/a"
        case 6:
            calibVal := Format("{:.2f}", RecoilSmoothFactor)
    }
    CtrlCalib.Value := "CAL:" CalibTargetNames[CalibTargetIndex] "=" calibVal
    LayoutOverlay()
}

; ══════════════════════════════════════════════════════════════════[...]
; ЛОГИКА КОМПЕНСАЦИИ
; ══════════════════════════════════════════════════════════════════[...]

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

; ══════════════════════════════════════════════════════════════════[...]
; ХОТКЕИ — ГЛОБАЛЬНЫЕ
; ══════════════════════════════════════════════════════════════════[...]

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

; F12 - Сброс всех настроек по умолчанию
F12::ResetAllSettingsToDefaults()

; Калибровка: $ + UseHook — клавиши не уходят в игру, работают в PUBG
#InputLevel 1
#HotIf MacroEnabled
#UseHook
