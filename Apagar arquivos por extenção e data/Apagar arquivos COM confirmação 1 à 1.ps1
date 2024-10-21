# Lista de diretórios
$directories = @(
    "C:\Teste\"
    # Adicione mais diretórios conforme necessário
)

# Extensão do arquivo e data limite
$fileExtension = ".log"
$dateLimit = Get-Date "09/01/2024"

foreach ($directory in $directories) {
    Get-ChildItem -Path $directory -Recurse -Filter "*$fileExtension" | Where-Object {
        $_.LastWriteTime -lt $dateLimit
    } | ForEach-Object {
        $confirmation = Read-Host "Você realmente deseja deletar $($_.FullName)? (s/n)"
        if ($confirmation -eq "s") {
            Remove-Item -Path $_.FullName -Force
            Write-Host "$($_.Name) deletado de $($_.DirectoryName)"
        } else {
            Write-Host "$($_.Name) não foi deletado."
        }
    }
}
