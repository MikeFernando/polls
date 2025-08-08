# Aliases para commit automático
# Adicione este conteúdo ao seu ~/.zshrc ou ~/.bashrc

# Alias para o script Python (mais avançado)
alias ac='python3 ~/projetos/polls/scripts/auto_commit.py'

# Alias para apenas gerar mensagem sem fazer commit
alias acm='python3 ~/projetos/polls/scripts/auto_commit.py --summary'

# Alias para adicionar ao staging e gerar mensagem
alias acs='python3 ~/projetos/polls/scripts/auto_commit.py --stage'

# Alias para commit completo (adicionar + commit)
alias acc='python3 ~/projetos/polls/scripts/auto_commit.py --commit'

# Função para commit inteligente
qc() {
    if [ $# -eq 0 ]; then
        # Sem argumentos: commit automático
        ~/projetos/polls/scripts/quick_commit.sh
    else
        # Com argumentos: commit com mensagem customizada
        ~/projetos/polls/scripts/quick_commit.sh "$*"
    fi
}

# Função para commit com preview
qcp() {
    echo "📊 Analisando mudanças..."
    python3 ~/projetos/polls/scripts/auto_commit.py --summary
    
    echo -e "\n💬 Mensagem de commit sugerida:"
    python3 ~/projetos/polls/scripts/auto_commit.py | grep "Mensagem de commit gerada:" -A 1 | tail -1
    
    echo -e "\n❓ Deseja fazer o commit? (y/N)"
    read -r response
    if [[ "$response" =~ ^[Yy]$ ]]; then
        python3 ~/projetos/polls/scripts/auto_commit.py --commit
    else
        echo "❌ Commit cancelado"
    fi
} 