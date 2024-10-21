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
