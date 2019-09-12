# Generic module deployment.
# This stuff should be moved to psake for a cleaner deployment view

# ASSUMPTIONS:

# folder structure of:
# - RepoFolder
#   - This PSDeploy file
#   - ModuleName
#     - ModuleName.psd1

# Nuget key in $ENV:NugetApiKey

# Set-BuildEnvironment from BuildHelpers module has populated ENV:BHProjectName

# Publish to gallery with a few restrictions

Deploy Module {
    By PSGalleryModule {
        FromSource $ENV:BHPSModulePath
        To PSGallery
        WithOptions @{
            ApiKey = $ENV:PSGALLERY_TOKEN
        }
    }
}
