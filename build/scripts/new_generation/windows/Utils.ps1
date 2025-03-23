function Error-Handler {
    param (
        [int]$ParentLineNo,
        [string]$Message,
        [int]$Code = 1,
        [string]$LogFile
    )

    if (-not [string]::IsNullOrEmpty($Message)) {
        Write-Host -ForegroundColor DarkRed "[ERROR] On or near line $ParentLineNo with message `"$Message`" exiting with status `"$Code`""
    } else {
        Write-Host -ForegroundColor DarkRed "[ERROR] On or near line $ParentLineNo; exiting with status `"$Code`""
    }

    if (-not [string]::IsNullOrEmpty($LogFile)) {
        Write-Host -ForegroundColor DarkRed "[BEGIN] LOG"
        Write-Host -NoNewline ""
        Get-Content $LogFile
        Write-Host -ForegroundColor DarkRed "[END] LOG"
    }

    exit $Code
}

function Assert-Condition {
    param (
        [string]$Command,
        [string]$Message,
        [string]$LogFile
    )

    if ([string]::IsNullOrEmpty($Command.Trim())) {
        Error-Handler -ParentLineNo $MyInvocation.ScriptLineNumber -Message "Expected a command as the first argument of the Assert-Condition function" -Code 12
    }

    if ([string]::IsNullOrEmpty($LogFile)) {
      $LogFile = New-TemporaryFile
    }

    try {
        Invoke-Expression $Command | Out-File -FilePath $LogFile
        if ($LASTEXITCODE -ne 0) {
          throw "Command failed"
        }
    }
    catch {
        Error-Handler -ParentLineNo $MyInvocation.ScriptLineNumber -Message $Message -Code 11 -LogFile $LogFile
    }
}
