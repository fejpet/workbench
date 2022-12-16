
# Execute preparation

Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/fejpet/workbench/main/preparation.ps1'))


# TODO
- test rust in vim syntax highlight
- Dicom inspector
- make
