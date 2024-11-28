# Lista de diretórios
$directories = @(
# Separar diretórios por vírgola
# Adicione mais diretórios conforme necessário
    "C:\Teste\"
)
# Extensão do arquivo e data limite
$fileExtension = ".log"
# Data tem duas opções, a segunda está comentada.
$dateLimit = Get-Date "09/01/2024"
#date_limit = Get-Date).AddDays(-7)

foreach ($directory in $directories) {
    Get-ChildItem -Path $directory -Recurse -Filter "*$fileExtension" | Where-Object {
        $_.LastWriteTime -lt $dateLimit
    } | ForEach-Object {
        Remove-Item -Path $_.FullName -Force
        Write-Host "$($_.Name) deletado de $($_.DirectoryName)"
    }
}
