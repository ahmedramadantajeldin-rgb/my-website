
$dir   = 'c:\Users\ENG  AHMED TAG\Documents\my-website'
$files = @(
    'lecture1.html','lecture2.html','lecture3.html','lecture4.html',
    'lecture5.html','lecture6.html','lecture7.html','lecture8.html',
    'sheet1.html','sheet2.html','sheet3.html','sheet4.html',
    'sheet5.html','sheet6.html','sheet7.html'
)

$sig = "`n<!-- PERSONAL SIGNATURE -->`n" +
       "<div style=""text-align:center;margin-top:50px;padding:20px;" +
       "border-top:1px solid #444;font-weight:bold;" +
       "font-family:Arial,sans-serif;color:#333;"">" +
       "Created by Mechanical Engineering Student: Ahmed Tageldien" +
       "</div>`n"

# Regex patterns: [pattern, replacement]
$pats = @(
    # hdr-badge / uni-badge containing institutional text
    @('(?is)<span[^>]*class="[^"]*hdr-badge[^"]*"[^>]*>[^<]*(university|faculty|dept)[^<]*</span>', ''),
    @('(?is)<span[^>]*class="[^"]*uni-badge[^"]*"[^>]*>[^<]*</span>', ''),
    @('(?is)<div[^>]*class="[^"]*institution[^"]*"[^>]*>[^<]*</div>', ''),

    # Full long institutional string
    @('(?i)MUST\s+University\s+of\s+Science\s*(?:&amp;|&|and)\s*Technology\s*[^\w<]{0,6}Faculty\s+of\s+Engineering\s*[^\w<]{0,6}(?:Mechanical\s+)?Dept\.?', ''),

    # Shorter variants
    @('(?i)MUST\s+University\s+of\s+Science\s*(?:&amp;|&|and)\s*Technology', ''),
    @('(?i)MUST\s+University', ''),
    @('(?i)University\s+of\s+Science\s*(?:&amp;|&|and)\s*Technology', ''),
    @('(?i)Faculty\s+of\s+Engineering', ''),
    @('(?i)Mechanical\s+Dept\.?', ''),

    # Person names
    @('(?i)Eng\.\s*Younis\s*Fakher', ''),
    @('(?i)Younis\s*Fakher', ''),
    @('(?i)Dr\.\s+[A-Za-z][A-Za-z .]{1,40}', ''),

    # Credit lines
    @('(?i)Prepared\s+by\s*:?\s*[A-Za-z .]{2,40}', ''),
    @('(?i)Presented\s+by\s*:?\s*[A-Za-z .]{2,40}', ''),
    @('(?i)Lecturer\s*:\s*[A-Za-z .]{2,40}', ''),
    @('(?i)Instructor\s*:\s*[A-Za-z .]{2,40}', '')
)

$closingBody = '</body>'
$total = 0

foreach ($f in $files) {
    $path = Join-Path $dir $f
    if (-not (Test-Path $path)) {
        Write-Host "[SKIP] $f" -ForegroundColor Yellow
        continue
    }

    $enc  = [System.Text.Encoding]::UTF8
    $orig = [System.IO.File]::ReadAllText($path, $enc)
    $c    = $orig

    foreach ($p in $pats) {
        $c = [regex]::Replace($c, $p[0], $p[1],
             [System.Text.RegularExpressions.RegexOptions]::Singleline)
    }

    # Remove any previously injected signature (idempotent)
    $c = [regex]::Replace($c,
         '(?s)\n?<!-- PERSONAL SIGNATURE -->.*?</div>',
         '',
         [System.Text.RegularExpressions.RegexOptions]::Singleline)

    # Inject signature before </body>
    $bodyTag = [regex]::Match($c, '(?i)</body>').Value
    if ($bodyTag) {
        $c = [regex]::Replace($c, '(?i)</body>', $sig + $closingBody, 1)
    }

    if ($c -ne $orig) {
        [System.IO.File]::WriteAllText($path, $c, $enc)
        Write-Host "[OK]  $f" -ForegroundColor Green
        $total++
    } else {
        Write-Host "[--]  $f  (no changes)" -ForegroundColor Cyan
    }
}

Write-Host ""
Write-Host "Batch complete. $total file(s) updated." -ForegroundColor Magenta
