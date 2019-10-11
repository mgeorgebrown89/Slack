[CmdletBinding()]
param()

$repositoryRoot = Split-Path -Parent ($PSScriptRoot)

$repoName = Split-Path $repositoryRoot -Leaf

Describe ($repoName + " | Repository Tests") {
    Context ($repoName + "| Repository Folder Structure") {

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

            "$repositoryRoot/$repoName" | Should Exist

            "$repositoryRoot/Tests" | Should Exist

            "$repositoryRoot/Utilities" | Should Exist

            "$repositoryRoot/.gitignore" | Should Exist

            "$repositoryRoot/LICENSE" | Should Exist

            "$repositoryRoot/README.md" | Should Exist
        }
    }
}  