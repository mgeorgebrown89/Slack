$Classes = Get-ChildItem $PSScriptRoot -Recurse -Filter "*.cs"

foreach ($class in $Classes) {
    $classFullName = (Get-Content $class.FullName -Raw)
    if (!($classFullName -as [type])) {
        $types += $classFullName
    }
    
}
Add-Type -TypeDefinition $Types #-ErrorAction SilentlyContinue