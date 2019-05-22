$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$here = $here -replace "\\Tests",""
$here
$module = (($MyInvocation.MyCommand) -split ".Module")[0]
Describe "$module Module Tests" {

    Context "Module Setup" {
        It "has the root module $module.psm1" {
            "$here\$module.psm1" | Should Exist
        }
   
        It "has the a manifest file of $module.psm1" {
            "$here\$module.psd1" | Should Exist
            "$here\$module.psd1" | Should -FileContentMatch "$module.psm1"
        }
   
        It "$module folder has functions" {
            "$here\*\*.ps1" | Should Exist
        }
   
        It "$module is valid PowerShell code" {
            $psFile = Get-Content -Path "$here\$module.psm1" -ErrorAction Stop
            $errors = $null
            $null = [System.Management.Automation.PSParser]::Tokenize($psFile, [ref]$errors)
            $errors.Count | Should Be 0
        }
    }
    $functions = @()
    foreach ($file in (Get-ChildItem "..\*.ps1" -Recurse)) {
        if (-not $file.Name.Contains(".Tests")) {
            $functions += $file
        }
    }
    foreach ($function in $functions) {
        $functionName = $function.Name -replace ".ps1", ""
        $directory = $function.DirectoryName
        Context "Test Function $functionName" {
            It "$functionName.ps1 should exist" {
                "$directory\$functionName.ps1" | Should Exist
            }
            It "$functionName.ps1 should have help block" {
                "$directory\$functionName.ps1" | Should -FileContentMatch '<#'
                "$directory\$functionName.ps1" | Should -FileContentMatch '#>'
            }
        
            It "$functionName.ps1 should have a SYNOPSIS section in the help block" {
                "$directory\$functionName.ps1" | Should -FileContentMatch '.SYNOPSIS'
            }
            
            It "$functionName.ps1 should have a DESCRIPTION section in the help block" {
                "$directory\$functionName.ps1" | Should -FileContentMatch '.DESCRIPTION'
            }
        
            It "$functionName.ps1 should have a EXAMPLE section in the help block" {
                "$directory\$functionName.ps1" | Should -FileContentMatch '.EXAMPLE'
            }
            
            It "$functionName.ps1 should be an advanced function" {
                "$directory\$functionName.ps1" | Should -FileContentMatch 'function'
                "$directory\$functionName.ps1" | Should -FileContentMatch 'cmdletbinding'
                "$directory\$functionName.ps1" | Should -FileContentMatch 'param'
            }
            
            It "$functionName.ps1 is valid PowerShell code" {
                $psFile = Get-Content -Path "$directory\$functionName.ps1" -ErrorAction Stop
                $errors = $null
                $null = [System.Management.Automation.PSParser]::Tokenize($psFile, [ref]$errors)
                $errors.Count | Should Be 0
            }
        }
        Context "$functionName has tests" {
            It "$functionName.Tests.ps1 should exist" {
                ".\$functionName.Tests.ps1" | Should Exist
            }
        }
    }
}
