$path = Join-Path $PSScriptRoot 'lecture7.html'
$content = [System.IO.File]::ReadAllText($path)

# lecture7 uses &#128214; and has active styling on Lec 7
$search = 'border-bottom-color:#f5c842;">&#128214; Lec 7<br>Shafts</a>' + "`n" + '</nav>'
$replace = 'border-bottom-color:#f5c842;">&#128214; Lec 7<br>Shafts</a>' + "`n" + '  <a href="lecture8.html" style="border-top-color:#2c5282; border-bottom-color:transparent;">&#128214; Lec 8<br>Shaft Design</a>' + "`n" + '</nav>'

if ($content.Contains($search)) {
    $content = $content.Replace($search, $replace)
    [System.IO.File]::WriteAllText($path, $content)
    Write-Host "lecture7.html updated successfully"
} else {
    # Try CRLF
    $search2 = 'border-bottom-color:#f5c842;">&#128214; Lec 7<br>Shafts</a>' + "`r`n" + '</nav>'
    $replace2 = 'border-bottom-color:#f5c842;">&#128214; Lec 7<br>Shafts</a>' + "`r`n" + '  <a href="lecture8.html" style="border-top-color:#2c5282; border-bottom-color:transparent;">&#128214; Lec 8<br>Shaft Design</a>' + "`r`n" + '</nav>'
    if ($content.Contains($search2)) {
        $content = $content.Replace($search2, $replace2)
        [System.IO.File]::WriteAllText($path, $content)
        Write-Host "lecture7.html updated successfully (CRLF)"
    } else {
        Write-Host "Pattern not found in lecture7.html"
        # Show broader context
        $idx = $content.IndexOf('Lec 7')
        $snippet = $content.Substring($idx - 20, 300)
        Write-Host ($snippet -replace "`r", '\r' -replace "`n", '\n')
    }
}
