<#Write-Host "Installing Pester from PSGallery"
try {
    Install-PackageProvider -Name NuGet -Force -Scope CurrentUser -ErrorAction SilentlyContinue
}
catch {
    Write-Host "NuGet not needed."
} 
Install-Module -Name Pester -Force -Scope CurrentUser#>