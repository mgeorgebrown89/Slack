$functionName = ""
Get-ChildItem "$PSScriptRoot" -File -Recurse -Filter "*$functionName.Tests.ps1"