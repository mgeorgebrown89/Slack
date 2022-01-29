# $root = Split-Path -Parent $MyInvocation.MyCommand.Path

$pesterConfiguration = [PesterConfiguration]$pesterConfiguration

$result = Invoke-Pester -CI -PassThru -Output Detailed
$result #| ConvertTo-Json -Depth 100 | Out-File -FilePath "$root\Slack.Tests.json"

# if ($result.failedCount -ne 0) { 
#     $x = $result.failedCount
#     Write-Error "Pester returned $x errors. Build aborted."
# }
