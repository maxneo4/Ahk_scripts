TimeOSDInit() {
    global TimeOSDLabel
    SetTimer, TimeOSDPulse, 1000
    Gui, TimeOSD:Default
    Gui, +LastFound +AlwaysOnTop +ToolWindow -Caption
    Gui, Font, s18, Calibri
    Gui, Margin, 0, 0
    Gui, Add, Text, cWhite vTimeOSDLabel gTimeOSDClose w250 h36 Center
}

TimeOSDPulse() {
    static lastTime := ""

    ;~ if (IsFunc("IsWindowFullScreen") && IsWindowFullScreen("A"))
        ;~ Return ; Call to nonexistent function.

    FormatTime, currTime, , h:mm tt

    if (lastTime == currTime || A_TimeIdlePhysical > 600000)
        Return

    if (RegExMatch(currTime, ":00"))
        TimeOSDShow(currTime, "268BD2")
    else if (RegExMatch(currTime, ":20"))
        TimeOSDShow(currTime, "859900")
    else if (RegExMatch(currTime, ":40"))
        TimeOSDShow(currTime, "CB4B16")

    lastTime := currTime
}

TimeOSDShow(timeText, bg) {
    Gui, TimeOSD:Default
    Gui, Color, %bg%
    GuiControl, Text, TimeOSDLabel, It's %timeText% already!
    y := A_ScreenHeight - 120
    Gui, Show, xCenter y%y% NoActivate
    SetTimer, TimeOSDClose, -10000
}

TimeOSDClose() {
    Gui, TimeOSD:Cancel
}
