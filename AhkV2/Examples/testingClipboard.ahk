OnClipboardChange ClipChanged

ClipChanged(clip_type) {
    ToolTip "Clipboard data type: " clip_type
    Sleep 1000
    ToolTip  ; Turn off the tip.
}