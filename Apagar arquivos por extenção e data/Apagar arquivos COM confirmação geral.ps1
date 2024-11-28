#Lista de diretórios
    $directories = @(
    # Separar diretórios por vírgola
    # Adicione mais diretórios conforme necessário
    "C:\Teste\"
    )
#Extensão do arquivo e data limite
    $fileExtension = ".log"
    # Data tem duas opções, a segunda está comentada.
    $dateLimit = (Get-Date).AddDays(-7)
   #$dateLimit = Get-Date "10/15/2024"

# Encontrar todos os arquivos que correspondem aos critérios
$filesToDelete = @()
foreach ($directory in $directories) {
    $filesToDelete += Get-ChildItem -Path $directory -Recurse -Filter "*$file_extension" | Where-Object {
        $_.LastWriteTime -lt $date_limit
    }
}

# Exibir lista de arquivos e pedir confirmação
$filesToDelete | ForEach-Object { Write-Host $_.FullName }
$confirmation = Read-Host "Deseja deletar todos esses arquivos? (s/n)"

if ($confirmation -eq "s") {
    $filesToDelete | ForEach-Object {
        Remove-Item -Path $_.FullName -Force
        Write-Host "$($_.Name) deletado de $($_.DirectoryName)"
    }
} else {
    Write-Host "Nenhum arquivo foi deletado."
}
