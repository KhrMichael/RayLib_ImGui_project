$BUILD_DIR = "build"
$executablePath = Join-Path -Path $BUILD_DIR -ChildPath "HolyLight.exe"

Start-Process -FilePath $executablePath -Wait
