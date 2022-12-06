
Import-Module posh-git
$GitPromptSettings.WorkingColor.ForegroundColor = 'White'
$GitPromptSettings.DefaultPromptWriteStatusFirst = $true
$GitPromptSettings.DefaultPromptPath.ForegroundColor = 'Orange'
$GitPromptSettings.DefaultPromptBeforeSuffix.Text = '`n'