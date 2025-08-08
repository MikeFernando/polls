#!/bin/bash

# Script de instalação para os aliases de commit automático

set -e

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🚀 Instalando aliases de commit automático...${NC}"

# Verifica se o script está sendo executado do diretório correto
if [ ! -f "scripts/auto_commit.py" ]; then
    echo -e "${RED}❌ Erro: Execute este script do diretório raiz do projeto${NC}"
    exit 1
fi

# Determina o arquivo de configuração do shell
SHELL_CONFIG=""
if [ -f "$HOME/.zshrc" ]; then
    SHELL_CONFIG="$HOME/.zshrc"
elif [ -f "$HOME/.bashrc" ]; then
    SHELL_CONFIG="$HOME/.bashrc"
else
    echo -e "${RED}❌ Erro: Não foi possível encontrar .zshrc ou .bashrc${NC}"
    exit 1
fi

# Verifica se os aliases já estão configurados
if grep -q "source.*git_aliases.sh" "$SHELL_CONFIG"; then
    echo -e "${YELLOW}⚠️  Aliases já estão configurados em $SHELL_CONFIG${NC}"
else
    # Adiciona a linha de source ao arquivo de configuração
    echo "" >> "$SHELL_CONFIG"
    echo "# Auto commit aliases" >> "$SHELL_CONFIG"
    echo "source $(pwd)/scripts/git_aliases.sh" >> "$SHELL_CONFIG"
    echo -e "${GREEN}✅ Aliases adicionados ao $SHELL_CONFIG${NC}"
fi

# Torna os scripts executáveis
chmod +x scripts/auto_commit.py scripts/quick_commit.sh

# Cria diretório .cursor se não existir
mkdir -p .cursor

echo -e "${GREEN}✅ Instalação concluída!${NC}"
echo ""
echo -e "${BLUE}📋 Como usar:${NC}"
echo "  qc          - Commit rápido automático"
echo "  qcp         - Commit com preview"
echo "  acm         - Mostrar mensagem de commit"
echo "  acc         - Commit completo com análise"
echo ""
echo -e "${BLUE}🔄 Recarregue seu shell:${NC}"
echo "  source $SHELL_CONFIG"
echo ""
echo -e "${BLUE}🎯 Teste com:${NC}"
echo "  qc" 