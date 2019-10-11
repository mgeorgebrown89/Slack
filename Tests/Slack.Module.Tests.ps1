[CmdletBinding()]
param()

$repositoryRoot = Split-Path -Parent ($PSScriptRoot)
$repoName = Split-Path $repositoryRoot -Leaf
$rootModule = Get-ChildItem -Path $repositoryRoot -Filter $repoName -Directory

#remove loaded module and reload it from local path
Get-Module $rootModule.Name -Verbose | Remove-Module -Force
Import-Module $rootModule.FullName -Force

InModuleScope -ModuleName $rootModule.Name -ScriptBlock {
    $repositoryRoot = Split-Path -Parent ($PSScriptRoot)
    $repoName = ($repositoryRoot -split "\\")[-1]
    $rootModule = Get-ChildItem -Path $repositoryRoot -Filter $repoName -Directory
    $nestedModules = Get-ChildItem -Path $rootModule.FullName -Filter ($rootModule.Name + ".*") -Directory
    
    Describe ($rootModule.Name + " | Root Module Tests") {

        Context ($rootModule.Name + "| Root Module Folder Structure") { 
            It "has the root module folder" {
                $rootModule.FullName | Should Exist
            }
            It "has a Public and a Private folder" {
                ($rootModule.FullName + "\Public") | Should Exist
                ($rootModule.FullName + "\Private") | Should Exist
            }
            It "has the root module and manifest files" {
                ($rootModule.FullName + "\" + $rootModule.Name + ".psm1") | Should Exist
                ($rootModule.FullName + "\" + $rootModule.Name + ".psd1") | Should Exist
            }
        }
        Context ($rootModule.Name + " | Root Module Content") {
            It ".psd1 file references the correct .psm1 files" {
                ($rootModule.FullName + "\" + $rootModule.Name + ".psd1") | Should -FileContentMatch ($rootModule.Name + ".psm1")
                foreach ($nestedModule in $nestedModules) {
                    ($rootModule.FullName + "\" + $rootModule.Name + ".psd1") | Should -FileContentMatch ($nestedModule.Name + ".psm1")
                }
                ($rootModule.FullName + "\" + $rootModule.Name + ".psd1") | Should -FileContentMatch ($rootModule.Name + ".psm1")
            }
            It "is valid PowerShell code" {
                $psFile = Get-Content -Path ("$repositoryRoot\" + $rootModule.Name + "\" + $rootModule.Name + ".psm1") -ErrorAction Stop
                $errors = $null
                $null = [System.Management.Automation.PSParser]::Tokenize($psFile, [ref]$errors)
                $errors.Count | Should Be 0
            }
        }
        $rootModuleFunctions = @()
        foreach ($file in (Get-ChildItem ($rootModule.FullName + "\Private\*.ps1") -Recurse -File)) {
            if (-not $file.Name.Contains(".Tests")) {
                $rootModuleFunctions += $file
            }
        }
        foreach ($function in $rootModuleFunctions) {
            $functionName = $function.Name -replace ".ps1", ""
            $directory = $function.DirectoryName
            $psFile = Get-Content -Path $function.FullName -ErrorAction Stop
            $parsedPsfile = [System.Management.Automation.PSParser]::Tokenize($psfile, [ref]$null)
            $scriptHelp = Get-Help $functionName -Full -Verbose
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
                    "$directory\$functionName.ps1" | Should -FileContentMatch '.SYNOPSIS'
                    $scriptHelp.Synopsis | Should -Not -BeNullOrEmpty
                    $scriptHelp.Synopsis.Length | Should -BeGreaterOrEqual 10 -Because "Your synopsis is too short"
                }
                It "has a DESCRIPTION section in the help block" {
                    $scriptHelp.description | Should -Not -BeNullOrEmpty
                    $scriptHelp.description.text.Length | Should -BeGreaterOrEqual 25 -Because "your description is too short"
                }
                foreach ($param in $ASTParameters) {
                    It "parameter `"$param`" has a .PARAMETER description" {
                        (Get-Help $functionName -Parameter $param).description | Should -Not -BeNullOrEmpty
                    }
                }
                It "has at least one EXAMPLE in the help block" {
                    $scripthelp.examples.example.Count | Should -BeGreaterThan 0
                }
            }
            Context "Function $functionName Test File" {
                It "$functionName.Tests.ps1 should exist" {
                    [bool](Get-ChildItem "$PSScriptRoot" -File -Recurse -Filter "$functionName.Tests.ps1") | Should Be $true
                }
                It "Test file removes module and loads it locally" {
                    $testFile = Get-ChildItem "$PSScriptRoot" -File -Recurse | Where-Object Name -EQ "$functionName.Tests.ps1"
                    $testFile.FullName | Should -FileContentMatch 'Remove-Module'
                    $testFile.FullName | Should -FileContentMatch 'Import-Module'
                }
            }
        }
    }
    ####
    Describe ($rootModule.Name + " | Nested Module Tests") {
        foreach ($nestedModule in $nestedModules) {
            Context ($nestedModule.Name + "| Nested Module Folder Structure") { 
                It "has the nested module folder" {
                    $nestedModule.FullName | Should Exist
                }
                It "has a Public and a Private folder" {
                    ($nestedModule.FullName + "\Public") | Should Exist
                    ($nestedModule.FullName + "\Private") | Should Exist
                }
                It "has the nested module files" {
                    ($nestedModule.FullName + "\" + $nestedModule.Name + ".psm1") | Should Exist
                }
            }
            Context ($nestedModule.Name + "| Nested Module Content") {
                It "is valid PowerShell code" {
                    $psFile = Get-Content -Path ("$repositoryRoot\" + $rootModule.Name + "\" + $nestedModule.Name + "\" + $nestedModule.Name + ".psm1") -ErrorAction Stop
                    $errors = $null
                    $null = [System.Management.Automation.PSParser]::Tokenize($psFile, [ref]$errors)
                    $errors.Count | Should Be 0
                }
            }
            $nestedModuleFunctions = @()
            foreach ($file in ((Get-ChildItem ($nestedModule.FullName + "\Public\*.ps1") -Recurse -File))) {
                if (-not $file.Name.Contains(".Tests")) {
                    $nestedModuleFunctions += $file
                }
            }
            foreach ($function in $nestedModuleFunctions) {
                $functionName = $function.Name -replace ".ps1", ""
                $directory = $function.DirectoryName
                $psFile = Get-Content -Path $function.FullName -ErrorAction Stop
                $parsedPsfile = [System.Management.Automation.PSParser]::Tokenize($psfile, [ref]$null)
                $scriptHelp = Get-Help $functionName -Full -Verbose -ErrorAction SilentlyContinue
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
                        "$directory\$functionName.ps1" | Should -FileContentMatch '.SYNOPSIS'
                        $scriptHelp.Synopsis | Should -Not -BeNullOrEmpty
                        $scriptHelp.Synopsis.Length | Should -BeGreaterOrEqual 10 -Because "Your synopsis is too short"
                    }
                    It "has a DESCRIPTION section in the help block" {
                        $scriptHelp.description | Should -Not -BeNullOrEmpty
                        $scriptHelp.description.text.Length | Should -BeGreaterOrEqual 25 -Because "your description is too short"
                    }
                    foreach ($param in $ASTParameters) {
                        It "parameter `"$param`" has a .PARAMETER description" {
                            (Get-Help $functionName -Parameter $param).description | Should -Not -BeNullOrEmpty
                        }
                    }
                    It "has at least one EXAMPLE in the help block" {
                        $scripthelp.examples.example.Count | Should -BeGreaterThan 0
                    }
                }
                Context "Function $functionName Test File" {
                    It "$functionName.Tests.ps1 should exist" {
                        [bool](Get-ChildItem "$PSScriptRoot" -File -Recurse -Filter "$functionName.Tests.ps1") | Should Be $true
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
}
