$module = (($MyInvocation.MyCommand) -split "\.Module")[0]
$module

$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$here = $here -replace "\\Tests","\$module"
$here

Describe "$module Module Tests" {

    Context "Module Setup" {
        It "has the root module $module.psm1" {
            "$here\$module.psm1" | Should Exist
        }
   
        It "has the a manifest file of $module.psm1" {
            "$here\$module.psd1" | Should Exist
            "$here\$module.psd1" | Should -FileContentMatch "$module.psm1"
        }
   
        It "is valid PowerShell code" {
            $psFile = Get-Content -Path "$here\$module.psm1" -ErrorAction Stop
            $errors = $null
            $null = [System.Management.Automation.PSParser]::Tokenize($psFile, [ref]$errors)
            $errors.Count | Should Be 0
        }
    }
    $functions = @()
    $PSScriptRoot
    foreach ($file in (Get-ChildItem "$here\Private\*.ps1" -Recurse)) {
        if (-not $file.Name.Contains(".Tests")) {
            $functions += $file
        }
    }
    foreach ($file in (Get-ChildItem "$here\Public\*.ps1" -Recurse)) {
        if (-not $file.Name.Contains(".Tests")) {
            $functions += $file
        }
    }
    foreach ($function in $functions) {
        $functionName = $function.Name -replace ".ps1", ""
        $directory = $function.DirectoryName
        Context "Function $functionName Setup" {
            It "exists" {
                "$directory\$functionName.ps1" | Should Exist
            }
            It "has a help block" {
                "$directory\$functionName.ps1" | Should -FileContentMatch '<#'
                "$directory\$functionName.ps1" | Should -FileContentMatch '#>'
            }
            It "has a SYNOPSIS section in the help block" {
                "$directory\$functionName.ps1" | Should -FileContentMatch '.SYNOPSIS'
            }
            It "should have a DESCRIPTION section in the help block" {
                "$directory\$functionName.ps1" | Should -FileContentMatch '.DESCRIPTION'
            }
            It "has an EXAMPLE section in the help block" {
                "$directory\$functionName.ps1" | Should -FileContentMatch '.EXAMPLE'
            }

            $psFile = Get-Content -Path "$directory\$functionName.ps1" -ErrorAction Stop
            $parsedPsfile = [System.Management.Automation.PSParser]::Tokenize($psfile,[ref]$null)
            $func = $parsedPsfile | Where-Object Type -eq keyword | Where-Object Content -eq "function"
            It "is an advanced function" {
                "$directory\$functionName.ps1" | Should -FileContentMatch 'function'
                "$directory\$functionName.ps1" | Should -FileContentMatch 'cmdletbinding'
                "$directory\$functionName.ps1" | Should -FileContentMatch 'param'
            }
            It "has only one function in script file" {
                $func | Should -HaveCount 1
            }
            It "has matching file and function names" {
                (($parsedPsfile | Where-Object Start -gt $func.Start)[0]).Content | Should -Match $functionName
            }
            It "is valid PowerShell code" {
                $errors = $null
                $null = [System.Management.Automation.PSParser]::Tokenize($psFile, [ref]$errors)
                $errors.Count | Should Be 0
            }
        }
        Context "Function $functionName Tests" {
            It "$functionName.Tests.ps1 should exist" {
                ".\Tests\$functionName.Tests.ps1" | Should Exist
            }
        }
    }
}