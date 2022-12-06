Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

cinst git -y
refreshenv
mkdir ~/install
cd ~/install

$ENV:PATH="C:\Program Files\Git\bin;$ENV:PATH"

git clone https://github.com/fejpet/workbench.git

cd workbench

./build.ps1