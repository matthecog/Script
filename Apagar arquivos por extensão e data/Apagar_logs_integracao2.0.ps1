# === ETAPA 1 ===
$diretorioPadrao = "D:\producao\"
$extensoesPadrao = ".log"

# === ETAPA 2 ===
$caminhosBase = "D:\producao"
$nomePastaAlvo = "sistema_padrao"
$extensoesNasPastas = @("*.txt", "*.xls", "*.xlsx")
$excecaoSubpasta = @("a_processar", "Schemas")

# === LOG ===
$logDir = "D:\Logs"
if (-not (Test-Path $logDir)) {
    New-Item -Path $logDir -ItemType Directory -Force | Out-Null
}
$logPath = Join-Path $logDir "limpeza_arquivos_$(Get-Date -Format 'yyyyMMdd_HHmmss').log"
New-Item -Path $logPath -ItemType File -Force | Out-Null

#=== DATA ===

$limiteDias = (Get-Date).AddDays(-7)


# === FUNÇÃO: Deletar arquivos por extensão e mais antigos que 7 dias ===
function Remover-ArquivosPorExtensao {
    param (
        [string]$diretorio,
        [string[]]$filtros
    )

    if (Test-Path $diretorio) {
        foreach ($filtro in $filtros) {
            Get-ChildItem -Path $diretorio -Filter $filtro -File -Force -ErrorAction SilentlyContinue | Where-Object { $_.LastWriteTime -lt $limiteDias } | ForEach-Object {
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

# === ETAPA 1: Deletar no diretório padrão ===
Write-Output "`n🧹 Limpando $diretorioPadrao"
"Limpando $diretorioPadrao" | Out-File -FilePath $logPath -Append -Encoding utf8
Remover-ArquivosPorExtensao -diretorio $diretorioPadrao -filtros $extensoesPadrao

# === ETAPA 2: Deletar nas subpastas "dados_compartilhados", exceto "a_processar" ===
foreach ($base in $caminhosBase) {
    $pastaAlvo = Join-Path $base $nomePastaAlvo
    if ($pastaAlvo -like "*\$excecaoSubpasta") {
        Write-Output "⏩ Pulando pasta excluída: $pastaAlvo"
        "Pulando pasta excluída: $pastaAlvo" | Out-File -FilePath $logPath -Append -Encoding utf8
        continue
    }
    Write-Output "`n🧹 Verificando: $pastaAlvo"
    "Verificando: $pastaAlvo" | Out-File -FilePath $logPath -Append -Encoding utf8
    Remover-ArquivosPorExtensao -diretorio $pastaAlvo -filtros $extensoesNasPastas
}

Write-Output "\n✅ Log gerado em: $logPath"
