# Simple function for applying template-based config files
function Set-ContentFromTemplate {
  Param($Path, $TemplatePath, $Parameters)
  $content = Get-Content "$TemplatePath"
  foreach ($paramName in $Parameters.Keys) {
    $content = $content.replace("{{ ${paramName} }}", $Parameters.Item($paramName))
  }
  Set-Content -Path $Path -Value $content
}

function ShowFileExtensions() 
{
    Push-Location
    Set-Location HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced
    Set-ItemProperty . HideFileExt "0"
    Pop-Location
}

$buildParameters = $args[0]

function Install-Packages {
  cinst git -y
  cinst grep -y
  cinst vim -y
  cinst gitextensions -y
  cinst openssh -y
  cinst visualstudiocode --params '/NoDesktopIcon' -y
  cinst nodejs -y
  cinst nuget.commandline -y
  cinst terraform -y
  cinst vault -y
  cinst python -y
  cinst jq -y
  cinst jdk8 -y
}

function Configure-Powershell {
  mkdir -p ~/Documents/WindowsPowerShell/autoload -Force
  Copy-Item Microsoft.PowerShell_profile.ps1 ~/Documents/WindowsPowerShell/Microsoft.PowerShell_profile.ps1
}

function Configure-Git {
  PowerShellGet\Install-Module posh-git -Scope CurrentUser -Confirm
  Update-Module posh-git
  Set-ContentFromTemplate -Path ~/.gitconfig -TemplatePath gitconfig -Parameters $buildParameters
}

function Configure-VSCode {
  code --install-extension vscodevim.vim
  code --install-extension ms-dotnettools.csharp
  code --install-extension formulahendry.dotnet-test-explorer
  code --install-extension ms-mssql.mssql
  code --install-extension ms-vscode.PowerShell
  code --install-extension hashicorp.terraform
  code --install-extension rebornix.ruby
  code --install-extension mshdinsight.azure-hdinsight 
  code --install-extension scalameta.metals
  code --install-extension lextudio.restructuredtext

#  Copy-Item keybindings.json ~\AppData\Roaming\Code\User\keybindings.json
#  Copy-Item settings.json ~\AppData\Roaming\Code\User\settings.json
}

function Configure-VisualStudio {
#  Copy-Item my.vssettings ~/my.vssettings
  Copy-Item vimrc ~/.vimrc
}


@(
  "ShowFileExtensions",
  "Install-Packages",
  "Configure-Powershell",
  "Configure-Git",
  "Configure-VSCode",
  "Configure-VisualStudio"
) | ForEach-Object {
  echo ""
  echo "***** $_ *****"
  echo ""

  # Invoke function and exit on error
  &$_ 
  if ($LastExitCode -ne 0) { Exit $LastExitCode }
}