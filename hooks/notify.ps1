# =============================================================================
# Claude Code 通知脚本 (Windows)
# =============================================================================
# 用途: Claude Code 权限请求/任务完成时发送桌面通知
# 平台: Windows 10/11
# =============================================================================

param(
    [string]$Type = "stop",  # permission | stop
    [string]$Title = "╔═══════ Claude Code ═══════╗"
)

# 根据类型设置不同的消息和声音
if ($Type -eq "stop") {
    $Message = "║           　 ✓ 任务已完成 ✓               ║`n║            >>> 请查看终端 <<<           ║`n╚═══════════ 　══════════╝"
    $AudioSource = 'ms-winsoundevent:Notification.Reminder'
} else {
    $Message = "║          　 ◉ 等待授权确认 ◉            ║`n║    　     >>> 请查看终端 <<<          ║`n╚═══════════ 　══════════╝"
    $AudioSource = 'ms-winsoundevent:Notification.Looping.Alarm10'
}

# ============================================================
# 1. 桌面通知模块
# ============================================================
try {
    # 方式一: 使用 BurntToast 模块 (推荐，需预先安装)
    if (Get-Module -ListAvailable -Name BurntToast) {
        Import-Module BurntToast

        $IconPath = Join-Path $PSScriptRoot "robot.png"

        $Text1 = New-BTText -Content $Title -Style Title -Align Center
        $Text2 = New-BTText -Content $Message -Style Title -Align Center
        $Image = New-BTImage -Source $IconPath -AppLogoOverride

        $Binding = New-BTBinding -Children $Text1, $Text2 -AppLogoOverride $Image
        $Visual  = New-BTVisual -BindingGeneric $Binding
        $Audio   = New-BTAudio -Source $AudioSource
        $Content = New-BTContent -Visual $Visual -Audio $Audio -Duration Short

        Submit-BTNotification -Content $Content -UniqueIdentifier "ClaudeAlert"

        Start-Job -ScriptBlock {
            param($id)
            Import-Module BurntToast
            Start-Sleep -Seconds 15
            Hide-BTNotification -UniqueIdentifier $id
        } -ArgumentList "ClaudeAlert" | Out-Null
    }
    # 方式二: 使用 Windows Forms (无需安装)
    else {
        Add-Type -AssemblyName System.Windows.Forms

        $notification = New-Object System.Windows.Forms.NotifyIcon
        $notification.Icon       = [System.Drawing.SystemIcons]::Information
        $notification.BalloonTipTitle   = $Title
        $notification.BalloonTipText     = $Message
        $notification.BalloonTipIcon     = [System.Windows.Forms.ToolTipIcon]::Info
        $notification.Visible   = $true

        # 显示通知
        $notification.ShowBalloonTip(1000)
        Start-Sleep -Milliseconds 3000

        # 释放资源
        if ($null -ne $notification) {
            $notification.Dispose()
        }
    }
}
catch {
    Write-Host "桌面 notification failed: $_" -ForegroundColor Yellow
}
