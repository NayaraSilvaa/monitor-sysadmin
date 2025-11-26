#!/bin/bash

echo "--Monitoramento do Ambiente--"

read -p "Digite o diretório que deseja verificar: " DIRETORIO

if [ ! -d "$DIRETORIO" ]; then
    echo "[ERRO] O diretório não existe."
    exit 1
fi

echo "Verificando permissões"

if [ ! -r "$DIRETORIO" ] || [ ! -w "$DIRETORIO" ] || [ ! -x "$DIRETORIO" ]; then
    echo "[AVISO] O usuário não possui todas as permissões (rwx) no diretório."
else
    echo "[OK] Permissões adequadas no diretório."
fi

echo
echo "Verificando uso de disco da partição raiz"

USO_DISCO=$(df -h / | awk 'NR==2 {gsub("%","",$5); print $5}')

if [ "$USO_DISCO" -gt 90 ]; then
    echo "Uso de disco: $USO_DISCO% [CRÍTICO]"
elif [ "$USO_DISCO" -gt 70 ]; then
    echo "Uso de disco: $USO_DISCO% [ALERTA]"
else
    echo "Uso de disco: $USO_DISCO% [OK]"
fi

echo "Uso de disco: $USO_DISCO% $STATUS"

echo 
echo "Monitorando processos do usuário $USER..."

PROCESSOS=$(ps -u "$USER" | wc -l)
echo "Total de processos do usuário: $PROCESSOS"

echo
echo "Top 5 processos que mais usam memória:"
ps -u "$USER" --sort=-%mem -o pid,comm,%mem | head -n 6

echo
echo "--Análise final concluída"