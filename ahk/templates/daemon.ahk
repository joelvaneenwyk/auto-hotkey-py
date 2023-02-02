#NoEnv
#Persistent
#SingleInstance Off

; BEGIN user-defined directives

{% for directive in directives %}
{{ directive }}

{% endfor %}

; END user-defined directives


{% for tom, name in message_types.items() %}
{{ name }} := "{{ tom }}"
{% endfor %}


NOVALUE_SENTINEL := Chr(57344)

FormatResponse(MessageType, payload) {
    newline_count := CountNewlines(payload)
    response := Format("{}`n{}`n{}`n", MessageType, newline_count, payload)
    return response
}

FormatNoValueResponse() {
    global NOVALUE_SENTINEL
    global NOVALUERESPONSEMESSAGE
    return FormatResponse(NOVALUERESPONSEMESSAGE, NOVALUE_SENTINEL)
}

AHKSetDetectHiddenWindows(ByRef command) {
    value := command[2]
    DetectHiddenWindows, %value%
    return FormatNoValueResponse()
}

AHKSetTitleMatchMode(ByRef command) {
    val1 := command[2]
    val2 := command[3]
    if (val1 != "") {
        SetTitleMatchMode, %val1%
    }
    if (val2 != "") {
        SetTitleMatchMode, %val2%
    }
    return FormatNoValueResponse()
}

AHKGetTitleMatchMode(ByRef command) {
    global STRINGRESPONSEMESSAGE
    return FormatResponse(STRINGRESPONSEMESSAGE, A_TitleMatchMode)
}

AHKGetTitleMatchSpeed(ByRef command) {
    global STRINGRESPONSEMESSAGE
    return FormatResponse(STRINGRESPONSEMESSAGE, A_TitleMatchModeSpeed)
}

AHKSetSendLevel(ByRef command) {
    level := command[2]
    SendLevel, %level%
    return FormatNoValueResponse()
}

AHKGetSendLevel(ByRef command) {
    global INTEGERRESPONSEMESSAGE
    return FormatResponse(INTEGERRESPONSEMESSAGE, A_SendLevel)
}

AHKWinExist(ByRef command) {
    global BOOLEANRESPONSEMESSAGE
    title := command[2]
    text := command[3]
    extitle := command[4]
    extext := command[5]
    detect_hw := command[6]
    match_mode := command[7]
    match_speed := command[8]

    current_match_mode := Format("{}", A_TitleMatchMode)
    current_match_speed := Format("{}", A_TitleMatchModeSpeed)
    if (match_mode != "") {
        SetTitleMatchMode, %match_mode%
    }
    if (match_speed != "") {
        SetTitleMatchMode, %match_speed%
    }

    current_detect_hw := Format("{}", A_DetectHiddenWindows)

    if (detect_hw != "") {
        DetectHiddenWindows, %detect_hw%
    }

    if WinExist(title, text, extitle, extext) {
        resp := FormatResponse(BOOLEANRESPONSEMESSAGE, 1)
    } else {
        resp := FormatResponse(BOOLEANRESPONSEMESSAGE, 0)
    }

    DetectHiddenWindows, %current_detect_hw%
    SetTitleMatchMode, %current_match_mode%
    SetTitleMatchMode, %current_match_speed%

    return resp
}

AHKWinClose(ByRef command) {
    title := command[2]
    text := command[3]
    extitle := command[4]
    extext := command[5]
    detect_hw := command[6]
    match_mode := command[7]
    match_speed := command[8]
    secondstowait := command[9]

    current_match_mode := Format("{}", A_TitleMatchMode)
    current_match_speed := Format("{}", A_TitleMatchModeSpeed)
    if (match_mode != "") {
        SetTitleMatchMode, %match_mode%
    }
    if (match_speed != "") {
        SetTitleMatchMode, %match_speed%
    }
    current_detect_hw := Format("{}", A_DetectHiddenWindows)

    if (detect_hw != "") {
        DetectHiddenWindows, %detect_hw%
    }

    DetectHiddenWindows, %current_detect_hw%
    SetTitleMatchMode, %current_match_mode%
    SetTitleMatchMode, %current_match_speed%

    WinClose, %title%, %text%, %secondstowait%, %extitle%, %extext%

    return FormatNoValueResponse()
}

AHKWinKill(ByRef command) {
    title := command[2]
    text := command[3]
    extitle := command[4]
    extext := command[5]
    detect_hw := command[6]
    match_mode := command[7]
    match_speed := command[8]
    secondstowait := command[9]

    current_match_mode := Format("{}", A_TitleMatchMode)
    current_match_speed := Format("{}", A_TitleMatchModeSpeed)
    if (match_mode != "") {
        SetTitleMatchMode, %match_mode%
    }
    if (match_speed != "") {
        SetTitleMatchMode, %match_speed%
    }
    current_detect_hw := Format("{}", A_DetectHiddenWindows)

    if (detect_hw != "") {
        DetectHiddenWindows, %detect_hw%
    }


    WinKill, %title%, %text%, %secondstowait%, %extitle%, %extext%

    DetectHiddenWindows, %current_detect_hw%
    SetTitleMatchMode, %current_match_mode%
    SetTitleMatchMode, %current_match_speed%

    return FormatNoValueResponse()
}

AHKWinWait(ByRef command) {
    global WINDOWRESPONSEMESSAGE
    global TIMEOUTRESPONSEMESSAGE

    title := command[2]
    text := command[3]
    extitle := command[4]
    extext := command[5]
    detect_hw := command[6]
    match_mode := command[7]
    match_speed := command[8]
    timeout := command[9]
    current_match_mode := Format("{}", A_TitleMatchMode)
    current_match_speed := Format("{}", A_TitleMatchModeSpeed)
    if (match_mode != "") {
        SetTitleMatchMode, %match_mode%
    }
    if (match_speed != "") {
        SetTitleMatchMode, %match_speed%
    }
    current_detect_hw := Format("{}", A_DetectHiddenWindows)

    if (detect_hw != "") {
        DetectHiddenWindows, %detect_hw%
    }
    if (timeout != "") {
        WinWait, %title%, %text%, %timeout%, %extitle%, %extext%
    } else {
        WinWait, %title%, %text%,, %extitle%, %extext%
    }
    if (ErrorLevel = 1) {
        resp := FormatResponse(TIMEOUTRESPONSEMESSAGE, "WinWait timed out waiting for window")
    } else {
        WinGet, output, ID
        resp := FormatResponse(WINDOWRESPONSEMESSAGE, output)
    }

    DetectHiddenWindows, %current_detect_hw%
    SetTitleMatchMode, %current_match_mode%
    SetTitleMatchMode, %current_match_speed%

    return resp
}


AHKWinWaitActive(ByRef command) {
    global WINDOWRESPONSEMESSAGE
    global TIMEOUTRESPONSEMESSAGE

    title := command[2]
    text := command[3]
    extitle := command[4]
    extext := command[5]
    detect_hw := command[6]
    match_mode := command[7]
    match_speed := command[8]
    timeout := command[9]
    current_match_mode := Format("{}", A_TitleMatchMode)
    current_match_speed := Format("{}", A_TitleMatchModeSpeed)
    if (match_mode != "") {
        SetTitleMatchMode, %match_mode%
    }
    if (match_speed != "") {
        SetTitleMatchMode, %match_speed%
    }
    current_detect_hw := Format("{}", A_DetectHiddenWindows)

    if (detect_hw != "") {
        DetectHiddenWindows, %detect_hw%
    }
    if (timeout != "") {
        WinWaitActive, %title%, %text%, %timeout%, %extitle%, %extext%
    } else {
        WinWaitActive, %title%, %text%,, %extitle%, %extext%
    }
    if (ErrorLevel = 1) {
        resp := FormatResponse(TIMEOUTRESPONSEMESSAGE, "WinWait timed out waiting for window")
    } else {
        WinGet, output, ID
        resp := FormatResponse(WINDOWRESPONSEMESSAGE, output)
    }

    DetectHiddenWindows, %current_detect_hw%
    SetTitleMatchMode, %current_match_mode%
    SetTitleMatchMode, %current_match_speed%

    return resp
}


AHKWinWaitNotActive(ByRef command) {
    global WINDOWRESPONSEMESSAGE
    global TIMEOUTRESPONSEMESSAGE

    title := command[2]
    text := command[3]
    extitle := command[4]
    extext := command[5]
    detect_hw := command[6]
    match_mode := command[7]
    match_speed := command[8]
    timeout := command[9]
    current_match_mode := Format("{}", A_TitleMatchMode)
    current_match_speed := Format("{}", A_TitleMatchModeSpeed)
    if (match_mode != "") {
        SetTitleMatchMode, %match_mode%
    }
    if (match_speed != "") {
        SetTitleMatchMode, %match_speed%
    }
    current_detect_hw := Format("{}", A_DetectHiddenWindows)

    if (detect_hw != "") {
        DetectHiddenWindows, %detect_hw%
    }
    if (timeout != "") {
        WinWaitNotActive, %title%, %text%, %timeout%, %extitle%, %extext%
    } else {
        WinWaitNotActive, %title%, %text%,, %extitle%, %extext%
    }
    if (ErrorLevel = 1) {
        resp := FormatResponse(TIMEOUTRESPONSEMESSAGE, "WinWait timed out waiting for window")
    } else {
        WinGet, output, ID
        resp := FormatResponse(WINDOWRESPONSEMESSAGE, output)
    }

    DetectHiddenWindows, %current_detect_hw%
    SetTitleMatchMode, %current_match_mode%
    SetTitleMatchMode, %current_match_speed%

    return resp
}



AHKWinMinimize(ByRef command) {
    title := command[2]
    text := command[3]
    extitle := command[4]
    extext := command[5]
    detect_hw := command[6]
    match_mode := command[7]
    match_speed := command[8]


    current_match_mode := Format("{}", A_TitleMatchMode)
    current_match_speed := Format("{}", A_TitleMatchModeSpeed)
    if (match_mode != "") {
        SetTitleMatchMode, %match_mode%
    }
    if (match_speed != "") {
        SetTitleMatchMode, %match_speed%
    }
    current_detect_hw := Format("{}", A_DetectHiddenWindows)

    if (detect_hw != "") {
        DetectHiddenWindows, %detect_hw%
    }


    WinMinimize, %title%, %text%, %secondstowait%, %extitle%, %extext%

    DetectHiddenWindows, %current_detect_hw%
    SetTitleMatchMode, %current_match_mode%
    SetTitleMatchMode, %current_match_speed%

    return FormatNoValueResponse()
}

AHKWinMaximize(ByRef command) {
    title := command[2]
    text := command[3]
    extitle := command[4]
    extext := command[5]
    detect_hw := command[6]
    match_mode := command[7]
    match_speed := command[8]

    current_match_mode := Format("{}", A_TitleMatchMode)
    current_match_speed := Format("{}", A_TitleMatchModeSpeed)
    if (match_mode != "") {
        SetTitleMatchMode, %match_mode%
    }
    if (match_speed != "") {
        SetTitleMatchMode, %match_speed%
    }
    current_detect_hw := Format("{}", A_DetectHiddenWindows)

    if (detect_hw != "") {
        DetectHiddenWindows, %detect_hw%
    }


    WinMaximize, %title%, %text%, %secondstowait%, %extitle%, %extext%

    DetectHiddenWindows, %current_detect_hw%
    SetTitleMatchMode, %current_match_mode%
    SetTitleMatchMode, %current_match_speed%

    return FormatNoValueResponse()
}

AHKWinRestore(ByRef command) {
    title := command[2]
    text := command[3]
    extitle := command[4]
    extext := command[5]
    detect_hw := command[6]
    match_mode := command[7]
    match_speed := command[8]


    current_match_mode := Format("{}", A_TitleMatchMode)
    current_match_speed := Format("{}", A_TitleMatchModeSpeed)
    if (match_mode != "") {
        SetTitleMatchMode, %match_mode%
    }
    if (match_speed != "") {
        SetTitleMatchMode, %match_speed%
    }
    current_detect_hw := Format("{}", A_DetectHiddenWindows)

    if (detect_hw != "") {
        DetectHiddenWindows, %detect_hw%
    }


    WinRestore, %title%, %text%, %secondstowait%, %extitle%, %extext%

    DetectHiddenWindows, %current_detect_hw%
    SetTitleMatchMode, %current_match_mode%
    SetTitleMatchMode, %current_match_speed%

    return FormatNoValueResponse()
}

AHKWinIsActive(ByRef command) {
    global BOOLEANRESPONSEMESSAGE
    title := command[2]
    text := command[3]
    extitle := command[4]
    extext := command[5]
    detect_hw := command[6]
    match_mode := command[7]
    match_speed := command[8]
        current_match_mode := Format("{}", A_TitleMatchMode)
    current_match_speed := Format("{}", A_TitleMatchModeSpeed)
    if (match_mode != "") {
        SetTitleMatchMode, %match_mode%
    }
    if (match_speed != "") {
        SetTitleMatchMode, %match_speed%
    }

    current_detect_hw := Format("{}", A_DetectHiddenWindows)

    if (detect_hw != "") {
        DetectHiddenWindows, %detect_hw%
    }

    if WinActive(title, text, extitle, extext) {
        response := FormatResponse(BOOLEANRESPONSEMESSAGE, 1)
    } else {
        response := FormatResponse(BOOLEANRESPONSEMESSAGE, 0)
    }
    DetectHiddenWindows, %current_detect_hw%
    SetTitleMatchMode, %current_match_mode%
    SetTitleMatchMode, %current_match_speed%
    return response
}

AHKWinGetID(ByRef command) {
    global WINDOWRESPONSEMESSAGE
    title := command[2]
    text := command[3]
    extitle := command[4]
    extext := command[5]
    detect_hw := command[6]
    match_mode := command[7]
    match_speed := command[8]

    current_match_mode := Format("{}", A_TitleMatchMode)
    current_match_speed := Format("{}", A_TitleMatchModeSpeed)
    if (match_mode != "") {
        SetTitleMatchMode, %match_mode%
    }
    if (match_speed != "") {
        SetTitleMatchMode, %match_speed%
    }

    current_detect_hw := Format("{}", A_DetectHiddenWindows)

    if (detect_hw != "") {
        DetectHiddenWindows, %detect_hw%
    }

    WinGet, output, ID, %title%, %text%, %extitle%, %extext%
    if (output = 0 || output = "") {
        response := FormatNoValueResponse()
    } else {
        response := FormatResponse(WINDOWRESPONSEMESSAGE, output)
    }
    DetectHiddenWindows, %current_detect_hw%
    SetTitleMatchMode, %current_match_mode%
    SetTitleMatchMode, %current_match_speed%
    return response
}

AHKWinGetTitle(ByRef command) {
    global STRINGRESPONSEMESSAGE
    title := command[2]
    text := command[3]
    extitle := command[4]
    extext := command[5]
    detect_hw := command[6]
    match_mode := command[7]
    match_speed := command[8]

    current_match_mode := Format("{}", A_TitleMatchMode)
    current_match_speed := Format("{}", A_TitleMatchModeSpeed)
    if (match_mode != "") {
        SetTitleMatchMode, %match_mode%
    }
    if (match_speed != "") {
        SetTitleMatchMode, %match_speed%
    }

    current_detect_hw := Format("{}", A_DetectHiddenWindows)

    if (detect_hw != "") {
        DetectHiddenWindows, %detect_hw%
    }

    WinGetTitle, text, %title%, %text%, %extitle%, %extext%
    DetectHiddenWindows, %current_detect_hw%
    SetTitleMatchMode, %current_match_mode%
    SetTitleMatchMode, %current_match_speed%

    return FormatResponse(STRINGRESPONSEMESSAGE, text)
}

AHKWinGetIDLast(ByRef command) {
    global WINDOWRESPONSEMESSAGE
    title := command[2]
    text := command[3]
    extitle := command[4]
    extext := command[5]
    detect_hw := command[6]
    match_mode := command[7]
    match_speed := command[8]

    current_match_mode := Format("{}", A_TitleMatchMode)
    current_match_speed := Format("{}", A_TitleMatchModeSpeed)
    if (match_mode != "") {
        SetTitleMatchMode, %match_mode%
    }
    if (match_speed != "") {
        SetTitleMatchMode, %match_speed%
    }

    current_detect_hw := Format("{}", A_DetectHiddenWindows)

    if (detect_hw != "") {
        DetectHiddenWindows, %detect_hw%
    }

    WinGet, output, IDLast, %title%, %text%, %extitle%, %extext%
    if (output = 0 || output = "") {
        response := FormatNoValueResponse()
    } else {
        response := FormatResponse(WINDOWRESPONSEMESSAGE, output)
    }
    DetectHiddenWindows, %current_detect_hw%
    SetTitleMatchMode, %current_match_mode%
    SetTitleMatchMode, %current_match_speed%
    return response
}


AHKWinGetPID(ByRef command) {
    global INTEGERRESPONSEMESSAGE
    title := command[2]
    text := command[3]
    extitle := command[4]
    extext := command[5]
    detect_hw := command[6]
    match_mode := command[7]
    match_speed := command[8]

    current_match_mode := Format("{}", A_TitleMatchMode)
    current_match_speed := Format("{}", A_TitleMatchModeSpeed)
    if (match_mode != "") {
        SetTitleMatchMode, %match_mode%
    }
    if (match_speed != "") {
        SetTitleMatchMode, %match_speed%
    }

    current_detect_hw := Format("{}", A_DetectHiddenWindows)

    if (detect_hw != "") {
        DetectHiddenWindows, %detect_hw%
    }

    WinGet, output, PID, %title%, %text%, %extitle%, %extext%
    if (output = 0 || output = "") {
        response := FormatNoValueResponse()
    } else {
        response := FormatResponse(INTEGERRESPONSEMESSAGE, output)
    }
    DetectHiddenWindows, %current_detect_hw%
    SetTitleMatchMode, %current_match_mode%
    SetTitleMatchMode, %current_match_speed%
    return response
}


AHKWinGetProcessName(ByRef command) {
    global STRINGRESPONSEMESSAGE
    title := command[2]
    text := command[3]
    extitle := command[4]
    extext := command[5]
    detect_hw := command[6]
    match_mode := command[7]
    match_speed := command[8]

    current_match_mode := Format("{}", A_TitleMatchMode)
    current_match_speed := Format("{}", A_TitleMatchModeSpeed)
if (match_mode != "") {
    SetTitleMatchMode, %match_mode%
}
if (match_speed != "") {
    SetTitleMatchMode, %match_speed%
}

    current_detect_hw := Format("{}", A_DetectHiddenWindows)

    if (detect_hw != "") {
        DetectHiddenWindows, %detect_hw%
    }

    WinGet, output, ProcessName, %title%, %text%, %extitle%, %extext%
    if (output = 0 || output = "") {
        response := FormatNoValueResponse()
    } else {
        response := FormatResponse(STRINGRESPONSEMESSAGE, output)
    }
    DetectHiddenWindows, %current_detect_hw%
    SetTitleMatchMode, %current_match_mode%
    SetTitleMatchMode, %current_match_speed%
    return response
}

AHKWinGetProcessPath(ByRef command) {
    global STRINGRESPONSEMESSAGE
    title := command[2]
    text := command[3]
    extitle := command[4]
    extext := command[5]
    detect_hw := command[6]
    match_mode := command[7]
    match_speed := command[8]

    current_match_mode := Format("{}", A_TitleMatchMode)
    current_match_speed := Format("{}", A_TitleMatchModeSpeed)
    if (match_mode != "") {
        SetTitleMatchMode, %match_mode%
    }
    if (match_speed != "") {
        SetTitleMatchMode, %match_speed%
    }

    current_detect_hw := Format("{}", A_DetectHiddenWindows)

    if (detect_hw != "") {
        DetectHiddenWindows, %detect_hw%
    }

    WinGet, output, ProcessPath, %title%, %text%, %extitle%, %extext%
    if (output = 0 || output = "") {
        response := FormatNoValueResponse()
    } else {
        response := FormatResponse(STRINGRESPONSEMESSAGE, output)
    }
    DetectHiddenWindows, %current_detect_hw%
    SetTitleMatchMode, %current_match_mode%
    SetTitleMatchMode, %current_match_speed%
    return response
}


AHKWinGetCount(ByRef command) {
    global INTEGERRESPONSEMESSAGE
    title := command[2]
    text := command[3]
    extitle := command[4]
    extext := command[5]
    detect_hw := command[6]
    match_mode := command[7]
    match_speed := command[8]

    current_match_mode := Format("{}", A_TitleMatchMode)
    current_match_speed := Format("{}", A_TitleMatchModeSpeed)
    if (match_mode != "") {
        SetTitleMatchMode, %match_mode%
    }
    if (match_speed != "") {
        SetTitleMatchMode, %match_speed%
    }

    current_detect_hw := Format("{}", A_DetectHiddenWindows)

    if (detect_hw != "") {
        DetectHiddenWindows, %detect_hw%
    }

    WinGet, output, Count, %title%, %text%, %extitle%, %extext%
    if (output = 0) {
        response := FormatResponse(INTEGERRESPONSEMESSAGE, output)
    } else {
        response := FormatResponse(INTEGERRESPONSEMESSAGE, output)
    }
    DetectHiddenWindows, %current_detect_hw%
    SetTitleMatchMode, %current_match_mode%
    SetTitleMatchMode, %current_match_speed%
    return response
}



AHKWinGetMinMax(ByRef command) {
    global INTEGERRESPONSEMESSAGE
    title := command[2]
    text := command[3]
    extitle := command[4]
    extext := command[5]
    detect_hw := command[6]
    match_mode := command[7]
    match_speed := command[8]

    current_match_mode := Format("{}", A_TitleMatchMode)
    current_match_speed := Format("{}", A_TitleMatchModeSpeed)
    if (match_mode != "") {
        SetTitleMatchMode, %match_mode%
    }
    if (match_speed != "") {
        SetTitleMatchMode, %match_speed%
    }

    current_detect_hw := Format("{}", A_DetectHiddenWindows)

    if (detect_hw != "") {
        DetectHiddenWindows, %detect_hw%
    }

    WinGet, output, MinMax, %title%, %text%, %extitle%, %extext%
    if (output = "") {
        response := FormatNoValueResponse()
    } else {
        response := FormatResponse(INTEGERRESPONSEMESSAGE, output)
    }
    DetectHiddenWindows, %current_detect_hw%
    SetTitleMatchMode, %current_match_mode%
    SetTitleMatchMode, %current_match_speed%
    return response
}

AHKWinGetControlList(ByRef command) {
    global EXCEPTIONRESPONSEMESSAGE
    global WINDOWCONTROLLISTRESPONSEMESSAGE
    title := command[2]
    text := command[3]
    extitle := command[4]
    extext := command[5]
    detect_hw := command[6]
    match_mode := command[7]
    match_speed := command[8]

    current_match_mode := Format("{}", A_TitleMatchMode)
    current_match_speed := Format("{}", A_TitleMatchModeSpeed)
    if (match_mode != "") {
        SetTitleMatchMode, %match_mode%
    }
    if (match_speed != "") {
        SetTitleMatchMode, %match_speed%
    }

    current_detect_hw := Format("{}", A_DetectHiddenWindows)

    if (detect_hw != "") {
        DetectHiddenWindows, %detect_hw%
    }


    WinGet, ahkid, ID, %title%, %text%, %extitle%, %extext%

    if (ahkid = "") {
        return FormatNoValueResponse()
    }

    WinGet, ctrList, ControlList, %title%, %text%, %extitle%, %extext%
    WinGet, ctrListID, ControlListHWND, %title%, %text%, %extitle%, %extext%

    if (ctrListID = "") {
        return FormatResponse(WINDOWCONTROLLISTRESPONSEMESSAGE, Format("('{}', [])", ahkid))
    }

    ctrListArr := StrSplit(ctrList, "`n")
    ctrListIDArr := StrSplit(ctrListID, "`n")
    if (ctrListArr.Length() != ctrListIDArr.Length()) {
        return FormatResponse(EXCEPTIONRESPONSEMESSAGE, "Control hwnd/class lists have unexpected lengths")
    }

    output := Format("('{}', [", ahkid)

    for index, hwnd in ctrListIDArr {
        classname := ctrListArr[index]
        output .= Format("('{}', '{}'), ", hwnd, classname)

    }
    output .= "])"
    response := FormatResponse(WINDOWCONTROLLISTRESPONSEMESSAGE, output)
    DetectHiddenWindows, %current_detect_hw%
    SetTitleMatchMode, %current_match_mode%
    SetTitleMatchMode, %current_match_speed%
    return response
}

AHKWinGetTransparent(ByRef command) {
    global INTEGERRESPONSEMESSAGE
    title := command[2]
    text := command[3]
    extitle := command[4]
    extext := command[5]
    detect_hw := command[6]
    match_mode := command[7]
    match_speed := command[8]

    current_match_mode := Format("{}", A_TitleMatchMode)
    current_match_speed := Format("{}", A_TitleMatchModeSpeed)
    if (match_mode != "") {
        SetTitleMatchMode, %match_mode%
    }
    if (match_speed != "") {
        SetTitleMatchMode, %match_speed%
    }

    current_detect_hw := Format("{}", A_DetectHiddenWindows)

    if (detect_hw != "") {
        DetectHiddenWindows, %detect_hw%
    }

    WinGet, output, Transparent, %title%, %text%, %extitle%, %extext%
    response := FormatResponse(INTEGERRESPONSEMESSAGE, output)
    DetectHiddenWindows, %current_detect_hw%
    SetTitleMatchMode, %current_match_mode%
    SetTitleMatchMode, %current_match_speed%
    return response
}
AHKWinGetTransColor(ByRef command) {
    global STRINGRESPONSEMESSAGE
    global INTEGERRESPONSEMESSAGE
    global NOVALUERESPONSEMESSAGE
    title := command[2]
    text := command[3]
    extitle := command[4]
    extext := command[5]
    detect_hw := command[6]
    match_mode := command[7]
    match_speed := command[8]

    current_match_mode := Format("{}", A_TitleMatchMode)
    current_match_speed := Format("{}", A_TitleMatchModeSpeed)
    if (match_mode != "") {
        SetTitleMatchMode, %match_mode%
    }
    if (match_speed != "") {
        SetTitleMatchMode, %match_speed%
    }

    current_detect_hw := Format("{}", A_DetectHiddenWindows)

    if (detect_hw != "") {
        DetectHiddenWindows, %detect_hw%
    }

    WinGet, output, TransColor, %title%, %text%, %extitle%, %extext%
    response := FormatResponse(NOVALUERESPONSEMESSAGE, output)
    DetectHiddenWindows, %current_detect_hw%
    SetTitleMatchMode, %current_match_mode%
    SetTitleMatchMode, %current_match_speed%
    return response
}
AHKWinGetStyle(ByRef command) {
    global STRINGRESPONSEMESSAGE
    global INTEGERRESPONSEMESSAGE
    global NOVALUERESPONSEMESSAGE
    title := command[2]
    text := command[3]
    extitle := command[4]
    extext := command[5]
    detect_hw := command[6]
    match_mode := command[7]
    match_speed := command[8]

    current_match_mode := Format("{}", A_TitleMatchMode)
    current_match_speed := Format("{}", A_TitleMatchModeSpeed)
    if (match_mode != "") {
        SetTitleMatchMode, %match_mode%
    }
    if (match_speed != "") {
        SetTitleMatchMode, %match_speed%
    }

    current_detect_hw := Format("{}", A_DetectHiddenWindows)

    if (detect_hw != "") {
        DetectHiddenWindows, %detect_hw%
    }

    WinGet, output, Style, %title%, %text%, %extitle%, %extext%
    response := FormatResponse(NOVALUERESPONSEMESSAGE, output)
    DetectHiddenWindows, %current_detect_hw%
    SetTitleMatchMode, %current_match_mode%
    SetTitleMatchMode, %current_match_speed%
    return response
}
AHKWinGetExStyle(ByRef command) {
    global STRINGRESPONSEMESSAGE
    global INTEGERRESPONSEMESSAGE
    global NOVALUERESPONSEMESSAGE
    title := command[2]
    text := command[3]
    extitle := command[4]
    extext := command[5]
    detect_hw := command[6]
    match_mode := command[7]
    match_speed := command[8]

    current_match_mode := Format("{}", A_TitleMatchMode)
    current_match_speed := Format("{}", A_TitleMatchModeSpeed)
    if (match_mode != "") {
        SetTitleMatchMode, %match_mode%
    }
    if (match_speed != "") {
        SetTitleMatchMode, %match_speed%
    }

    current_detect_hw := Format("{}", A_DetectHiddenWindows)

    if (detect_hw != "") {
        DetectHiddenWindows, %detect_hw%
    }

    WinGet, output, ExStyle, %title%, %text%, %extitle%, %extext%
    response := FormatResponse(NOVALUERESPONSEMESSAGE, output)
    DetectHiddenWindows, %current_detect_hw%
    SetTitleMatchMode, %current_match_mode%
    SetTitleMatchMode, %current_match_speed%
    return response
}

AHKWinGetText(ByRef command) {
    global STRINGRESPONSEMESSAGE
    global EXCEPTIONRESPONSEMESSAGE
    title := command[2]
    text := command[3]
    extitle := command[4]
    extext := command[5]
    detect_hw := command[6]
    match_mode := command[7]
    match_speed := command[8]

    current_match_mode := Format("{}", A_TitleMatchMode)
    current_match_speed := Format("{}", A_TitleMatchModeSpeed)
    if (match_mode != "") {
        SetTitleMatchMode, %match_mode%
    }
    if (match_speed != "") {
        SetTitleMatchMode, %match_speed%
    }
    current_detect_hw := Format("{}", A_DetectHiddenWindows)

    if (detect_hw != "") {
        DetectHiddenWindows, %detect_hw%
    }

    WinGetText, output,%title%,%text%,%extitle%,%extext%

    if (ErrorLevel = 1) {
        response := FormatResponse(EXCEPTIONRESPONSEMESSAGE, "There was an error getting window text")
    } else {
        response := FormatResponse(STRINGRESPONSEMESSAGE, output)
    }

    DetectHiddenWindows, %current_detect_hw%
    SetTitleMatchMode, %current_match_mode%
    SetTitleMatchMode, %current_match_speed%
    return response
}



AHKWinSetTitle(ByRef command) {
    new_title := command[2]
    title := command[3]
    text := command[4]
    extitle := command[5]
    extext := command[6]
    detect_hw := command[7]
    match_mode := command[8]
    match_speed := command[9]

    current_match_mode := Format("{}", A_TitleMatchMode)
    current_match_speed := Format("{}", A_TitleMatchModeSpeed)
    if (match_mode != "") {
        SetTitleMatchMode, %match_mode%
    }
    if (match_speed != "") {
        SetTitleMatchMode, %match_speed%
    }
    current_detect_hw := Format("{}", A_DetectHiddenWindows)

    if (detect_hw != "") {
        DetectHiddenWindows, %detect_hw%
    }
    WinSetTitle, %title%, %text%, %new_title%, %extitle%, %extext%
    DetectHiddenWindows, %current_detect_hw%
    SetTitleMatchMode, %current_match_mode%
    SetTitleMatchMode, %current_match_speed%
    return FormatNoValueResponse()
}

AHKWinSetAlwaysOnTop(ByRef command) {
    toggle := command[2]
    title := command[3]
    text := command[4]
    extitle := command[5]
    extext := command[6]
    detect_hw := command[7]
    match_mode := command[8]
    match_speed := command[9]

    current_match_mode := Format("{}", A_TitleMatchMode)
    current_match_speed := Format("{}", A_TitleMatchModeSpeed)
    if (match_mode != "") {
        SetTitleMatchMode, %match_mode%
    }
    if (match_speed != "") {
        SetTitleMatchMode, %match_speed%
    }
    current_detect_hw := Format("{}", A_DetectHiddenWindows)

    if (detect_hw != "") {
        DetectHiddenWindows, %detect_hw%
    }

    WinSet, AlwaysOntop, %toggle%, %title%, %text%, %extitle%, %extext%
    DetectHiddenWindows, %current_detect_hw%
    SetTitleMatchMode, %current_match_mode%
    SetTitleMatchMode, %current_match_speed%
    return FormatNoValueResponse()
}

AHKWinSetBottom(ByRef command) {
    title := command[2]
    text := command[3]
    extitle := command[4]
    extext := command[5]
    detect_hw := command[6]
    match_mode := command[7]
    match_speed := command[8]

    current_match_mode := Format("{}", A_TitleMatchMode)
    current_match_speed := Format("{}", A_TitleMatchModeSpeed)
    if (match_mode != "") {
        SetTitleMatchMode, %match_mode%
    }
    if (match_speed != "") {
        SetTitleMatchMode, %match_speed%
    }

    current_detect_hw := Format("{}", A_DetectHiddenWindows)

    if (detect_hw != "") {
        DetectHiddenWindows, %detect_hw%
    }

    WinSet, Bottom,, %title%, %text%, %extitle%, %extext%
    DetectHiddenWindows, %current_detect_hw%
    SetTitleMatchMode, %current_match_mode%
    SetTitleMatchMode, %current_match_speed%
    return FormatNoValueResponse()
}

AHKWinShow(ByRef command) {
    title := command[2]
    text := command[3]
    extitle := command[4]
    extext := command[5]
    detect_hw := command[6]
    match_mode := command[7]
    match_speed := command[8]

    current_match_mode := Format("{}", A_TitleMatchMode)
    current_match_speed := Format("{}", A_TitleMatchModeSpeed)
    if (match_mode != "") {
        SetTitleMatchMode, %match_mode%
    }
    if (match_speed != "") {
        SetTitleMatchMode, %match_speed%
    }

    current_detect_hw := Format("{}", A_DetectHiddenWindows)

    if (detect_hw != "") {
        DetectHiddenWindows, %detect_hw%
    }

    WinShow, %title%, %text%, %extitle%, %extext%
    DetectHiddenWindows, %current_detect_hw%
    SetTitleMatchMode, %current_match_mode%
    SetTitleMatchMode, %current_match_speed%
    return FormatNoValueResponse()
}

AHKWinHide(ByRef command) {
    title := command[2]
    text := command[3]
    extitle := command[4]
    extext := command[5]
    detect_hw := command[6]
    match_mode := command[7]
    match_speed := command[8]

    current_match_mode := Format("{}", A_TitleMatchMode)
    current_match_speed := Format("{}", A_TitleMatchModeSpeed)
    if (match_mode != "") {
        SetTitleMatchMode, %match_mode%
    }
    if (match_speed != "") {
        SetTitleMatchMode, %match_speed%
    }

    current_detect_hw := Format("{}", A_DetectHiddenWindows)

    if (detect_hw != "") {
        DetectHiddenWindows, %detect_hw%
    }

    WinHide, %title%, %text%, %extitle%, %extext%
    DetectHiddenWindows, %current_detect_hw%
    SetTitleMatchMode, %current_match_mode%
    SetTitleMatchMode, %current_match_speed%
    return FormatNoValueResponse()
}


AHKWinSetTop(ByRef command) {
    title := command[2]
    text := command[3]
    extitle := command[4]
    extext := command[5]
    detect_hw := command[6]
    match_mode := command[7]
    match_speed := command[8]

    current_match_mode := Format("{}", A_TitleMatchMode)
    current_match_speed := Format("{}", A_TitleMatchModeSpeed)
    if (match_mode != "") {
        SetTitleMatchMode, %match_mode%
    }
    if (match_speed != "") {
        SetTitleMatchMode, %match_speed%
    }

    current_detect_hw := Format("{}", A_DetectHiddenWindows)

    if (detect_hw != "") {
        DetectHiddenWindows, %detect_hw%
    }

    WinSet, Top,, %title%, %text%, %extitle%, %extext%
    DetectHiddenWindows, %current_detect_hw%
    SetTitleMatchMode, %current_match_mode%
    SetTitleMatchMode, %current_match_speed%
    return FormatNoValueResponse()
}

AHKWinSetEnable(ByRef command) {
    title := command[2]
    text := command[3]
    extitle := command[4]
    extext := command[5]
    detect_hw := command[6]
    match_mode := command[7]
    match_speed := command[8]

    current_match_mode := Format("{}", A_TitleMatchMode)
    current_match_speed := Format("{}", A_TitleMatchModeSpeed)
    if (match_mode != "") {
        SetTitleMatchMode, %match_mode%
    }
    if (match_speed != "") {
        SetTitleMatchMode, %match_speed%
    }

    current_detect_hw := Format("{}", A_DetectHiddenWindows)

    if (detect_hw != "") {
        DetectHiddenWindows, %detect_hw%
    }

    WinSet, Enable,, %title%, %text%, %extitle%, %extext%
    DetectHiddenWindows, %current_detect_hw%
    SetTitleMatchMode, %current_match_mode%
    SetTitleMatchMode, %current_match_speed%
    return FormatNoValueResponse()
}

AHKWinSetDisable(ByRef command) {
    title := command[2]
    text := command[3]
    extitle := command[4]
    extext := command[5]
    detect_hw := command[6]
    match_mode := command[7]
    match_speed := command[8]

    current_match_mode := Format("{}", A_TitleMatchMode)
    current_match_speed := Format("{}", A_TitleMatchModeSpeed)
    if (match_mode != "") {
        SetTitleMatchMode, %match_mode%
    }
    if (match_speed != "") {
        SetTitleMatchMode, %match_speed%
    }

    current_detect_hw := Format("{}", A_DetectHiddenWindows)

    if (detect_hw != "") {
        DetectHiddenWindows, %detect_hw%
    }

    WinSet, Disable,, %title%, %text%, %extitle%, %extext%
    DetectHiddenWindows, %current_detect_hw%
    SetTitleMatchMode, %current_match_mode%
    SetTitleMatchMode, %current_match_speed%
    return FormatNoValueResponse()
}

AHKWinSetRedraw(ByRef command) {
    title := command[2]
    text := command[3]
    extitle := command[4]
    extext := command[5]
    detect_hw := command[6]
    match_mode := command[7]
    match_speed := command[8]

    current_match_mode := Format("{}", A_TitleMatchMode)
    current_match_speed := Format("{}", A_TitleMatchModeSpeed)
    if (match_mode != "") {
        SetTitleMatchMode, %match_mode%
    }
    if (match_speed != "") {
        SetTitleMatchMode, %match_speed%
    }

    current_detect_hw := Format("{}", A_DetectHiddenWindows)

    if (detect_hw != "") {
        DetectHiddenWindows, %detect_hw%
    }

    WinSet, Redraw,, %title%, %text%, %extitle%, %extext%
    DetectHiddenWindows, %current_detect_hw%
    SetTitleMatchMode, %current_match_mode%
    SetTitleMatchMode, %current_match_speed%
    return FormatNoValueResponse()
}

AHKWinSetStyle(ByRef command) {
    global BOOLEANRESPONSEMESSAGE
    style := command[2]
    title := command[3]
    text := command[4]
    extitle := command[5]
    extext := command[6]
    detect_hw := command[7]
    match_mode := command[8]
    match_speed := command[9]

    current_match_mode := Format("{}", A_TitleMatchMode)
    current_match_speed := Format("{}", A_TitleMatchModeSpeed)
    if (match_mode != "") {
        SetTitleMatchMode, %match_mode%
    }
    if (match_speed != "") {
        SetTitleMatchMode, %match_speed%
    }
    current_detect_hw := Format("{}", A_DetectHiddenWindows)

    if (detect_hw != "") {
        DetectHiddenWindows, %detect_hw%
    }


    WinSet, Style, %style%, %title%, %text%, %extitle%, %extext%
    if (ErrorLevel = 1) {
        resp := FormatResponse(BOOLEANRESPONSEMESSAGE, 0)
    } else {
        resp := FormatResponse(BOOLEANRESPONSEMESSAGE, 1)
    }
    DetectHiddenWindows, %current_detect_hw%
    SetTitleMatchMode, %current_match_mode%
    SetTitleMatchMode, %current_match_speed%
    return resp
}

AHKWinSetExStyle(ByRef command) {
    global BOOLEANRESPONSEMESSAGE
    style := command[2]
    title := command[3]
    text := command[4]
    extitle := command[5]
    extext := command[6]
    detect_hw := command[7]
    match_mode := command[8]
    match_speed := command[9]

    current_match_mode := Format("{}", A_TitleMatchMode)
    current_match_speed := Format("{}", A_TitleMatchModeSpeed)
    if (match_mode != "") {
        SetTitleMatchMode, %match_mode%
    }
    if (match_speed != "") {
        SetTitleMatchMode, %match_speed%
    }
    current_detect_hw := Format("{}", A_DetectHiddenWindows)

    if (detect_hw != "") {
        DetectHiddenWindows, %detect_hw%
    }


    WinSet, ExStyle, %style%, %title%, %text%, %extitle%, %extext%
    if (ErrorLevel = 1) {
        resp := FormatResponse(BOOLEANRESPONSEMESSAGE, 0)
    } else {
        resp := FormatResponse(BOOLEANRESPONSEMESSAGE, 1)
    }
    DetectHiddenWindows, %current_detect_hw%
    SetTitleMatchMode, %current_match_mode%
    SetTitleMatchMode, %current_match_speed%
    return resp
}

AHKWinSetRegion(ByRef command) {
    global BOOLEANRESPONSEMESSAGE
    options := command[2]
    title := command[3]
    text := command[4]
    extitle := command[5]
    extext := command[6]
    detect_hw := command[7]
    match_mode := command[8]
    match_speed := command[9]

    current_match_mode := Format("{}", A_TitleMatchMode)
    current_match_speed := Format("{}", A_TitleMatchModeSpeed)
    if (match_mode != "") {
        SetTitleMatchMode, %match_mode%
    }
    if (match_speed != "") {
        SetTitleMatchMode, %match_speed%
    }
    current_detect_hw := Format("{}", A_DetectHiddenWindows)

    if (detect_hw != "") {
        DetectHiddenWindows, %detect_hw%
    }


    WinSet, Region, %options%, %title%, %text%, %extitle%, %extext%
    if (ErrorLevel = 1) {
        resp := FormatResponse(BOOLEANRESPONSEMESSAGE, 0)
    } else {
        resp := FormatResponse(BOOLEANRESPONSEMESSAGE, 1)
    }
    DetectHiddenWindows, %current_detect_hw%
    SetTitleMatchMode, %current_match_mode%
    SetTitleMatchMode, %current_match_speed%
    return resp
}

AHKWinSetTransparent(ByRef command) {
    global BOOLEANRESPONSEMESSAGE
    transparency := command[2]
    title := command[3]
    text := command[4]
    extitle := command[5]
    extext := command[6]
    detect_hw := command[7]
    match_mode := command[8]
    match_speed := command[9]

    current_match_mode := Format("{}", A_TitleMatchMode)
    current_match_speed := Format("{}", A_TitleMatchModeSpeed)
    if (match_mode != "") {
        SetTitleMatchMode, %match_mode%
    }
    if (match_speed != "") {
        SetTitleMatchMode, %match_speed%
    }
    current_detect_hw := Format("{}", A_DetectHiddenWindows)

    if (detect_hw != "") {
        DetectHiddenWindows, %detect_hw%
    }


    WinSet, Transparent, %transparency%, %title%, %text%, %extitle%, %extext%
    DetectHiddenWindows, %current_detect_hw%
    SetTitleMatchMode, %current_match_mode%
    SetTitleMatchMode, %current_match_speed%
    return FormatNoValueResponse()
}

AHKWinSetTransColor(ByRef command) {
    global BOOLEANRESPONSEMESSAGE
    color := command[2]
    title := command[3]
    text := command[4]
    extitle := command[5]
    extext := command[6]
    detect_hw := command[7]
    match_mode := command[8]
    match_speed := command[9]

    current_match_mode := Format("{}", A_TitleMatchMode)
    current_match_speed := Format("{}", A_TitleMatchModeSpeed)
    if (match_mode != "") {
        SetTitleMatchMode, %match_mode%
    }
    if (match_speed != "") {
        SetTitleMatchMode, %match_speed%
    }
    current_detect_hw := Format("{}", A_DetectHiddenWindows)

    if (detect_hw != "") {
        DetectHiddenWindows, %detect_hw%
    }


    WinSet, TransColor, %color%, %title%, %text%, %extitle%, %extext%
    return FormatNoValueResponse()
}

AHKImageSearch(ByRef command) {
    global COORDINATERESPONSEMESSAGE
    global EXCEPTIONRESPONSEMESSAGE
    imagepath := command[6]
    x1 := command[2]
    y1 := command[3]
    x2 := command[4]
    y2 := command[5]

    if (x2 = "A_ScreenWidth") {
        x2 := A_ScreenWidth
    }
    if (y2 = "A_ScreenHeight") {
        y2 := A_ScreenHeight
    }
    ImageSearch, xpos, ypos,% x1,% y1,% x2,% y2, %imagepath%
    if (ErrorLevel = 2) {
        s := FormatResponse(EXCEPTIONRESPONSEMESSAGE, "there was a problem that prevented the command from conducting the search (such as failure to open the image file or a badly formatted option)")
    } else if (ErrorLevel = 1) {
        s := FormatNoValueResponse()
    } else {
        s := FormatResponse(COORDINATERESPONSEMESSAGE, Format("({}, {})", xpos, ypos))
    }

    return s
}

AHKPixelGetColor(ByRef command) {
    global STRINGRESPONSEMESSAGE
    x := command[2]
    y := command[3]
    coord_mode := command[4]
    options := command[5]

    current_mode := Format("{}", A_CoordModePixel)

    if (coord_mode != "") {
        CoordMode, Pixel, %coord_mode%
    }

    PixelGetColor, color, %x%, %y%, %options%
    ; TODO: check errorlevel

    if (coord_mode != "") {
        CoordMode, Pixel, %current_mode%
    }

    return FormatResponse(STRINGRESPONSEMESSAGE, color)
}

AHKPixelSearch(ByRef command) {
    global COORDINATERESPONSEMESSAGE
    global EXCEPTIONRESPONSEMESSAGE
    x1 := command[2]
    y1 := command[3]
    x2 := command[4]
    y2 := command[5]
    color := command[6]
    variation := command[7]
    options := command[8]
    coord_mode := command[9]

    current_mode := Format("{}", A_CoordModePixel)

    if (coord_mode != "") {
        CoordMode, Pixel, %coord_mode%
    }

    PixelSearch, resultx, resulty, %x1%, %y1%, %x2%, %y2%, %color%, %variation%, %options%

    if (coord_mode != "") {
        CoordMode, Pixel, %current_mode%
    }

    if (ErrorLevel = 1) {
        return FormatNoValueResponse()
    } else if (ErrorLevel = 0) {
        payload := Format("({}, {})", resultx, resulty)
        return FormatResponse(COORDINATERESPONSEMESSAGE, payload)
    } else if (ErrorLevel = 2) {
        return FormatResponse(EXCEPTIONRESPONSEMESSAGE, "There was a problem conducting the pixel search (ErrorLevel 2)")
    } else {
        return FormatResponse(EXCEPTIONRESPONSEMESSAGE, "Unexpected error. This is probably a bug. Please report this at https://github.com/spyoungtech/ahk/issues")
    }

}


AHKMouseGetPos(ByRef command) {
    global COORDINATERESPONSEMESSAGE
    coord_mode := command[2]
    current_coord_mode := Format("{}", A_CoordModeMouse)
    if (coord_mode != "") {
        CoordMode, Mouse, %coord_mode%
    }
    MouseGetPos, xpos, ypos

    payload := Format("({}, {})", xpos, ypos)
    resp := FormatResponse(COORDINATERESPONSEMESSAGE, payload)

    if (coord_mode != "") {
        CoordMode, Mouse, %current_coord_mode%
    }

    return resp
}

AHKKeyState(ByRef command) {
    global INTEGERRESPONSEMESSAGE
    global FLOATRESPONSEMESSAGE
    global STRINGRESPONSEMESSAGE
    global EXCEPTIONRESPONSEMESSAGE

    keyname := command[2]
    mode := command[3]
    if (mode != "") {
        state := GetKeyState(keyname, mode)
    } else{
        state := GetKeyState(keyname)
    }

    if (state = "") {
        return FormatNoValueResponse()
    }

    if state is integer
        return FormatResponse(INTEGERRESPONSEMESSAGE, state)

    if state is float
        return FormatResponse(FLOATRESPONSEMESSAGE, state)

    if state is alnum
        return FormatResponse(STRINGRESPONSEMESSAGE, state)

    return FormatResponse(EXCEPTIONRESPONSEMESSAGE, state)
}

AHKMouseMove(ByRef command) {
    x := command[2]
    y := command[3]
    speed := command[4]
    relative := command[5]
    if (relative != "") {
    MouseMove, %x%, %y%, %speed%, R
    } else {
    MouseMove, %x%, %y%, %speed%
    }
    resp := FormatNoValueResponse()
    return resp
}


AHKClick(ByRef command) {
    x := command[2]
    y := command[3]
    button := command[4]
    click_count := command[5]
    direction := command[6]
    r := command[7]
    relative_to := command[8]
    current_coord_rel := Format("{}", A_CoordModeMouse)

    if (relative_to != "") {
        CoordMode, Mouse, %relative_to%
    }

    Click, %x%, %y%, %button%, %direction%, %r%

    if (relative_to != "") {
        CoordMode, Mouse, %current_coord_rel%
    }

    return FormatNoValueResponse()

}

AHKGetCoordMode(ByRef command) {
    global STRINGRESPONSEMESSAGE
    global EXCEPTIONRESPONSEMESSAGE
    target := command[2]

    if (target = "ToolTip") {
        return FormatResponse(STRINGRESPONSEMESSAGE, A_CoordModeToolTip)
    }
    if (target = "Pixel") {
        return FormatResponse(STRINGRESPONSEMESSAGE, A_CoordModePixel)
    }
    if (target = "Mouse") {
        return FormatResponse(STRINGRESPONSEMESSAGE, A_CoordModeMouse)
    }
    if (target = "Caret") {
        return FormatResponse(STRINGRESPONSEMESSAGE, A_CoordModeCaret)
    }
    if (target = "Menu") {
        return FormatResponse(STRINGRESPONSEMESSAGE, A_CoordModeMenu)
    }
    return FormatResponse(EXCEPTIONRESPONSEMESSAGE, "Invalid coord mode")
}

AHKSetCoordMode(ByRef command) {
    target := command[2]
    relative_to := command[3]
    CoordMode, %target%, %relative_to%

    return FormatNoValueResponse()
}

AHKMouseClickDrag(ByRef command) {
    button := command[2]
    x1 := command[3]
    y1 := command[4]
    x2 := command[5]
    y2 := command[6]
    speed := command[7]
    relative := command[8]
    relative_to := command[9]

    current_coord_rel := Format("{}", A_CoordModeMouse)

    if (relative_to != "") {
        CoordMode, Mouse, %relative_to%
    }

    MouseClickDrag, %button%, %x1%, %y1%, %x2%, %y2%, %speed%, %relative%

    if (relative_to != "") {
        CoordMode, Mouse, %current_coord_rel%
    }

    return FormatNoValueResponse()

}

RegRead(ByRef command) {
    keyname := command[3]
    RegRead, output, %keyname%, command[4]
    return output
}

SetRegView(ByRef command) {
    view := command[2]
    SetRegView, %view%
}

RegWrite(ByRef command) {
    valuetype := command[2]
    keyname := command[3]

    RegWrite, %valuetype%, %keyname%, command[4]
}

RegDelete(ByRef command) {
    keyname := command[2]
    RegDelete, %keyname%, command[3]
}

AHKKeyWait(ByRef command) {
    global INTEGERRESPONSEMESSAGE
    keyname := command[2]
    if (command.Length() = 2) {
        KeyWait,% keyname
    } else {
        options := command[3]
        KeyWait,% keyname,% options
    }
    return FormatResponse(INTEGERRESPONSEMESSAGE, ErrorLevel)
}

SetKeyDelay(ByRef command) {
    SetKeyDelay, command[2], command[3]
}

Join(sep, params*) {
    for index,param in params
        str := param . sep
    return SubStr(str, 1, -StrLen(sep))
}

Unescape(HayStack) {
    ReplacedStr := StrReplace(Haystack, "``n" , "`n")
    return ReplacedStr
}

AHKSend(ByRef command) {
    str := command[2]
    key_delay := command[3]
    key_press_duration := command[4]
    current_delay := Format("{}", A_KeyDelay)
    current_key_duration := Format("{}", A_KeyDuration)

    if (key_delay != "" or key_press_duration != "") {
        SetKeyDelay, %key_delay%, %key_press_duration%
    }

    Send,% str

    if (key_delay != "" or key_press_duration != "") {
        SetKeyDelay, %current_delay%, %current_key_duration%
    }
    return FormatNoValueResponse()
}

AHKSendRaw(ByRef command) {
    str := command[2]
    key_delay := command[3]
    key_press_duration := command[4]
    current_delay := Format("{}", A_KeyDelay)
    current_key_duration := Format("{}", A_KeyDuration)

    if (key_delay != "" or key_press_duration != "") {
        SetKeyDelay, %key_delay%, %key_press_duration%
    }

    SendRaw,% str

    if (key_delay != "" or key_press_duration != "") {
        SetKeyDelay, %current_delay%, %current_key_duration%
    }
    return FormatNoValueResponse()
}

AHKSendInput(ByRef command) {
    str := command[2]
    key_delay := command[3]
    key_press_duration := command[4]
    current_delay := Format("{}", A_KeyDelay)
    current_key_duration := Format("{}", A_KeyDuration)

    if (key_delay != "" or key_press_duration != "") {
        SetKeyDelay, %key_delay%, %key_press_duration%
    }

    SendInput,% str

    if (key_delay != "" or key_press_duration != "") {
        SetKeyDelay, %current_delay%, %current_key_duration%
    }
    return FormatNoValueResponse()
}


AHKSendEvent(ByRef command) {
    str := command[2]
    key_delay := command[3]
    key_press_duration := command[4]
    current_delay := Format("{}", A_KeyDelay)
    current_key_duration := Format("{}", A_KeyDuration)

    if (key_delay != "" or key_press_duration != "") {
        SetKeyDelay, %key_delay%, %key_press_duration%
    }

    SendEvent,% str

    if (key_delay != "" or key_press_duration != "") {
        SetKeyDelay, %current_delay%, %current_key_duration%
    }
    return FormatNoValueResponse()
}

AHKSendPlay(ByRef command) {
    str := command[2]
    key_delay := command[3]
    key_press_duration := command[4]
    current_delay := Format("{}", A_KeyDelayPlay)
    current_key_duration := Format("{}", A_KeyDurationPlay)

    if (key_delay != "" or key_press_duration != "") {
        SetKeyDelay, %key_delay%, %key_press_duration%, Play
    }

    SendPlay,% str

    if (key_delay != "" or key_press_duration != "") {
        SetKeyDelay, %current_delay%, %current_key_duration%
    }
    return FormatNoValueResponse()
}

AHKSetCapsLockState(ByRef command) {
    state := command[2]
    if (state = "") {
        SetCapsLockState % !GetKeyState("CapsLock", "T")
    } else {
        SetCapsLockState, %state%
    }
    return FormatNoValueResponse()
}

HideTrayTip(ByRef command) {
    TrayTip ; Attempt to hide it the normal way.
    if SubStr(A_OSVersion,1,3) = "10." {
        Menu Tray, NoIcon
        Sleep 200 ; It may be necessary to adjust this sleep.
        Menu Tray, Icon
    }
}




AHKWinGetClass(ByRef command) {
    global STRINGRESPONSEMESSAGE
    global EXCEPTIONRESPONSEMESSAGE
    title := command[2]
    text := command[3]
    extitle := command[4]
    extext := command[5]
    detect_hw := command[6]
    match_mode := command[7]
    match_speed := command[8]

    current_match_mode := Format("{}", A_TitleMatchMode)
    current_match_speed := Format("{}", A_TitleMatchModeSpeed)
    if (match_mode != "") {
        SetTitleMatchMode, %match_mode%
    }
    if (match_speed != "") {
        SetTitleMatchMode, %match_speed%
    }
    current_detect_hw := Format("{}", A_DetectHiddenWindows)

    if (detect_hw != "") {
        DetectHiddenWindows, %detect_hw%
    }

    WinGetClass, output,%title%,%text%,%extitle%,%extext%

    if (ErrorLevel = 1) {
        response := FormatResponse(EXCEPTIONRESPONSEMESSAGE, "There was an error getting window class")
    } else {
        response := FormatResponse(STRINGRESPONSEMESSAGE, output)
    }

    DetectHiddenWindows, %current_detect_hw%
    SetTitleMatchMode, %current_match_mode%
    SetTitleMatchMode, %current_match_speed%
    return response
}

AHKWinActivate(ByRef command) {
    title := command[2]
    text := command[3]
    extitle := command[4]
    extext := command[5]
    detect_hw := command[6]
    match_mode := command[7]
    match_speed := command[8]

    current_match_mode := Format("{}", A_TitleMatchMode)
    current_match_speed := Format("{}", A_TitleMatchModeSpeed)
    if (match_mode != "") {
        SetTitleMatchMode, %match_mode%
    }
    if (match_speed != "") {
        SetTitleMatchMode, %match_speed%
    }

    current_detect_hw := Format("{}", A_DetectHiddenWindows)

    if (detect_hw != "") {
        DetectHiddenWindows, %detect_hw%
    }

    WinActivate, %title%, %text%, %extitle%, %extext%

    DetectHiddenWindows, %current_detect_hw%
    SetTitleMatchMode, %current_match_mode%
    SetTitleMatchMode, %current_match_speed%

    return FormatNoValueResponse()
}




AHKWindowList(ByRef command) {
    global WINDOWLISTRESPONSEMESSAGE

    current_detect_hw := Format("{}", A_DetectHiddenWindows)

    title := command[2]
    text := command[3]
    extitle := command[4]
    extext := command[5]
    detect_hw := command[6]
    match_mode := command[7]
    match_speed := command[8]

    current_match_mode := Format("{}", A_TitleMatchMode)
    current_match_speed := Format("{}", A_TitleMatchModeSpeed)
    if (match_mode != "") {
        SetTitleMatchMode, %match_mode%
    }
    if (match_speed != "") {
        SetTitleMatchMode, %match_speed%
    }
    if (detect_hw) {
        DetectHiddenWindows, %detect_hw%
    }

    WinGet windows, List, %title%, %text%, %extitle%, %extext%
    r := ""
    Loop %windows%
    {
        id := windows%A_Index%
        r .= id . "`,"
    }
    resp := FormatResponse(WINDOWLISTRESPONSEMESSAGE, r)
    DetectHiddenWindows, %current_detect_hw%
    SetTitleMatchMode, %current_match_mode%
    SetTitleMatchMode, %current_match_speed%
    return resp
}



AHKControlClick(ByRef command) {
    global EXCEPTIONRESPONSEMESSAGE
    ctrl := command[2]
    title := command[3]
    text := command[4]
    button := command[5]
    click_count := command[6]
    options := command[7]
    exclude_title := command[8]
    exclude_text := command[9]
    detect_hw := command[10]
    match_mode := command[11]
    match_speed := command[12]

    current_match_mode := Format("{}", A_TitleMatchMode)
    current_match_speed := Format("{}", A_TitleMatchModeSpeed)
    if (match_mode != "") {
        SetTitleMatchMode, %match_mode%
    }
    if (match_speed != "") {
        SetTitleMatchMode, %match_speed%
    }
    current_detect_hw := Format("{}", A_DetectHiddenWindows)

    if (detect_hw != "") {
        DetectHiddenWindows, %detect_hw%
    }

    ControlClick, %ctrl%, %title%, %text%, %button%, %click_count%, %options%, %exclude_title%, %exclude_text%

    if (ErrorLevel != 0) {
        response := FormatResponse(EXCEPTIONRESPONSEMESSAGE, "Failed to click control")
    } else {
        response := FormatNoValueResponse()
    }

    DetectHiddenWindows, %current_detect_hw%
    SetTitleMatchMode, %current_match_mode%
    SetTitleMatchMode, %current_match_speed%

    return response
}

AHKControlGetText(ByRef command) {
    global STRINGRESPONSEMESSAGE
    global EXCEPTIONRESPONSEMESSAGE
    ctrl := command[2]
    title := command[3]
    text := command[4]
    extitle := command[5]
    extext := command[6]
    detect_hw := command[7]
    match_mode := command[8]
    match_speed := command[9]

    current_match_mode := Format("{}", A_TitleMatchMode)
    current_match_speed := Format("{}", A_TitleMatchModeSpeed)
    if (match_mode != "") {
        SetTitleMatchMode, %match_mode%
    }
    if (match_speed != "") {
        SetTitleMatchMode, %match_speed%
    }
    current_detect_hw := Format("{}", A_DetectHiddenWindows)

    if (detect_hw != "") {
        DetectHiddenWindows, %detect_hw%
    }

    ControlGetText, result, %ctrl%, %title%, %text%, %extitle%, %extext%

    if (ErrorLevel = 1) {
        response := FormatResponse(EXCEPTIONRESPONSEMESSAGE, "There was a problem getting the text")
    } else {
        response := FormatResponse(STRINGRESPONSEMESSAGE, result)
    }
    DetectHiddenWindows, %current_detect_hw%
    SetTitleMatchMode, %current_match_mode%
    SetTitleMatchMode, %current_match_speed%

    return response
}


AHKControlGetPos(ByRef command) {
    global POSITIONRESPONSEMESSAGE
    global EXCEPTIONRESPONSEMESSAGE
    ctrl := command[2]
    title := command[3]
    text := command[4]
    extitle := command[5]
    extext := command[6]
    detect_hw := command[7]
    match_mode := command[8]
    match_speed := command[9]

    current_match_mode := Format("{}", A_TitleMatchMode)
    current_match_speed := Format("{}", A_TitleMatchModeSpeed)
    if (match_mode != "") {
        SetTitleMatchMode, %match_mode%
    }
    if (match_speed != "") {
        SetTitleMatchMode, %match_speed%
    }
    current_detect_hw := Format("{}", A_DetectHiddenWindows)

    if (detect_hw != "") {
        DetectHiddenWindows, %detect_hw%
    }

    ControlGetPos, x, y, w, h, %ctrl%, %title%, %text%, %extitle%, %extext%
    if (ErrorLevel = 1) {
        response := FormatResponse(EXCEPTIONRESPONSEMESSAGE, "There was a problem getting the text")
    } else {
        result := Format("({1:i}, {2:i}, {3:i}, {4:i})", x, y, w, h)
        response := FormatResponse(PositionResponseMessage, result)
    }

    DetectHiddenWindows, %current_detect_hw%
    SetTitleMatchMode, %current_match_mode%
    SetTitleMatchMode, %current_match_speed%

    return response


}

AHKControlSend(ByRef command) {
    ctrl := command[2]
    keys := command[3]
    title := command[4]
    text := command[5]
    extitle := command[6]
    extext := command[7]
    detect_hw := command[8]
    match_mode := command[9]
    match_speed := command[10]

    current_match_mode := Format("{}", A_TitleMatchMode)
    current_match_speed := Format("{}", A_TitleMatchModeSpeed)
    if (match_mode != "") {
        SetTitleMatchMode, %match_mode%
    }
    if (match_speed != "") {
        SetTitleMatchMode, %match_speed%
    }
    current_detect_hw := Format("{}", A_DetectHiddenWindows)

    if (detect_hw != "") {
        DetectHiddenWindows, %detect_hw%
    }
    ControlSend, %ctrl%, %keys%, %title%, %text%, %extitle%, %extext%
    DetectHiddenWindows, %current_detect_hw%
    SetTitleMatchMode, %current_match_mode%
    SetTitleMatchMode, %current_match_speed%
    return FormatNoValueResponse()
}




AHKWinFromMouse(ByRef command) {
    global WINDOWRESPONSEMESSAGE
    MouseGetPos,,, MouseWin

    if (MouseWin = "") {
        return FormatNoValueResponse()
    }

    return FormatResponse(WINDOWRESPONSEMESSAGE, MouseWin)
}


AHKWinIsAlwaysOnTop(ByRef command) {
    global BOOLEANRESPONSEMESSAGE
    title := command[2]
    WinGet, ExStyle, ExStyle, %title%
    if (ExStyle = "")
        return FormatNoValueResponse()

    if (ExStyle & 0x8)  ; 0x8 is WS_EX_TOPMOST.
        return FormatResponse(BOOLEANRESPONSEMESSAGE, 1)
    else
        return FormatResponse(BOOLEANRESPONSEMESSAGE, 0)
}


AHKWinMove(ByRef command) {
    title := command[2]
    text := command[3]
    extitle := command[4]
    extext := command[5]
    detect_hw := command[6]
    match_mode := command[7]
    match_speed := command[8]
    x := command[9]
    y := command[10]
    width := command[11]
    height := command[12]

    current_match_mode := Format("{}", A_TitleMatchMode)
    current_match_speed := Format("{}", A_TitleMatchModeSpeed)
    if (match_mode != "") {
        SetTitleMatchMode, %match_mode%
    }
    if (match_speed != "") {
        SetTitleMatchMode, %match_speed%
    }
    current_detect_hw := Format("{}", A_DetectHiddenWindows)

    if (detect_hw != "") {
        DetectHiddenWindows, %detect_hw%
    }

    WinMove, %title%, %text%, %x%, %y%, %width%, %height%, %extitle%, %extext%

    DetectHiddenWindows, %current_detect_hw%
    SetTitleMatchMode, %current_match_mode%
    SetTitleMatchMode, %current_match_speed%

    return FormatNoValueResponse()

}

AHKWinGetPos(ByRef command) {
    global POSITIONRESPONSEMESSAGE
    global EXCEPTIONRESPONSEMESSAGE

    title := command[2]
    text := command[3]
    extitle := command[4]
    extext := command[5]
    detect_hw := command[6]
    match_mode := command[7]
    match_speed := command[8]

    current_match_mode := Format("{}", A_TitleMatchMode)
    current_match_speed := Format("{}", A_TitleMatchModeSpeed)
    if (match_mode != "") {
        SetTitleMatchMode, %match_mode%
    }
    if (match_speed != "") {
        SetTitleMatchMode, %match_speed%
    }
    current_detect_hw := Format("{}", A_DetectHiddenWindows)

    if (detect_hw != "") {
        DetectHiddenWindows, %detect_hw%
    }

    WinGetPos, x, y, w, h, %title%, %text%, %extitle%, %extext%

    if (ErrorLevel = 1) {
        response := FormatResponse(EXCEPTIONRESPONSEMESSAGE, "There was a problem getting the position")
    } else {
        result := Format("({1:i}, {2:i}, {3:i}, {4:i})", x, y, w, h)
        response := FormatResponse(PositionResponseMessage, result)
    }

    DetectHiddenWindows, %current_detect_hw%
    SetTitleMatchMode, %current_match_mode%
    SetTitleMatchMode, %current_match_speed%

    return response
}


AHKGetVolume(ByRef command) {
    global EXCEPTIONRESPONSEMESSAGE
    global FLOATRESPONSEMESSAGE
    device_number := command[2]

    try {
    SoundGetWaveVolume, retval, %device_number%
    } catch e {
        response := FormatResponse(EXCEPTIONRESPONSEMESSAGE, Format("There was a problem getting the volume with device of index {}", device_number))
        return response
    }
    if (ErrorLevel = 1) {
        response := FormatResponse(EXCEPTIONRESPONSEMESSAGE, Format("There was a problem getting the volume with device of index {}", device_number))
    } else {
        response := FormatResponse(FLOATRESPONSEMESSAGE, Format("{}", retval))
    }
    return response
}

AHKSoundBeep(ByRef command) {
    freq := command[2]
    duration := command[3]
    SoundBeep , %freq%, %duration%
    return FormatNoValueResponse()
}

AHKSoundGet(ByRef command) {
    global STRINGRESPONSEMESSAGE
    device_number := command[2]
    component_type := command[3]
    control_type := command[4]

    SoundGet, retval, %component_type%, %control_type%, %device_number%
    ; TODO interpret return type
    return FormatResponse(STRINGRESPONSEMESSAGE, Format("{}", retval))
}

AHKSoundSet(ByRef command) {
    device_number := command[2]
    component_type := command[3]
    control_type := command[4]
    value := command[5]
    SoundSet, %value%, %component_type%, %control_type%, %device_number%
    return FormatNoValueResponse()
}

AHKSoundPlay(ByRef command) {
    filename := command[2]
    SoundPlay, %filename%
    return FormatNoValueResponse()
}

AHKSetVolume(ByRef command) {
    device_number := command[2]
    value := command[3]
    SoundSetWaveVolume, %value%, %device_number%
    return FormatNoValueResponse()
}

CountNewlines(ByRef s) {
    newline := "`n"
    StringReplace, s, s, %newline%, %newline%, UseErrorLevel
    count := ErrorLevel
    return count
}

AHKEcho(ByRef command) {
    global STRINGRESPONSEMESSAGE
    return FormatResponse(STRINGRESPONSEMESSAGE, command)
}

AHKTraytip(ByRef command) {
    title := command[2]
    text := command[3]
    second := command[4]
    option := command[5]

    TrayTip, %title%, %text%, %second%, %option%
    return FormatNoValueResponse()
}


b64decode(ByRef pszString) {
    ; TODO load DLL globally for performance
    ; REF: https://docs.microsoft.com/en-us/windows/win32/api/wincrypt/nf-wincrypt-cryptstringtobinaryw
    ;  [in]      LPCSTR pszString,  A pointer to a string that contains the formatted string to be converted.
    ;  [in]      DWORD  cchString,  The number of characters of the formatted string to be converted, not including the terminating NULL character. If this parameter is zero, pszString is considered to be a null-terminated string.
    ;  [in]      DWORD  dwFlags,    Indicates the format of the string to be converted. (see table in link above)
    ;  [in]      BYTE   *pbBinary,  A pointer to a buffer that receives the returned sequence of bytes. If this parameter is NULL, the function calculates the length of the buffer needed and returns the size, in bytes, of required memory in the DWORD pointed to by pcbBinary.
    ;  [in, out] DWORD  *pcbBinary, A pointer to a DWORD variable that, on entry, contains the size, in bytes, of the pbBinary buffer. After the function returns, this variable contains the number of bytes copied to the buffer. If this value is not large enough to contain all of the data, the function fails and GetLastError returns ERROR_MORE_DATA.
    ;  [out]     DWORD  *pdwSkip,   A pointer to a DWORD value that receives the number of characters skipped to reach the beginning of the -----BEGIN ...----- header. If no header is present, then the DWORD is set to zero. This parameter is optional and can be NULL if it is not needed.
    ;  [out]     DWORD  *pdwFlags   A pointer to a DWORD value that receives the flags actually used in the conversion. These are the same flags used for the dwFlags parameter. In many cases, these will be the same flags that were passed in the dwFlags parameter. If dwFlags contains one of the following flags, this value will receive a flag that indicates the actual format of the string. This parameter is optional and can be NULL if it is not needed.

    cchString := StrLen(pszString)
    dwFlags := 0x00000001  ; CRYPT_STRING_BASE64: Base64, without headers.
    getsize := 0 ; When this is NULL, the function returns the required size in bytes (for our first call, which is needed for our subsequent call)
    buff_size := 0 ; The function will write to this variable on our first call
    pdwSkip := 0 ; We don't use any headers or preamble, so this is zero
    pdwFlags := 0 ; We don't need this, so make it null


    ; The first call calculates the required size. The result is written to pbBinary
    success := DllCall("Crypt32.dll\CryptStringToBinary", "Ptr", &pszString, "UInt", cchString, "UInt", dwFlags, "UInt", getsize, "UIntP", buff_size, "Int", pdwSkip, "Int", pdwFlags )
    if (success = 0) {
        return ""
    }

    ; We're going to give a pointer to a variable to the next call, but first we want to make the buffer the correct size using VarSetCapacity using the previous return value
    VarSetCapacity(ret, buff_size, 0)

    ; Now that we know the buffer size we need and have the variable's capacity set to the proper size, we'll pass a pointer to the variable for the decoded value to be written to

    success := DllCall( "Crypt32.dll\CryptStringToBinary", "Ptr", &pszString, "UInt", cchString, "UInt", dwFlags, "Ptr", &ret, "UIntP", buff_size, "Int", pdwSkip, "Int", pdwFlags )
    if (success=0) {
        return ""
    }

    return StrGet(&ret, "UTF-8")
}

CommandArrayFromQuery(ByRef text) {
    decoded_commands := []
    encoded_array := StrSplit(text, "|")
    function_name := encoded_array[1]
    encoded_array.RemoveAt(1)
    decoded_commands.push(function_name)
    for index, encoded_value in encoded_array {
        decoded_value := b64decode(encoded_value)
        decoded_commands.push(decoded_value)
    }
    return decoded_commands
}

stdin  := FileOpen("*", "r `n", "UTF-8")  ; Requires [v1.1.17+]
pyresp := ""

Loop {
    query := RTrim(stdin.ReadLine(), "`n")
    commandArray := CommandArrayFromQuery(query)
    try {
        func := commandArray[1]
        pyresp := %func%(commandArray)
    } catch e {
        pyresp := FormatResponse(EXCEPTIONRESPONSEMESSAGE, e)
    }

    if (pyresp) {
        FileAppend, %pyresp%, *, UTF-8
    } else {
        msg := FormatResponse(EXCEPTIONRESPONSEMESSAGE, Format("Unknown Error when calling {}", func))
        FileAppend, %msg%, *, UTF-8
    }
}
