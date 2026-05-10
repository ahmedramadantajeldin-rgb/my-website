
$dir   = 'c:\Users\ENG  AHMED TAG\Documents\my-website'
$files = @('lecture2.html','lecture4.html','lecture8.html','sheet1.html','sheet4.html','sheet7.html')
$checks = @('MUST University','Faculty of Engineering','Younis Fakher','Prepared by','Instructor :','Mechanical Dept')

foreach ($f in $files) {
    $path    = Join-Path $dir $f
    $content = [System.IO.File]::ReadAllText($path)
    $hits    = @()
    foreach ($chk in $checks) {
        if ($content -match [regex]::Escape($chk)) { $hits += $chk }
    }
    $hasSig  = $content -match 'Ahmed Tageldien'
    $sigMark = if ($hasSig) { 'SIG:YES' } else { 'SIG:MISSING!' }
    if ($hits.Count -gt 0) {
        Write-Host "WARN  $f  -> still has: $($hits -join ', ')  | $sigMark" -ForegroundColor Red
    } else {
        Write-Host "CLEAN $f  | $sigMark" -ForegroundColor Green
    }
}
