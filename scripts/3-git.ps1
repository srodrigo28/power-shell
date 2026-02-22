Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function Invoke-Git {
    param(
        [Parameter(Mandatory = $true)]
        [string[]]$Args,

        [Parameter(Mandatory = $true)]
        [string]$ErrorMessage
    )

    $output = & git @Args 2>&1
    if ($LASTEXITCODE -ne 0) {
        $detail = if ($output) { ($output | Out-String).Trim() } else { 'Sem detalhes.' }
        throw "$ErrorMessage`n$detail"
    }

    return $output
}

try {
    if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
        throw 'Git nao encontrado. Instale o Git e tente novamente.'
    }

    Write-Host '1. Verificando repositorio Git...' -ForegroundColor Cyan
    $isGitRepo = (& git rev-parse --is-inside-work-tree 2>$null)

    if ($LASTEXITCODE -ne 0 -or "$isGitRepo".Trim() -ne 'true') {
        Write-Host 'Repositorio nao inicializado. Executando git init...' -ForegroundColor Yellow
        Invoke-Git -Args @('init') -ErrorMessage 'Falha ao executar git init.' | Out-Null
    }

    Write-Host 'Adicionando alteracoes com git add .' -ForegroundColor Cyan
    Invoke-Git -Args @('add', '.') -ErrorMessage 'Falha ao executar git add .' | Out-Null

    Write-Host '2. Definindo mensagem de commit...' -ForegroundColor Cyan
    $resposta = Read-Host 'Deseja informar uma mensagem de commit? (s/n)'

    $commitMessage = 'updated'
    if ($resposta -match '^[sS]$') {
        $customMessage = Read-Host 'Digite a mensagem do commit'
        if (-not [string]::IsNullOrWhiteSpace($customMessage)) {
            $commitMessage = $customMessage.Trim()
        }
    }

    $statusShort = Invoke-Git -Args @('status', '--porcelain') -ErrorMessage 'Falha ao verificar alteracoes pendentes.'
    if (-not $statusShort) {
        Write-Host 'Nenhuma alteracao para commit. Encerrando sem erro.' -ForegroundColor Yellow
        exit 0
    }

    Write-Host "Criando commit: $commitMessage" -ForegroundColor Cyan
    Invoke-Git -Args @('commit', '-m', $commitMessage) -ErrorMessage 'Falha ao criar commit.' | Out-Null

    Write-Host '3. Enviando para o remoto com git push...' -ForegroundColor Cyan
    $originUrl = Invoke-Git -Args @('remote', 'get-url', 'origin') -ErrorMessage 'Remote origin nao configurado. Configure com: git remote add origin <url>'
    if (-not $originUrl) {
        throw 'Remote origin nao configurado.'
    }

    $branch = Invoke-Git -Args @('branch', '--show-current') -ErrorMessage 'Falha ao obter branch atual.'
    $branch = "$branch".Trim()
    if ([string]::IsNullOrWhiteSpace($branch)) {
        throw 'Nao foi possivel identificar a branch atual.'
    }

    $upstreamExists = & git rev-parse --abbrev-ref --symbolic-full-name '@{u}' 2>$null
    if ($LASTEXITCODE -eq 0 -and -not [string]::IsNullOrWhiteSpace("$upstreamExists")) {
        Invoke-Git -Args @('push') -ErrorMessage 'Falha ao executar git push.' | Out-Null
    }
    else {
        Invoke-Git -Args @('push', '-u', 'origin', $branch) -ErrorMessage 'Falha ao executar git push -u origin <branch>.' | Out-Null
    }

    Write-Host '4. Seu projeto foi salvo com sucesso.' -ForegroundColor Green
}
catch {
    Write-Host "[ERRO] $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}
