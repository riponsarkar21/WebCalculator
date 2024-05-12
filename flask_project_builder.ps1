# Prompt user to select multiple files
$files = [System.Windows.Forms.Application]::OpenForms | `
         Where-Object { $_.Name -eq 'OpenFileDialog' }

if (-not $files) {
    $files = New-Object System.Windows.Forms.OpenFileDialog
    $files.Multiselect = $true
    [void]$files.ShowDialog()
}

# Check if files were selected
if ($files.FileNames.Count -gt 0) {
    # Destination folders
    $destinationFolder = "C:\Users\User\Desktop\xxx"
    $templatesFolder = Join-Path -Path $destinationFolder -ChildPath "templates"
    $staticFolder = Join-Path -Path $destinationFolder -ChildPath "static"
    $directFolder = $destinationFolder

    # Ensure destination folders exist
    if (-not (Test-Path -Path $templatesFolder)) {
        New-Item -Path $templatesFolder -ItemType Directory | Out-Null
    }
    if (-not (Test-Path -Path $staticFolder)) {
        New-Item -Path $staticFolder -ItemType Directory | Out-Null
    }

    # Copy files to appropriate folders based on file extension
    foreach ($file in $files.FileNames) {
        $fileName = [System.IO.Path]::GetFileName($file)
        $fileExtension = [System.IO.Path]::GetExtension($file)

        if ($fileExtension -eq ".html") {
            $destinationPath = Join-Path -Path $templatesFolder -ChildPath $fileName
        }
        elseif ($fileExtension -eq ".css" -or $fileExtension -eq ".js") {
            $destinationPath = Join-Path -Path $staticFolder -ChildPath $fileName
        }
        elseif ($fileExtension -eq ".py") {
            $destinationPath = Join-Path -Path $directFolder -ChildPath $fileName
        }
        else {
            Write-Host "Unsupported file extension: $fileExtension"
            continue
        }

        Copy-Item -Path $file -Destination $destinationPath -Force
    }

    Write-Host "Files copied successfully to $destinationFolder"
} else {
    Write-Host "No files selected."
}

