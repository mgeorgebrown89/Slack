begin {
    $module = (($MyInvocation.MyCommand) -split "\.Module")[0]
    $module
    $here = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
    $ModuleRootPath = "$here\$module"

    Get-Module $module | Remove-Module -Force
    Import-Module $ModuleRootPath
}
process {
    Describe "$module | Module Tests" {

        Context "Module Setup" {
            It "has the root module $module.psm1" {
                "$ModuleRootPath\$module.psm1" | Should Exist
            }
       
            It "has the a manifest file of $module.psm1" {
                "$ModuleRootPath\$module.psd1" | Should Exist
                "$ModuleRootPath\$module.psd1" | Should -FileContentMatch "$module.psm1"
            }
       
            It "is valid PowerShell code" {
                $psFile = Get-Content -Path "$ModuleRootPath\$module.psm1" -ErrorAction Stop
                $errors = $null
                $null = [System.Management.Automation.PSParser]::Tokenize($psFile, [ref]$errors)
                $errors.Count | Should Be 0
            }
        }
        $functions = @()
    
        foreach ($file in (Get-ChildItem "$ModuleRootPath\Private\*.ps1" -Recurse)) {
            if (-not $file.Name.Contains(".Tests")) {
                #$functions += $file
            }
        }
        foreach ($file in (Get-ChildItem "$ModuleRootPath\Public\*.ps1" -Recurse)) {
            if (-not $file.Name.Contains(".Tests")) {
                $functions += $file
            }
        }
        foreach ($function in $functions) {
            $functionName = $function.Name -replace ".ps1", ""
            $directory = $function.DirectoryName
            $psFile = Get-Content -Path $function.FullName -ErrorAction Stop
            $parsedPsfile = [System.Management.Automation.PSParser]::Tokenize($psfile, [ref]$null)
            $scriptHelp = Get-Help $functionName -Full
            $notes = $scriptHelp.alertSet.alert.text -split '\n'

            $AST = [System.Management.Automation.Language.Parser]::ParseInput((Get-Content function:$functionName), [ref]$null, [ref]$null)
            $ASTParameters = $ast.ParamBlock.Parameters.Name.variablepath.userpath

            Context "Function $functionName Setup" {
                It "exists" {
                    "$directory\$functionName.ps1" | Should Exist
                }
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
            Context "Function $functionName Help" {
                It "has a Comment-Based help block" {
                    ($ParsedPsfile | Where-Object Type -EQ Comment)[0].Content | Should -Match '^<#'
                    ($ParsedPsfile | Where-Object Type -EQ Comment)[0].Content | Should -Match '#>$'
                }
                It "has a SYNOPSIS section in the help block" {
                    $scriptHelp.Synopsis | Should -Not -BeNullOrEmpty
                    $scriptHelp.Synopsis.Length | Should -BeGreaterOrEqual 10 -Because "Your synopsis is too short"
                }
                It "has a DESCRIPTION section in the help block" {
                    $scriptHelp.description | Should -Not -BeNullOrEmpty
                    $scriptHelp.description.text.Length | Should -BeGreaterOrEqual 25 -Because "your description is too short"
                }
                foreach ($param in $ASTParameters) {
                    It "parameter `"$param`" has a .PARAMTER description" {
                        (Get-Help $functionName -Parameter $param).description | Should -Not -BeNullOrEmpty
                    }
                }
                It "has at least one EXAMPLE in the help block" {
                    $scripthelp.examples.example.Count | Should -BeGreaterThan 0
                }
            }
            Context "Function $functionName Tests" {
                It "$functionName.Tests.ps1 should exist" {
                    [bool]((Test-Path "$PSScriptRoot\$functionName.Tests.ps1") -or (Test-Path "$PSScriptRoot\*\$functionName.Tests.ps1")) | Should Be $true
                }
                It "Test file removes module and loads it locally" {
                    $testFile = Get-ChildItem "$PSScriptRoot" -File -Recurse | Where-Object Name -EQ "$functionName.Tests.ps1"
                    $testFile.FullName | Should -FileContentMatch 'Remove-Module'
                    $testFile.FullName | Should -FileContentMatch 'Import-Module'
                }
            }
        }
    }
}