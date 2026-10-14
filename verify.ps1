
$dir   = $PSScriptRoot
$files = @(
    'lecture1.html','lecture2.html','lecture3.html','lecture4.html',
    'lecture5.html','lecture6.html','lecture7.html','lecture8.html',
    'sheet1.html','sheet2.html','sheet3.html','sheet4.html',
    'sheet5.html','sheet6.html','sheet7.html'
)
$checks = @('MUST University','Faculty of Engineering','Younis Fakher','Prepared by','Instructor :','Mechanical Dept',('Ahmed ' + 'Tageldien'))

foreach ($f in $files) {
    $path    = Join-Path $dir $f
    $content = [System.IO.File]::ReadAllText($path)
    $hits    = @()
    foreach ($chk in $checks) {
        if ($content -match [regex]::Escape($chk)) { $hits += $chk }
    }
    if ($hits.Count -gt 0) {
        Write-Host "WARN  $f  -> still has: $($hits -join ', ')" -ForegroundColor Red
    } else {
        Write-Host "CLEAN $f" -ForegroundColor Green
    }
}
