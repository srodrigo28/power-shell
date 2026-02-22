# Versao 2 - basica com validacoes simples
$ErrorActionPreference = 'Stop'

try {
    if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
        throw 'Git nao encontrado.'
    }

    $isRepo = (& git rev-parse --is-inside-work-tree 2>$null)
    if ($LASTEXITCODE -ne 0 -or "$isRepo".Trim() -ne 'true') {
        git init | Out-Null
    }

    git add .

    $useCustom = Read-Host "Deseja nome para o commit? (s/n)"
    $msg = 'updated'
    if ($useCustom -match '^[sS]$') {
        $typed = Read-Host 'Digite a mensagem'
        if (-not [string]::IsNullOrWhiteSpace($typed)) {
            $msg = $typed.Trim()
        }
    }

    $hasChanges = git status --porcelain
    if (-not $hasChanges) {
        Write-Host 'Sem alteracoes para commit.' -ForegroundColor Yellow
        exit 0
    }

    git commit -m "$msg"
    git push

    Write-Host 'Seu projeto foi salvo com sucesso.' -ForegroundColor Green
}
catch {
    Write-Host "[ERRO] $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}
