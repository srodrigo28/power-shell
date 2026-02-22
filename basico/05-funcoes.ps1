function Somar {
    param(
        [int]$A,
        [int]$B
    )

    return $A + $B
}

$resultado = Somar -A 5 -B 7
Write-Host "Resultado: $resultado"
