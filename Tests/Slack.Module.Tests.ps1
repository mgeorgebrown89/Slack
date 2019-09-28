
$repositoryRoot = Split-Path -Parent ($PSScriptRoot)
$module = Get-ChildItem -Path $RepositoryRoot -Filter 'Slack' -Directory
New-Variable -Scope global -Name SlackModulePath -Value $module.FullName -Force
$nestedModules = Get-ChildItem -Path $module.FullName -Filter ($module.Name + ".*") -Directory
    
#remove loaded module and reload it from local path
Get-Module $module.Name | Remove-Module -Force
Import-Module $module.FullName -Force 

Describe ($module.name + " | Repository Tests") {
    Context ($module.name + "| Repository Folder Structure") {
        It "has the correct folders and folder structure" {
            $repositoryRoot | Should Exist
            "$repositoryRoot/.github" | Should Exist
            "$repositoryRoot/.github/workflows" | Should Exist
            "$repositoryRoot/.github/workflows/Deploy-SlackModule.ps1" | Should Exist
            "$repositoryRoot/.github/workflows/Install-PesterModule.ps1" | Should Exist
            "$repositoryRoot/.github/workflows/Invoke-PesterTests.ps1" | Should Exist
            "$repositoryRoot/.github/workflows/Publish-PesterTests.ps1" | Should Exist
            "$repositoryRoot/.github/workflows/pull_request.yml" | Should Exist
            "$repositoryRoot/.github/workflows/push.yml" | Should Exist
            "$repositoryRoot/.github/workflows/release.yml" | Should Exist
            "$repositoryRoot/Media" | Should Exist
            ("$repositoryRoot/" + $module.Name) | Should Exist
            "$repositoryRoot/Tests" | Should Exist
            "$repositoryRoot/Utilities" | Should Exist
            "$repositoryRoot/.gitignore" | Should Exist
            "$repositoryRoot/LICENSE" | Should Exist
            "$repositoryRoot/README.md" | Should Exist
        }
    }
}
Describe ($module.Name + " | Root Module Tests") {
    InModuleScope -ModuleName $module.Name {
        $rootModuleFolder = ("$repositoryRoot\" + $module.Name)
        Context "Root Module Setup" {
            It "has the root module folder" {
                $rootModuleFolder | Should Exist
            }
            It "has a Public and a Private folder" {
                ($rootModuleFolder + "\Public") | Should Exist
                ($rootModuleFolder + "\Private") | Should Exist
            }
            It "has the root module and manifest files" {
                ($rootModuleFolder + "\" + $module.Name + ".psm1") | Should Exist
                ($rootModuleFolder + "\" + $module.Name + ".psd1") | Should Exist
            }
            It "is valid PowerShell code" {
                $psFile = Get-Content -Path ("$repositoryRoot\" + $module.Name + "\" + $module.Name + ".psm1") -ErrorAction Stop
                $errors = $null
                $null = [System.Management.Automation.PSParser]::Tokenize($psFile, [ref]$errors)
                $errors.Count | Should Be 0
            }
        }
        $functions = @()
        foreach ($file in ((Get-ChildItem "$rootModuleFolder\Private\*.ps1" -Recurse -File) + (Get-ChildItem "$rootModuleFolder\Public\*.ps1" -Recurse -File))) {
            if (-not $file.Name.Contains(".Tests")) {
                $functions += $file
            }
        }
        foreach ($function in $functions) {
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
            Context "Function $functionName Tests" {
                It "$functionName.Tests.ps1 should exist" {
                    [bool](Test-Path (Split-Path -Parent $PSScriptRoot) ) | Should Be $true
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
foreach ($nestedModule in $nestedModules) {
    Describe ($nestedModule.Name + " | Root Module Tests") {
        InModuleScope -ModuleName $module.Name {
            $rootModuleFolder = ("$repositoryRoot\" + $module.Name + "\" + $nestedModule.Name)
            Context "Root Module Setup" {
                It "has the root module folder" {
                    $rootModuleFolder | Should Exist
                }
                It "has a Public and a Private folder" {
                    ($rootModuleFolder + "\Public") | Should Exist
                    ($rootModuleFolder + "\Private") | Should Exist
                }
                It "has the root module files" {
                    ($rootModuleFolder + "\" + $nestedModule.Name + ".psm1") | Should Exist
                }
                It "is valid PowerShell code" {
                    $psFile = Get-Content -Path ("$rootModuleFolder\" + $nestedModule.Name + ".psm1") -ErrorAction Stop
                    $errors = $null
                    $null = [System.Management.Automation.PSParser]::Tokenize($psFile, [ref]$errors)
                    $errors.Count | Should Be 0
                }
            }
            $functions = @()
            <#foreach ($file in (Get-ChildItem "$rootModuleFolder\Private\*.ps1" -Recurse -File)) {
                    if (-not $file.Name.Contains(".Tests")) {
                        $functions += $file
                    }
                }#>
            foreach ($file in (Get-ChildItem "$rootModuleFolder\Public\*.ps1" -Recurse -File)) {
                if (-not $file.Name.Contains(".Tests")) {
                    $functions += $file
                }
            }
            foreach ($function in $functions) {
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
                Context "Function $functionName Tests" {
                    It "$functionName.Tests.ps1 should exist in a matching path to $functionName.ps1" {
                        $testPathLocation = ($Function.FullName -split "Slack\\Slack")[1]
                        $testPath = ($PSScriptRoot + $testPathLocation) -replace ".ps1", ".Tests.ps1"
                        [bool](Test-Path $testPath) | Should Be $true
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


<#end {
    Describe "$module | Module MetaData" {
        InModuleScope -ModuleName Slack {
            Context "Root Module Setup" {
                It "has the root module $module.psm1" {
                    "$ModuleRootPath\$module.psm1" | Should Exist
                }
       
                It "has the manifest file of $module.psd1" {
                    "$ModuleRootPath\$module.psd1" | Should Exist
                    "$ModuleRootPath\$module.psd1" | Should -FileContentMatch "$module.psm1"
                    "$ModuleRootPath\$module.psd1" | Should -FileContentMatch "$module.Blocks"
                    "$ModuleRootPath\$module.psd1" | Should -FileContentMatch "$module.Emoji"
                    "$ModuleRootPath\$module.psd1" | Should -FileContentMatch "$module.WebAPI"
                }
       
                It "is valid PowerShell code" {
                    $psFile = Get-Content -Path "$ModuleRootPath\$module.psm1" -ErrorAction Stop
                    $errors = $null
                    $null = [System.Management.Automation.PSParser]::Tokenize($psFile, [ref]$errors)
                    $errors.Count | Should Be 0
                }

                $nestedModules = Get-ChildItem -Path .\Slack -Filter "Slack.*" -Directory

                foreach ($nestedModule in $nestedModules.Name) {
                    It "has the nested module $nestedModule folders" {
                        $nestedModules.Name | Should -Be @("Slack.Blocks", "Slack.Emoji", "Slack.WebAPI")
                    }
                }
            }
            $functions = @()
    
            foreach ($file in (Get-ChildItem "$ModuleRootPath\*.ps1" -Recurse -File)) {
                if (-not $file.Name.Contains(".Tests")) {
                    $functions += $file
                }
            }
            foreach ($function in $functions) {
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
                        ($ParsedPsfile | Where-Object Type -EQ Comment)[0].Content | Should -Match '#$'
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
                        It "parameter `"$param`" has a .PARAMETER description" {
                            (Get-Help $functionName -Parameter $param).description | Should -Not -BeNullOrEmpty
                        }
                    }
                    It "has at least one EXAMPLE in the help block" {
                        $scripthelp.examples.example.Count | Should -BeGreaterThan 0
                    }
                }
                Context "Function $functionName Tests" {
                    It "$functionName.Tests.ps1 should exist" {
                        [bool](Test-Path (Split-Path -Parent $PSScriptRoot) ) | Should Be $true
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
#>
