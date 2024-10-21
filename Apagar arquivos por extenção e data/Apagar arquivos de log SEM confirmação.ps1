# Lista de diretórios
$directories = @(
    "C:\Teste\"
    # Adicione mais diretórios conforme necessário
)

# Extensão do arquivo e data limite
$fileExtension = ".log"
$dateLimit = (Get-Date).AddDays(-7)

foreach ($directory in $directories) {
    Get-ChildItem -Path $directory -Recurse -Filter "*$fileExtension" | Where-Object {
        $_.LastWriteTime -lt $dateLimit
    } | ForEach-Object {
        Remove-Item -Path $_.FullName -Force
        Write-Host "$($_.Name) deletado de $($_.DirectoryName)"
    }
}
