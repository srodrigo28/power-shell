$numero = [int](Read-Host "Digite um numero")

if ($numero -gt 0) {
    Write-Host "Numero positivo"
} elseif ($numero -lt 0) {
    Write-Host "Numero negativo"
} else {
    Write-Host "Zero"
}
