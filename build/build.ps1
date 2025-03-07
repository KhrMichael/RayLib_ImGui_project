$BUILD_DIR = "dist"

# Check if the directory exists, if not, create it
if (-Not (Test-Path -Path $BUILD_DIR)) {
    New-Item -ItemType Directory -Path $BUILD_DIR
}

# Change to the build directory
Set-Location -Path $BUILD_DIR

# Run cmake with the Visual Studio generator (e.g., for Visual Studio 16 2019)
cmake -G "Visual Studio 16 2019" ..

# Optionally, you can build the project using MSBuild (instead of Ninja)
# For example, to build the solution:
msbuild YourProject.sln /p:Configuration=Release
