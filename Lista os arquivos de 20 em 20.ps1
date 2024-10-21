# Lista de diretórios
$directories = @(
    "C:\Teste\"
    # Adicione mais diretórios conforme necessário
)

# Extensão do arquivo e data limite
$fileExtension = ".log"
$dateLimit = Get-Date "10/01/2024"

# Encontrar todos os arquivos que correspondem aos critérios
$filesToDelete = @()
foreach ($directory in $directories) {
    $filesToDelete += Get-ChildItem -Path $directory -Recurse -Filter "*$fileExtension" | Where-Object {
        $_.LastWriteTime -lt $dateLimit
    }
}

# Dividir os arquivos em grupos de 20
for ($i = 0; $i -lt $filesToDelete.Count; $i += 20) {
    $batch = $filesToDelete[$i..[Math]::Min($i + 19, $filesToDelete.Count - 1)]
    $batch | ForEach-Object { Write-Host $_.FullName }
    $confirmation = Read-Host "Deseja deletar esses arquivos? (s/n)"
    
    if ($confirmation -eq "s") {
        $batch | ForEach-Object {
            Remove-Item -Path $_.FullName -Force
            Write-Host "$($_.Name) deletado de $($_.DirectoryName)"
        }
    } else {
        Write-Host "Nenhum arquivo deste lote foi deletado."
    }
}
