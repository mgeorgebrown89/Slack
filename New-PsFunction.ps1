param(
    [string]
    $functionName = "New-Function1"
)

$moduleName = ($PSScriptRoot -split "\\")[-1]

$functionValue = @"
function $functionName {
    <#
    .SYNOPSIS
        ...
    .DESCRIPTION
        ...
    .EXAMPLE
        $functionName 
    #>
    [CmdletBinding()]
    param(

    )

}
"@

$functionFile = New-Item -ItemType File -Name "$functionName.ps1" -Value $functionValue

$functionTestsValue = @"
# If the module is already in memory, remove it
Get-Module $moduleName | Remove-Module -Force

# Import the module from the local path, not from the users Documents folder
Import-Module .\$moduleName\$moduleName.psm1 -Force 
`$functionName = `$MyInvocation.MyCommand -replace ".Tests.ps1",""


Describe "`$functionName | Unit Tests" -Tags "Unit" {

}

Describe "`$functionName | Acceptance Tests" -Tags "Acceptance" {
    
}

Describe "`$functionName | Integration Tests" -Tags "Integration" {
    
}
"@

$functionTestsFile = New-Item -ItemType File -Name "$functionName.Tests.ps1" -value $functionTestsValue