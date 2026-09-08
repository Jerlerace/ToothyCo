# Reconstruct split APK files recursively in the current directory
Get-ChildItem -Recurse -Filter "*.apk.part1" | ForEach-Object {
    $Part1Path = $_.FullName
    $OriginalPath = $Part1Path.Substring(0, $Part1Path.Length - 6) # Strip '.part1'
    Write-Host "Reconstructing $OriginalPath..." -ForegroundColor Cyan

    $PartNum = 1
    $Parts = @()
    while ($true) {
        $PartName = "$OriginalPath.part$PartNum"
        if (Test-Path $PartName) {
            $Parts += $PartName
            $PartNum++
        } else {
            break
        }
    }

    if ($Parts.Count -gt 0) {
        $FileStream = [System.IO.File]::Create($OriginalPath)
        foreach ($Part in $Parts) {
            Write-Host "  Reading $Part..."
            $Bytes = [System.IO.File]::ReadAllBytes($Part)
            $FileStream.Write($Bytes, 0, $Bytes.Length)
        }
        $FileStream.Close()
        Write-Host "  Successfully reconstructed $OriginalPath!" -ForegroundColor Green
    } else {
        Write-Host "  No parts found for $OriginalPath!" -ForegroundColor Red
    }
}
