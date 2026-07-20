[CmdletBinding()]
param(
    [string]$RepoRoot
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

if ([string]::IsNullOrWhiteSpace($RepoRoot)) {
    $RepoRoot = Split-Path -Parent $PSScriptRoot
}

$bookRoot = Join-Path $RepoRoot 'book'
$researchRoot = Join-Path $RepoRoot 'research'
$bookFiles = Get-ChildItem -LiteralPath $bookRoot -Filter '*.md' | Sort-Object Name
$manuscript = ($bookFiles | ForEach-Object { Get-Content -LiteralPath $_.FullName -Raw -Encoding UTF8 }) -join "`n"
$references = Get-Content -LiteralPath (Join-Path $researchRoot 'references.json') -Raw -Encoding UTF8 | ConvertFrom-Json
$referenceIds = @($references | ForEach-Object { $_.id })
$citationIds = @([regex]::Matches($manuscript, '@([A-Za-z0-9-]+)') | ForEach-Object { $_.Groups[1].Value } | Sort-Object -Unique)
$missingReferenceIds = @($citationIds | Where-Object { $_ -notin $referenceIds })

$ledger = Import-Csv -LiteralPath (Join-Path $researchRoot 'evidence-ledger.csv')
$facts = @($ledger | Where-Object { $_.claim_id -like 'F-*' })
$missingFactMarkers = @($facts | Where-Object { $manuscript -notmatch [regex]::Escape($_.claim_id) })
$missingAnchors = @()
foreach ($fact in $facts) {
    $parts = $fact.manuscript_anchor -split '#', 2
    $anchorFile = Join-Path $RepoRoot $parts[0]
    $anchorText = if ($parts.Count -gt 1) { $parts[1] } else { '' }
    if (-not (Test-Path -LiteralPath $anchorFile) -or -not (Get-Content -LiteralPath $anchorFile -Raw -Encoding UTF8).Contains($anchorText)) {
        $missingAnchors += $fact.claim_id
    }
}

$figurePaths = @([regex]::Matches($manuscript, '!\[[^\]]*\]\(([^)]+)\)') | ForEach-Object { $_.Groups[1].Value })
$missingFigures = @($figurePaths | Where-Object { -not (Test-Path -LiteralPath (Join-Path $bookRoot $_)) })
$chapterManifest = Import-Csv -LiteralPath (Join-Path $bookRoot 'chapter-manifest.csv')
$figureManifest = Import-Csv -LiteralPath (Join-Path $RepoRoot 'assets\figures\figure-manifest.csv')
$figureIds = @($figureManifest | ForEach-Object { $_.figure_id })
$missingManifestChapterFiles = @($chapterManifest | Where-Object { -not (Test-Path -LiteralPath (Join-Path $bookRoot $_.file)) })
$missingManifestFigureIds = @($chapterManifest | Where-Object { -not [string]::IsNullOrWhiteSpace($_.figure_id) -and $_.figure_id -notin $figureIds })
$plannedChapters = @($chapterManifest | Where-Object { $_.status -eq 'planned' })
$cjkCharacters = ([regex]::Matches($manuscript, '[\u3400-\u9FFF]')).Count
$candidateClaims = @($ledger | Where-Object { $_.status -eq 'candidate' })

$summary = [pscustomobject]@{
    CjkCharacters = $cjkCharacters
    MarkdownFiles = $bookFiles.Count
    FactClaims = $facts.Count
    CitationIds = $citationIds.Count
    MissingReferenceIds = $missingReferenceIds.Count
    MissingFactMarkers = $missingFactMarkers.Count
    MissingAnchors = $missingAnchors.Count
    MissingFigures = $missingFigures.Count
    MissingManifestChapterFiles = $missingManifestChapterFiles.Count
    MissingManifestFigureIds = $missingManifestFigureIds.Count
    PlannedChapters = $plannedChapters.Count
    CandidateClaims = $candidateClaims.Count
}
$summary | Format-List

if ($missingReferenceIds.Count -gt 0) { throw "Missing reference records: $($missingReferenceIds -join ', ')" }
if ($missingFactMarkers.Count -gt 0) { throw "Fact markers absent from manuscript: $($missingFactMarkers.claim_id -join ', ')" }
if ($missingAnchors.Count -gt 0) { throw "Fact anchors missing: $($missingAnchors -join ', ')" }
if ($missingFigures.Count -gt 0) { throw "Figure files missing: $($missingFigures -join ', ')" }
if ($missingManifestChapterFiles.Count -gt 0) { throw "Manifest chapter files missing: $($missingManifestChapterFiles.file -join ', ')" }
if ($missingManifestFigureIds.Count -gt 0) { throw "Manifest figure IDs missing: $($missingManifestFigureIds.figure_id -join ', ')" }
if ($plannedChapters.Count -gt 0) { throw "Chapter manifest still marks planned: $($plannedChapters.file -join ', ')" }
if ($candidateClaims.Count -gt 0) { throw "Candidate evidence claims remain: $($candidateClaims.claim_id -join ', ')" }
