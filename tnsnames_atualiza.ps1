# Caminho do arquivo que voce deseja copiar
$SourceFile = "C:\Users\matheus.adm\Documents\tnsnames.ora"

# Lista de pastas de destino
$DestinationFolders = @(
    "\\localhost\NETLOGON\ATUALIZA_TNSNAMES\DPCSistemas\DPC1",
	"\\localhost\NETLOGON\ATUALIZA_TNSNAMES\DPCSistemas\DPCWEB2",
	"\\localhost\NETLOGON\ATUALIZA_TNSNAMES\DPCSistemas\DPCWEB3",
	"\\localhost\NETLOGON\ATUALIZA_TNSNAMES\DPCSistemas\DPCWEB4HOM",
	"\\localhost\NETLOGON\ATUALIZA_TNSNAMES\DPCSistemas\PDB1_RJ",
	"\\localhost\NETLOGON\ATUALIZA_TNSNAMES\DPCSistemas",
	"\\localhost\NETLOGON\ATUALIZA_TNSNAMES\oracle\product\10.2.0\client_1\network\admin",
	"\\localhost\NETLOGON\ATUALIZA_TNSNAMES\oracle\product\11.2.0\client_1\network\admin",
	"\\localhost\NETLOGON\ATUALIZA_TNSNAMES\oracle\product\19.0.0\client_1\network\admin",
	"\\localhost\NETLOGON\ATUALIZA_TNSNAMES\oracle\WINDOWS.X64_193000_client_home\network\admin",
	"\\localhost\NETLOGON\ATUALIZA_TNSNAMES\orant\network\ADMIN",
	"\\localhost\NETLOGON\ATUALIZA_TNSNAMES\orant64\network\ADMIN"
)

# Loop para copiar o arquivo para cada pasta de destino
foreach ($Folder in $DestinationFolders) {
    $DestinationFile = Join-Path -Path $Folder -ChildPath (Split-Path -Leaf $SourceFile)
    Copy-Item -Path $SourceFile -Destination $DestinationFile -Force
    Write-Output "Arquivo copiado para $Folder"
}
Write-Output "Arquivos copiados com sucesso."

#-------------------------------------------------------------------------------------------------------------------

# Define o caminho do arquivo a ser apagado
$ArquivoDelete = "\\localhost\NETLOGON\ATUALIZA_TNSNAMES\DPCSistemas\padrao.ora"

# Apaga o arquivo
Remove-Item -Path $ArquivoDelete -Force

Write-Output "Arquivo $ArquivoDelete Apagado com Sucesso"

#-------------------------------------------------------------------------------------------------------------------

# Define o caminho do arquivo original e o novo nome
$ArquivoOriginal = "\\localhost\NETLOGON\ATUALIZA_TNSNAMES\DPCSistemas\tnsnames.ora"
$NovoNome = "padrao.ora"

# Obtém o diretorio do arquivo original
$Diretorio = [System.IO.Path]::GetDirectoryName($ArquivoOriginal)

# Define o caminho completo do novo arquivo
$NovoCaminho = [System.IO.Path]::Combine($Diretorio, $NovoNome)

# Renomeia o arquivo
Rename-Item -Path $ArquivoOriginal -NewName $NovoNome

Write-Output "Arquivo renomeado para $NovoCaminho"