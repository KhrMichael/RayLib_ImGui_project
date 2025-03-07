$BUILD_DIR = "dist"
$executablePath = Join-Path -Path $BUILD_DIR -ChildPath "HolyLight.exe"

Start-Process -FilePath $executablePath -Wait
