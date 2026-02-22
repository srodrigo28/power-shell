# 1. Inicializa a pasta como repositório Git
git init

# 2. Cria um arquivo inicial para termos o que enviar
"Meus scripts de automação PowerShell" | Out-File -FilePath README.md

# 3. Adiciona o arquivo ao palco (Stage)
git add README.md

# 4. Cria a primeira versão oficial (Commit)
git cm "Meu primeiro commit via terminal"

# 5. Conecta seu PC ao repositório do GitHub
# (Substitua a URL abaixo pela que você copiou no passo 1)
git remote add origin git@github.com:srodrigo28/powershell.git

# 6. Envia os arquivos
git push -u origin main