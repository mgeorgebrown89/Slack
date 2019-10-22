$Classes = Get-ChildItem $PSScriptRoot -Recurse -Filter "*.cs"

foreach ($class in $Classes) {
    $Types += (Get-Content $class.FullName -Raw)
}
Add-Type -TypeDefinition $Types -ErrorAction SilentlyContinue