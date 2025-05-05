# === ETAPA 1 ===
$caminhosPadrao = @("C:\integracao_padrao_mxm\homologacao")
$extensoesPadrao = @("*.log")

# === ETAPA 2 ===
$caminhosBase = "C:\integracao_padrao_mxm\homologacao"
$nomePastaAlvo = "sistema_padrao"
$extensoesNasPastas = @("*.txt", "*.xls", "*.xlsx")
$excecaoSubpasta = "a_processar"

# === LOG ===
$logDir = "C:\Logs"
if (-not (Test-Path $logDir)) {
    New-Item -Path $logDir -ItemType Directory -Force | Out-Null
}
$logPath = Join-Path $logDir "limpeza_arquivos_$(Get-Date -Format 'yyyyMMdd_HHmmss').log"
New-Item -Path $logPath -ItemType File -Force | Out-Null

# === DATA LIMITE ===
$limiteDias = (Get-Date).AddDays(-7)

# === FUNÇÃO: Deletar arquivos por extensão e mais antigos que 7 dias ===
function Remover-ArquivosPorExtensao {
    param (
        [string]$diretorio,
        [string[]]$filtros
    )

    if (Test-Path $diretorio) {
        foreach ($filtro in $filtros) {
            Get-ChildItem -Path $diretorio -Recurse -Filter $filtro -File  -Force -ErrorAction SilentlyContinue |
                Where-Object { $_.LastWriteTime -lt $limiteDias } | ForEach-Object {
                    $mensagem = "Deletando arquivo: $($_.FullName)"
                    Write-Output $mensagem
                    $mensagem | Out-File -FilePath $logPath -Append -Encoding utf8
                    Remove-Item $_.FullName -Force
                }
        }
    } else {
        $mensagem = "Diretório não encontrado: $diretorio"
        Write-Warning $mensagem
        $mensagem | Out-File -FilePath $logPath -Append -Encoding utf8
    }
}

# === ETAPA 1: Deletar nos diretórios padrão ===
foreach ($dir in $caminhosPadrao) {
    Write-Output "`n🧹 Limpando $dir"
    "Limpando $dir" | Out-File -FilePath $logPath -Append -Encoding utf8
    Remover-ArquivosPorExtensao -diretorio $dir -filtros $extensoesPadrao
}

# === ETAPA 2: Buscar recursivamente a pasta $nomePastaAlvo e excluir arquivos ===
$pastasAlvo = Get-ChildItem -Path $caminhosBase -Directory -Recurse -Force |
              Where-Object { $_.Name -ieq $nomePastaAlvo }

foreach ($pasta in $pastasAlvo) {
    # Ignora se a subpasta for a_processar
    if ($pasta.FullName -like "*\$excecaoSubpasta") {
        Write-Output "⏩ Pulando pasta excluída: $($pasta.FullName)"
        "Pulando pasta excluída: $($pasta.FullName)" | Out-File -FilePath $logPath -Append -Encoding utf8
        continue
    }

    Write-Output "`n🧹 Verificando pasta encontrada: $($pasta.FullName)"
    "Verificando pasta encontrada: $($pasta.FullName)" | Out-File -FilePath $logPath -Append -Encoding utf8
    Remover-ArquivosPorExtensao -diretorio $pasta.FullName -filtros $extensoesNasPastas
}

Write-Output "`n✅ Log gerado em: $logPath"