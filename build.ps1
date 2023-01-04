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
  $env:PATH = 'C:\Program Files\Microsoft VS Code\bin;' + $env:PATH
  cinst python -y
  cinst jq -y
  cinst nodejs -y
  cinst jdk8 -y
  cinst rust -y
  cinst dotnet -y
  cinst nuget.commandline -y
  cinst terraform -y
  cinst vault -y
  cinst jmeter -y
  cinst ilspy -y
  cinst dnspy -y
  cinst freefilesync --params '/silent' -y
  cinst codeblocks -y
  cinst dos2unix -y
  cinst procexp -y 
  cinst opencover.install -y
  cinst opera -y
  cinst fsum -y
  cinst mingw -y 
  cinst make -y 
  cinst notepadplusplus -y
  cinst conemu -y
  cinst putty -y
  cinst winscp -y
  cinst dotnet -y
  cinst openssl -y
  $env:PATH = 'C:\Program Files\OpenSSL-Win64\bin;' + $env:PATH

}

function Configure-Powershell {
  mkdir -p ~/Documents/WindowsPowerShell/autoload -Force
  Copy-Item Microsoft.PowerShell_profile.ps1 ~/Documents/WindowsPowerShell/Microsoft.PowerShell_profile.ps1
  set-executionpolicy -Force AllSigned
  $cert = Get-ChildItem -recurse -path  Cert:\CurrentUser\  -CodeSigningCert
  Set-AuthenticodeSignature ~/Documents/WindowsPowerShell/Microsoft.PowerShell_profile.ps1 $cert
}

function Configure-Git {
  Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force
  PowerShellGet\Install-Module posh-git -Scope CurrentUser -Force
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
  code --install-extension mblode.pretty-formatter

#  Copy-Item keybindings.json ~\AppData\Roaming\Code\User\keybindings.json
#  Copy-Item settings.json ~\AppData\Roaming\Code\User\settings.json
}

function Configure-VisualStudio {
#  Copy-Item my.vssettings ~/my.vssettings
  Copy-Item vimrc ~/.vimrc
}

function Configure-Rust {
cd ~
git clone https://github.com/rust-lang/rust.vim .vim/pack/plugins/start/rust.vim
}

function Configure-Cert {
  Push-Location
  cinst openssl -y
  $env:PATH = 'C:\Program Files\OpenSSL-Win64\bin;' + $env:PATH
  mkdir CA
  cd .\CA\
  mkdir certs
  mkdir private
  set OPENSSL_CONF=C:\Users\test\install\workbench\CA\openssl.cnf
  set RANDFILE=C:\Users\test\install\workbench\CA\private\.rand
  openssl genrsa -out private\cakey.pem 2048
  openssl req -new -x509 -days 3650 -key private\cakey.pem -out certs\cacert.crt -subj "/CN=CA-SignPS"
  openssl genrsa -out private\userkey.pem 2048
  openssl req -new -key private\userkey.pem -reqexts v3_req -out certs\user.csr -nodes -subj "/CN=localhost"
  openssl x509 -req -days 3650 -in certs\user.csr -CA certs\cacert.crt -CAkey private\cakey.pem -extfile .\v3.cfg -extensions v3_req -out certs\user.crt
  openssl pkcs12 -export -in certs\user.crt -inkey private\userkey.pem -out certs\user.pfx -passout pass:
  Import-PfxCertificate -FilePath certs\user.pfx -CertStoreLocation Cert:\LocalMachine\Root
  Import-Certificate -FilePath certs\cacert.crt -CertStoreLocation Cert:\LocalMachine\Root
  rm -r certs
  rm -r private
  Pop-Location
}

@(
  "Configure-Cert",
  "ShowFileExtensions",
  "Install-Packages",
  "Configure-Powershell"
  "Configure-Git",
  "Configure-VSCode",
  "Configure-VisualStudio",
  "Configure-Rust" 
) | ForEach-Object {
  echo ""
  echo "***** $_ *****"
  echo ""

  # Invoke function and exit on error
  &$_ 
  if ($LastExitCode -ne 0) { Exit $LastExitCode }
}
