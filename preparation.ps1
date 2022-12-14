# netsh winhttp import proxy source=ie
# or 
# netsh winhttp set proxy "192.168.0.14:3128"
# netsh winhttp show proxy

# $env:chocolateyProxyLocation = 'https://local/proxy/server'
# $env:chocolateyProxyUser = 'username'
# $env:chocolateyProxyPassword = 'password'

Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

cinst git -y
$env:PATH += 'C:\Program Files\Git\bin'
New-Item -path ~/install -ItemType Directory -Force
cd ~/install

git clone https://github.com/fejpet/workbench.git

cd workbench

./build.ps1 @{"git_global_name"="fejpet"; "git_global_email"="fejp3t@gmail.com"}
