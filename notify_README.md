# Claude Code 桌面通知配置教程

## 简介

本配置用于在 Claude Code 执行权限请求或任务完成时发送 Windows 桌面通知。

## 安装 BurntToast 模块

BurntToast 提供更丰富的通知样式，建议安装。

### PowerShell 命令安装

以管理员身份运行 PowerShell，执行：

```powershell
Install-Module -Name BurntToast -Scope CurrentUser
```

### 验证安装

```powershell
Get-Module -ListAvailable -Name BurntToast
```

如果未安装，脚本会自动使用 Windows Forms 作为备选方案（无自定义图标和声音）。

## 文件说明

| 文件 | 说明 |
|------|------|
| `notify.ps1` | 通知脚本 |
| `robot.png` | 通知图标 |

## 配置步骤

### 1. 复制文件

找到你的 **.claude 文件夹**（在用户目录下）：

```
C:\Users\你的用户名\.claude\hooks\
```

如果没有 `hooks` 文件夹，请自行创建。

将 `notify.ps1` 和 `robot.png` 复制到这个文件夹。

### 2. 修改 settings.json

打开 Claude Code 配置文件（和 hooks 文件夹在同一目录）：

```
C:\Users\你的用户名\.claude\settings.json
```

在 `"hooks": {` 后面添加以下内容：

```json
"PermissionRequest": [
  {
    "matcher": "*",
    "hooks": [
      {
        "type": "command",
        "command": "powershell.exe -File \"C:/Users/你的用户名/.claude/hooks/notify.ps1\" -Type permission"
      }
    ]
  }
],
"Stop": [
  {
    "matcher": "*",
    "hooks": [
      {
        "type": "command",
        "command": "powershell.exe -File \"C:/Users/你的用户名/.claude/hooks/notify.ps1\" -Type stop"
      }
    ]
  }
]
```

> **注意**：请将 `你的用户名` 替换为你电脑的实际用户名！

### 3. 重启 Claude Code

重启后配置生效。

## 可选：修改通知声音

编辑 `notify.ps1` 文件，找到以下代码：

```powershell
if ($Type -eq "stop") {
    $Message = "..."
    $AudioSource = 'ms-winsoundevent:Notification.Reminder'  # 修改这里
} else {
    $Message = "..."
    $AudioSource = 'ms-winsoundevent:Notification.Looping.Alarm10'
}
```

### 可用声音列表

| 声音 | 说明 |
|------|------|
| `Notification.Looping.Alarm10` | 警报声（适合权限请求） |
| `Notification.Reminder` | 提醒声 |
| `Notification.Default` | 系统默认 |
| `Notification.IM` | 消息提示音 |
| `Notification.Mail` | 邮件通知音 |

## 通知效果

- **PermissionRequest**: "◉ 等待授权确认" + 警报声
- **Stop**: "✓ 任务已完成" + 提醒声



<video width="600" controls>   <source src="https://img.caozihang.com/img/20260304153330400.mp4" type="video/mp4">   您的浏览器不支持 video 标签。 </video>
