#------------proven1
param(
    [Parameter(Mandatory=$true)]
    [ValidateSet("windows","linux")]
    [string]$Target
)

$OutputFile = "${Target}_tests.txt"
if (Test-Path $OutputFile) { Remove-Item $OutputFile }

# コミット済みの差分 Python ファイルだけ抽出
$ChangedFiles = git diff --name-only HEAD^ HEAD | Where-Object { $_ -like "*.py" }

# develop 配下かつ target コメントありのファイルだけ
foreach ($file in $ChangedFiles) 
{
    $FullPath = Join-Path $env:GITHUB_WORKSPACE $file
    if (-Not (Test-Path $FullPath)) { continue }

    $content = Get-Content $FullPath -Raw
    if ($Target -eq "windows" -and ($content -replace "`r`n"," " -match "#\s*target:windows")) 
    {
        $FullPath | Out-File -FilePath $OutputFile -Encoding utf8 -Append
    }
    elseif ($Target -eq "linux" -and ($content -replace "`r`n"," " -match "#\s*target:linux")) 
    {
        $FullPath | Out-File -FilePath $OutputFile -Encoding utf8 -Append
    }
}

if ((Test-Path $OutputFile) -and ((Get-Content $OutputFile).Length -gt 0)) 
{
    Write-Host "$Target tests found:"
    Get-Content $OutputFile
} 
else 
{
    Write-Host "No $Target tests to run"
    exit 0
}
