Set-ExecutionPolicy RemoteSigned -Scope CurrentUser

# Script de Configuração Rápida do Git
Write-Host "--- Configuração do Git ---" -ForegroundColor Cyan

# 1. Coleta de informações
$gitName = Read-Host "Sebatião Rodrigo Nacimento Sousa"
$gitEmail = Read-Host "rodrigoexer1@gmail.com"

# 2. Configurações Globais
git config --global user.name "$gitName"
git config --global user.email "$gitEmail"
git config --global core.editor "code --wait"
git config --global init.defaultBranch main

# 3. Melhorias de Interface (Cores e Atalhos)
git config --global color.ui auto
git config --global alias.st status
git config --global alias.cm "commit -m"
git config --global alias.br branch

Write-Host "`n[OK] Nome, E-mail e Atalhos configurados!" -ForegroundColor Green

# 4. Geração de Chave SSH (Opcional)
$setupSSH = Read-Host "Deseja gerar uma nova chave SSH para o GitHub? (s/n)"
if ($setupSSH -eq "s") {
    $sshPath = "$HOME\.ssh\id_ed25519"
    if (Test-Path $sshPath) {
        Write-Host "Uma chave SSH já existe neste computador." -ForegroundColor Yellow
    } else {
        ssh-keygen -t ed25519 -C "$gitEmail" -f $sshPath -N '""'
        Start-Service ssh-agent
        ssh-add $sshPath
        
        $pubKey = Get-Content "$sshPath.pub"
        $pubKey | Set-Clipboard
        
        Write-Host "`n[SUCESSO] Chave SSH gerada e copiada para o seu CLIPBOARD!" -ForegroundColor Magenta
        Write-Host "Agora, basta colar no seu Perfil do GitHub (Settings > SSH and GPG keys)." -ForegroundColor Cyan
    }
}

Write-Host "`n--- Configuração Concluída! ---" -ForegroundColor Green
git config --list --global