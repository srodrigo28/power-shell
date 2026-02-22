# Versao 1 - bem basica

git init 2>$null

git add .
$msg = Read-Host "Mensagem do commit (Enter para 'updated')"
if ([string]::IsNullOrWhiteSpace($msg)) { $msg = 'updated' }

git commit -m "$msg"
git push

Write-Host "Seu projeto foi salvo com sucesso."
