#!/bin/bash

# Script para commit rápido baseado nas mudanças do Git
# Uso: ./quick_commit.sh [mensagem_customizada]

set -e

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Função para mostrar ajuda
show_help() {
    echo -e "${BLUE}Uso:${NC}"
    echo "  $0 [mensagem_customizada]"
    echo ""
    echo -e "${BLUE}Exemplos:${NC}"
    echo "  $0                    # Gera mensagem automática e faz commit"
    echo "  $0 \"fix: correção de bug\"  # Usa mensagem customizada"
    echo ""
    echo -e "${BLUE}Comportamento:${NC}"
    echo "  - Adiciona todas as mudanças ao staging"
    echo "  - Gera mensagem baseada nos arquivos modificados"
    echo "  - Faz o commit automaticamente"
}

# Verifica se é um repositório Git
if ! git rev-parse --git-dir > /dev/null 2>&1; then
    echo -e "${RED}❌ Erro: Não é um repositório Git válido${NC}"
    exit 1
fi

# Verifica se há mudanças
if [ -z "$(git status --porcelain)" ]; then
    echo -e "${YELLOW}⚠️  Nenhuma mudança detectada${NC}"
    exit 0
fi

# Função para categorizar arquivos
categorize_changes() {
    local staged_files=$(git diff --cached --name-only 2>/dev/null || true)
    local unstaged_files=$(git diff --name-only 2>/dev/null || true)
    local untracked_files=$(git ls-files --others --exclude-standard 2>/dev/null || true)
    
    local features=0 fixes=0 tests=0 docs=0 config=0 deps=0 refactor=0 other=0
    
    # Analisa arquivos staged
    while IFS= read -r file; do
        if [[ -n "$file" ]]; then
            case "$file" in
                *test*|*spec*) ((tests++));;
                *feature*|*usecase*|*entity*) ((features++));;
                *fix*|*bug*|*error*) ((fixes++));;
                *readme*|*.md|*docs*) ((docs++));;
                *pubspec*|*config*|*.yaml|*.json) ((config++));;
                *.dart|*.py|*.js|*.ts) ((refactor++));;
                *) ((other++));;
            esac
        fi
    done <<< "$staged_files"
    
    # Analisa arquivos unstaged
    while IFS= read -r file; do
        if [[ -n "$file" ]]; then
            case "$file" in
                *test*|*spec*) ((tests++));;
                *feature*|*usecase*|*entity*) ((features++));;
                *fix*|*bug*|*error*) ((fixes++));;
                *readme*|*.md|*docs*) ((docs++));;
                *pubspec*|*config*|*.yaml|*.json) ((config++));;
                *.dart|*.py|*.js|*.ts) ((refactor++));;
                *) ((other++));;
            esac
        fi
    done <<< "$unstaged_files"
    
    # Analisa arquivos untracked
    while IFS= read -r file; do
        if [[ -n "$file" ]]; then
            case "$file" in
                *test*|*spec*) ((tests++));;
                *feature*|*usecase*|*entity*) ((features++));;
                *fix*|*bug*|*error*) ((fixes++));;
                *readme*|*.md|*docs*) ((docs++));;
                *pubspec*|*config*|*.yaml|*.json) ((config++));;
                *.dart|*.py|*.js|*.ts) ((refactor++));;
                *) ((other++));;
            esac
        fi
    done <<< "$untracked_files"
    
    # Determina o tipo principal
    if [ $features -gt 0 ]; then
        echo "feat"
    elif [ $fixes -gt 0 ]; then
        echo "fix"
    elif [ $tests -gt 0 ]; then
        echo "test"
    elif [ $docs -gt 0 ]; then
        echo "docs"
    elif [ $refactor -gt 0 ]; then
        echo "refactor"
    elif [ $config -gt 0 ]; then
        echo "config"
    elif [ $deps -gt 0 ]; then
        echo "deps"
    else
        echo "chore"
    fi
}

# Função para analisar conteúdo do arquivo
analyze_file_content() {
    local file_path="$1"
    
    # Pega o diff do arquivo
    local diff_content=$(git diff --cached "$file_path" 2>/dev/null || git diff "$file_path" 2>/dev/null)
    
    if [ -z "$diff_content" ]; then
        return
    fi
    
    # Conta linhas adicionadas e removidas
    local lines_added=$(echo "$diff_content" | grep -c '^+' || echo "0")
    local lines_deleted=$(echo "$diff_content" | grep -c '^-' || echo "0")
    
    # Procura por palavras-chave
    local has_function=$(echo "$diff_content" | grep -i 'function\|class\|method\|def \|void \|public \|private ' | wc -l)
    local has_test=$(echo "$diff_content" | grep -i 'test\|spec\|expect\|assert' | wc -l)
    local has_error=$(echo "$diff_content" | grep -i 'error\|exception\|catch\|throw' | wc -l)
    local has_import=$(echo "$diff_content" | grep -i 'import\|export\|require' | wc -l)
    
    # Gera descrição baseada no conteúdo
    if [ "$has_function" -gt 0 ]; then
        echo "add new functionality"
    elif [ "$has_test" -gt 0 ]; then
        echo "add test coverage"
    elif [ "$has_error" -gt 0 ]; then
        echo "fix error handling"
    elif [ "$has_import" -gt 0 ]; then
        echo "add new imports"
    elif [ "$lines_added" -gt 0 ] && [ "$lines_deleted" -eq 0 ]; then
        echo "add $lines_added line(s) of code"
    elif [ "$lines_deleted" -gt 0 ] && [ "$lines_added" -eq 0 ]; then
        echo "remove $lines_deleted line(s) of code"
    elif [ "$lines_added" -gt 0 ] && [ "$lines_deleted" -gt 0 ]; then
        echo "modify code ($lines_added added, $lines_deleted removed)"
    else
        echo "update code"
    fi
}

# Função para gerar descrição descritiva
generate_description() {
    local staged_files=$(git diff --cached --name-only 2>/dev/null || true)
    local unstaged_files=$(git diff --name-only 2>/dev/null || true)
    local untracked_files=$(git ls-files --others --exclude-standard 2>/dev/null || true)
    
    local descriptions=()
    local count=0
    
    # Analisa cada arquivo
    while IFS= read -r file; do
        if [[ -n "$file" ]] && [[ $count -lt 3 ]]; then
            local content_desc=$(analyze_file_content "$file")
            local filename=$(basename "$file")
            
            if [[ -n "$content_desc" ]]; then
                descriptions+=("$content_desc in $filename")
            else
                descriptions+=("update $filename")
            fi
            
            ((count++))
        fi
    done < <(echo -e "$staged_files\n$unstaged_files\n$untracked_files" | grep -v '^$')
    
    if [ ${#descriptions[@]} -eq 0 ]; then
        local total_files=$(echo -e "$staged_files\n$unstaged_files\n$untracked_files" | grep -v '^$' | wc -l)
        echo "update $total_files files"
    else
        printf '%s; ' "${descriptions[@]}" | sed 's/; $//'
    fi
}

# Se uma mensagem customizada foi fornecida
if [ $# -gt 0 ]; then
    commit_message="$1"
else
    # Gera mensagem automática
    prefix=$(categorize_changes)
    description=$(generate_description)
    timestamp=$(date '+%Y-%m-%d %H:%M')
    commit_message="$prefix: $description ($timestamp)"
fi

echo -e "${BLUE}📊 Analisando mudanças...${NC}"

# Mostra resumo das mudanças
echo -e "\n${YELLOW}📋 Mudanças detectadas:${NC}"
git status --short

echo -e "\n${BLUE}💬 Mensagem de commit:${NC}"
echo -e "   ${GREEN}$commit_message${NC}"

# Adiciona todas as mudanças
echo -e "\n${BLUE}📦 Adicionando mudanças ao staging...${NC}"
git add .

# Faz o commit
echo -e "\n${BLUE}🚀 Fazendo commit...${NC}"
if git commit -m "$commit_message"; then
    echo -e "\n${GREEN}✅ Commit realizado com sucesso!${NC}"
    echo -e "${GREEN}   $commit_message${NC}"
else
    echo -e "\n${RED}❌ Erro ao fazer commit${NC}"
    exit 1
fi 