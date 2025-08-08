# 📝 Exemplos de Mensagens de Commit

## ❌ Antes (Genéricas)
```
feat: add 2 feature(s) (2024-01-15 14:30)
fix: fix 1 issue(s) (2024-01-15 14:30)
docs: update 1 doc(s) (2024-01-15 14:30)
```

## ✅ Agora (Descritivas)
```
feat: implement add new functionality in authentication.dart
fix: fix error handling in http_client.dart
test: add test coverage for remote_authentication.dart
docs: update documentation for README.md
refactor: refactor add new functionality in auto_commit.py
```

## 🎯 Exemplos Reais

### Cenário 1: Adicionando Nova Funcionalidade
**Antes:** `feat: add 1 feature(s)`
**Agora:** `feat: implement add new functionality in authentication.dart`

### Cenário 2: Corrigindo Bug
**Antes:** `fix: fix 1 issue(s)`
**Agora:** `fix: fix error handling in http_client.dart`

### Cenário 3: Adicionando Testes
**Antes:** `test: add 1 test(s)`
**Agora:** `test: add test coverage for remote_authentication.dart`

### Cenário 4: Refatorando Código
**Antes:** `refactor: refactor 2 file(s)`
**Agora:** `refactor: update auto_commit.py; update quick_commit.sh`

### Cenário 5: Atualizando Documentação
**Antes:** `docs: update 1 doc(s)`
**Agora:** `docs: update documentation for README.md`

## 🔍 Como Funciona

O script agora analisa o **conteúdo real** das mudanças:

1. **Analisa o diff** de cada arquivo
2. **Procura palavras-chave** como:
   - `function`, `class`, `method` → "add new functionality"
   - `test`, `spec`, `expect` → "add test coverage"
   - `error`, `exception` → "fix error handling"
   - `import`, `export` → "add new imports"

3. **Conta linhas** adicionadas/removidas
4. **Gera descrição específica** baseada no conteúdo

## 🚀 Benefícios

- ✅ **Mensagens mais claras** sobre o que foi feito
- ✅ **Especifica o arquivo** que foi modificado
- ✅ **Descreve a ação** realizada (add, fix, refactor, etc.)
- ✅ **Em inglês** para padrão internacional
- ✅ **Sem timestamp** desnecessário
- ✅ **Múltiplas mudanças** separadas por ponto e vírgula

## 🎨 Exemplos de Uso

```bash
# Commit rápido com mensagem descritiva
qc

# Preview da mensagem antes do commit
qcp

# Apenas ver a mensagem sugerida
acm
``` 