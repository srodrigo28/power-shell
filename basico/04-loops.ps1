Write-Host "Contagem com for:"
for ($i = 1; $i -le 5; $i++) {
    Write-Host "Passo $i"
}

Write-Host "`nItens com foreach:"
$itens = "teclado", "mouse", "monitor"
foreach ($item in $itens) {
    Write-Host "Item: $item"
}
