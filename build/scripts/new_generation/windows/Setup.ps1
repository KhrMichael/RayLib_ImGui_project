#Requires -Version 5.1

# Function definitions (Error-Handler and Assert-Condition) are assumed to be in Utils.ps1
# (You'd need to adapt the Error-Handler and Assert-Condition from the previous response)

$CURRENT_DIR = Split-Path -Path (Convert-Path -Path $MyInvocation.MyCommand.Path) -Parent | Split-Path -Parent # equivalent to dirname(dirname(realpath $0))
$SCRIPTS_DIR = Split-Path -Path (Convert-Path -Path $MyInvocation.MyCommand.Path) # equivalent to dirname(realpath $0))

. "$SCRIPTS_DIR/utils.ps1"

# Check for required commands
$GitExists = Get-Command git -ErrorAction SilentlyContinue
if (-not $GitExists) {
    Error-Handler -ParentLineNo $MyInvocation.ScriptLineNumber -Message '"git" does not exist' -Code 10
}

$MakeExists = Get-Command make -ErrorAction SilentlyContinue
if (-not $MakeExists) {
    Error-Handler -ParentLineNo $MyInvocation.ScriptLineNumber -Message '"make" does not exist' -Code 10
}

$TarExists = Get-Command tar -ErrorAction SilentlyContinue
if (-not $TarExists) {
    Error-Handler -ParentLineNo $MyInvocation.ScriptLineNumber -Message '"tar" does not exist' -Code 10
}

# Create temporary directory and file cleanup
$TEMP_DIR = New-TemporaryFile | Split-Path -Parent

#Set-StrictMode -Version Latest  #Consider adding this to improve robustness
#$tempfiles = @()   <-- not needed because tempfiles is never used

# Function to ensure cleanup happens.  Because PowerShell is not guaranteed to clean things when exiting,
# we are not going to use "tempfiles" at all. The mktemp replacement generates unique names.

# Trap not needed. Use Try/Finally

$LUA_DIR = Join-Path -Path $CURRENT_DIR -ChildPath "lua"
New-Item -ItemType Directory -Path $LUA_DIR -Force | Out-Null # equivalent of mkdir -p

$LUA_JIT_DIR = Join-Path -Path $LUA_DIR -ChildPath "lua_jit"
$LUA_JIT_TEMP_FILE = New-TemporaryFile

#Install LuaJIT
if (-not (Test-Path -Path $LUA_JIT_DIR -PathType Container)) {
    Write-Host -ForegroundColor DarkCyan "[Installing] luajit ..." #Use dark cyan for cross platform better
    try {
        Push-Location -Path $TEMP_DIR

        # Download, compile, and install LuaJIT
        Assert-Condition -Command "git clone https://luajit.org/git/luajit.git" -Message "Failed to clone luajit" -LogFile $LUA_JIT_TEMP_FILE
        Push-Location luajit
        Assert-Condition -Command "make" -Message "Failed to make luajit" -LogFile $LUA_JIT_TEMP_FILE
        Assert-Condition -Command "mkdir -p `"$LUA_JIT_DIR`"" -Message "Failed to create directory for luajit" -LogFile $LUA_JIT_TEMP_FILE
        Assert-Condition -Command "make install PREFIX=`"$LUA_JIT_DIR`"" -Message "Failed to install luajit" -LogFile $LUA_JIT_TEMP_FILE

        Pop-Location
        Pop-Location
        Write-Host -ForegroundColor DarkCyan "[Installed] luajit"
    }
    finally {
    }
}

$LUA_JIT_BIN_DIR = Join-Path -Path $LUA_JIT_DIR -ChildPath "bin"
$LUA_JIT_VERSION = "5.1"

$LUA_ROCKS_VERSION = "3.11.1"
$LUA_ROCKS_UNPACKED_NAME = "luarocks-$LUA_ROCKS_VERSION"
$LUA_ROCKS_ARCHIVE = "$LUA_ROCKS_UNPACKED_NAME.tar.gz"
$LUA_ROCKS_ARCHIVE_URL = "https://luarocks.org/releases/$LUA_ROCKS_ARCHIVE"
$LUA_ROCKS_DIR = Join-Path -Path $LUA_DIR -ChildPath "luarocks"
$LUA_ROCKS_TEMP_FILE = New-TemporaryFile

#Install LuaRocks
if (-not (Test-Path -Path $LUA_ROCKS_DIR -PathType Container)) {
    Write-Host -ForegroundColor DarkCyan "[Installing] LuaRocks ..."

    try {
        Push-Location -Path $TEMP_DIR

        # Download, configure, make, and install LuaRocks
        Assert-Condition -Command "Invoke-WebRequest -Uri `"$LUA_ROCKS_ARCHIVE_URL`" -OutFile `"$LUA_ROCKS_ARCHIVE`"" -Message "Failed to download luarocks" -LogFile $LUA_ROCKS_TEMP_FILE
        Assert-Condition -Command "tar -zxvf `"$LUA_ROCKS_ARCHIVE`"" -Message "Failed to unpack luarocks" -LogFile $LUA_ROCKS_TEMP_FILE
        Push-Location $LUA_ROCKS_UNPACKED_NAME
        Assert-Condition -Command "./configure --prefix=`"$LUA_ROCKS_DIR`" --lua-version=`"$LUA_JIT_VERSION`" --with-lua-bin=`"$LUA_JIT_BIN_DIR`"" -Message "Failed to configure luarocks's make" -LogFile $LUA_ROCKS_TEMP_FILE
        Assert-Condition -Command "make" -Message "Failed to make luarocks" -LogFile $LUA_ROCKS_TEMP_FILE
        Assert-Condition -Command "make install" -Message "Failed to install luarocks" -LogFile $LUA_ROCKS_TEMP_FILE

        Pop-Location
        Pop-Location
        Write-Host -ForegroundColor DarkCyan "[Installed] LuaRocks"
    }
    finally{
    }
}

Write-Host -ForegroundColor DarkCyan "[SETUP IS DONE]"
