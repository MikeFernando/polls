# 🚀 Scripts de Commit Automático

Este diretório contém scripts para gerar mensagens de commit automaticamente baseadas nas mudanças do Git.

## 📁 Arquivos

- `auto_commit.py` - Script Python avançado com mais opções
- `quick_commit.sh` - Script shell simples e rápido
- `git_aliases.sh` - Aliases para facilitar o uso

## 🛠️ Configuração

### 1. Adicione os aliases ao seu shell

Adicione o conteúdo do arquivo `git_aliases.sh` ao seu `~/.zshrc` ou `~/.bashrc`:

```bash
# Copie e cole o conteúdo de git_aliases.sh no final do seu arquivo de configuração
source ~/projetos/polls/scripts/git_aliases.sh
```

Ou execute:

```bash
echo "source ~/projetos/polls/scripts/git_aliases.sh" >> ~/.zshrc
source ~/.zshrc
```

### 2. Torne os scripts executáveis (já feito)

```bash
chmod +x scripts/auto_commit.py scripts/quick_commit.sh
```

## 🎯 Como Usar

### Commit Rápido (Recomendado)

```bash
# Commit automático com mensagem gerada
qc

# Commit com mensagem customizada
qc "fix: correção de bug crítico"

# Commit com preview (pergunta antes de fazer)
qcp
```

### Script Python (Mais Opções)

```bash
# Apenas gerar mensagem sem fazer commit
acm

# Adicionar ao staging e gerar mensagem
acs

# Commit completo (adicionar + commit)
acc

# Commit com mensagem customizada
python3 scripts/auto_commit.py --commit --message "feat: nova funcionalidade"
```

### Script Shell Direto

```bash
# Commit automático
./scripts/quick_commit.sh

# Commit com mensagem customizada
./scripts/quick_commit.sh "docs: atualizar README"
```

## 📊 Categorização Automática

Os scripts analisam os arquivos modificados e categorizam automaticamente:

- **feat**: Arquivos com `feature`, `usecase`, `entity`, `model`
- **fix**: Arquivos com `fix`, `bug`, `error`, `exception`
- **test**: Arquivos com `test`, `spec`, `_test.`, `test_`
- **docs**: Arquivos com `readme`, `docs`, `.md`
- **config**: Arquivos com `config`, `yaml`, `json`, `pubspec`
- **deps**: Arquivos de dependências (`pubspec.lock`, `package.json`)
- **refactor**: Arquivos de código (`.dart`, `.py`, `.js`, `.ts`)
- **chore**: Outros arquivos

## 🎨 Exemplos de Uso

### Cenário 1: Desenvolvimento de Features

```bash
# Você modificou arquivos de features
qc
# Resultado: "feat: add 2 feature(s) (2024-01-15 14:30)"
```

### Cenário 2: Correção de Bugs

```bash
# Você corrigiu bugs
qc
# Resultado: "fix: fix 1 issue(s) (2024-01-15 14:30)"
```

### Cenário 3: Adição de Testes

```bash
# Você adicionou testes
qc
# Resultado: "test: add 3 test(s) (2024-01-15 14:30)"
```

### Cenário 4: Múltiplas Categorias

```bash
# Você modificou features e testes
qc
# Resultado: "feat: add 1 feature(s), add 2 test(s) (2024-01-15 14:30)"
```

## 🔧 Personalização

### Modificar Categorização

Edite a função `categorize_file()` no `auto_commit.py` ou `categorize_changes()` no `quick_commit.sh` para adicionar suas próprias regras.

### Adicionar Novos Aliases

Adicione ao `git_aliases.sh`:

```bash
# Seu alias personalizado
alias meucommit='python3 ~/projetos/polls/scripts/auto_commit.py --commit'
```

## 🚨 Troubleshooting

### Erro: "Não é um repositório Git válido"
- Certifique-se de estar em um diretório com `.git/`

### Erro: "Nenhuma mudança detectada"
- Não há arquivos modificados para commitar

### Erro: "Permission denied"
- Execute: `chmod +x scripts/*.py scripts/*.sh`

## 💡 Dicas

1. **Use `qcp`** quando quiser ver o que será commitado antes
2. **Use `qc`** para commits rápidos e automáticos
3. **Use `acc`** para commits com mais detalhes e opções
4. **Mantenha commits pequenos** - o script funciona melhor com mudanças focadas

## 🔄 Atualizações

Para atualizar os scripts:

```bash
git pull origin main
chmod +x scripts/*.py scripts/*.sh
source ~/.zshrc  # ou ~/.bashrc
``` 