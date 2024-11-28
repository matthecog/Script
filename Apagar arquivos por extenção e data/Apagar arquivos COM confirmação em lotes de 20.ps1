# Lista de diretórios
directories = @(
    "C:\Teste\"
    # Adicione mais diretórios conforme necessário
)

# Extensão do arquivo e data limite
file_extension = '.log'
date_limit = Get-Date).AddDays(-7)

# Encontrar todos os arquivos que correspondem aos critérios
$filesToDelete = @()
foreach ($directory in $directories) {
    $filesToDelete += Get-ChildItem -Path $directory -Recurse -Filter "*$file_extension" | Where-Object {
        $_.LastWriteTime -lt $date_limit
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
