param([ValidateSet('html','epub','docx','all')][string]$Format='all')
$ErrorActionPreference='Stop'
$repo = Split-Path -Parent $PSScriptRoot
$pandoc = 'C:\Users\dell\AppData\Local\Pandoc\pandoc.exe'
if (!(Test-Path -LiteralPath $pandoc)) { throw 'Pandoc 3.9 is required.' }
New-Item -ItemType Directory -Force -Path "$repo\dist" | Out-Null
$chapters = Get-ChildItem -LiteralPath "$repo\book" -Filter '*.md' | Where-Object Name -ne 'book.yaml' | Sort-Object Name | ForEach-Object FullName
$html = "$repo\dist\the-art-of-better.html"
& $pandoc --metadata-file "$repo\book\book.yaml" $chapters --citeproc --standalone --toc --toc-depth=2 --css ../styles/book.css --resource-path "$repo;$repo\book" -o $html
if ($LASTEXITCODE -ne 0) { throw 'HTML build failed.' }
if ($Format -in @('docx','all')) { & $pandoc --metadata-file "$repo\book\book.yaml" $chapters --citeproc --toc --toc-depth=2 --resource-path "$repo;$repo\book" -o "$repo\dist\the-art-of-better.docx"; if ($LASTEXITCODE -ne 0) { throw 'DOCX build failed.' } }
if ($Format -in @('epub','all')) { & $pandoc "$repo\book\book.yaml" $chapters --citeproc --toc --toc-depth=2 --resource-path "$repo;$repo\book" --epub-cover-image="$repo\assets\cover\cover-screen.png" -o "$repo\dist\the-art-of-better.epub"; if ($LASTEXITCODE -ne 0) { throw 'EPUB build failed.' } }
