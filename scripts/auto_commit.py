#!/usr/bin/env python3
"""
Script para gerar mensagens de commit automáticas baseadas nas mudanças do Git.
Uso: python auto_commit.py [--commit] [--message "mensagem customizada"]
"""

import subprocess
import sys
import os
import re
from typing import List, Dict, Tuple
import argparse
from datetime import datetime

class GitCommitGenerator:
    def __init__(self):
        self.changes = {}
        self.staged_files = []
        self.unstaged_files = []
        
    def get_git_status(self) -> Dict[str, List[str]]:
        """Obtém o status atual do Git"""
        try:
            result = subprocess.run(['git', 'status', '--porcelain'], 
                                 capture_output=True, text=True, check=True)
            files = result.stdout.strip().split('\n') if result.stdout.strip() else []
            
            status = {
                'staged': [],
                'unstaged': [],
                'untracked': []
            }
            
            for file in files:
                if file:
                    status_code = file[:2]
                    file_path = file[3:]
                    
                    if status_code.startswith('A'):  # Added
                        status['staged'].append(('add', file_path))
                    elif status_code.startswith('M'):  # Modified
                        if status_code == 'MM':  # Modified in both staged and unstaged
                            status['staged'].append(('modify', file_path))
                            status['unstaged'].append(('modify', file_path))
                        elif status_code == 'M ':  # Modified staged
                            status['staged'].append(('modify', file_path))
                        elif status_code == ' M':  # Modified unstaged
                            status['unstaged'].append(('modify', file_path))
                    elif status_code.startswith('D'):  # Deleted
                        status['staged'].append(('delete', file_path))
                    elif status_code.startswith('R'):  # Renamed
                        status['staged'].append(('rename', file_path))
                    elif status_code == '??':  # Untracked
                        status['untracked'].append(('add', file_path))
            
            return status
        except subprocess.CalledProcessError:
            print("Erro: Não é um repositório Git válido")
            return {}
    
    def analyze_changes(self) -> Dict[str, List[str]]:
        """Analisa as mudanças e categoriza por tipo"""
        status = self.get_git_status()
        
        categories = {
            'features': [],
            'fixes': [],
            'refactor': [],
            'docs': [],
            'tests': [],
            'config': [],
            'dependencies': [],
            'other': []
        }
        
        all_files = []
        all_files.extend(status.get('staged', []))
        all_files.extend(status.get('unstaged', []))
        all_files.extend(status.get('untracked', []))
        
        for change_type, file_path in all_files:
            category = self.categorize_file(file_path)
            categories[category].append(f"{change_type}: {file_path}")
        
        return categories
    
    def categorize_file(self, file_path: str) -> str:
        """Categoriza um arquivo baseado em seu caminho e extensão"""
        file_lower = file_path.lower()
        
        # Features
        if any(keyword in file_lower for keyword in ['feature', 'usecase', 'entity', 'model']):
            return 'features'
        
        # Fixes
        if any(keyword in file_lower for keyword in ['fix', 'bug', 'error', 'exception']):
            return 'fixes'
        
        # Tests
        if any(keyword in file_lower for keyword in ['test', 'spec', '_test.', 'test_']):
            return 'tests'
        
        # Documentation
        if any(keyword in file_lower for keyword in ['readme', 'docs', '.md', 'documentation']):
            return 'docs'
        
        # Configuration
        if any(keyword in file_lower for keyword in ['config', 'yaml', 'json', 'toml', '.env', 'pubspec']):
            return 'config'
        
        # Dependencies
        if any(keyword in file_lower for keyword in ['pubspec.lock', 'package.json', 'requirements.txt']):
            return 'dependencies'
        
        # Refactoring (arquivos de código modificados)
        if any(ext in file_lower for ext in ['.dart', '.py', '.js', '.ts', '.java', '.kt', '.swift']):
            return 'refactor'
        
        return 'other'
    
    def generate_commit_message(self, custom_message: str = None) -> str:
        """Gera uma mensagem de commit baseada nas mudanças"""
        if custom_message:
            return custom_message
        
        changes = self.analyze_changes()
        
        # Conta mudanças por categoria
        change_counts = {k: len(v) for k, v in changes.items() if v}
        
        if not change_counts:
            return "chore: no changes detected"
        
        # Determina o tipo principal da mudança
        if change_counts.get('features'):
            prefix = "feat"
        elif change_counts.get('fixes'):
            prefix = "fix"
        elif change_counts.get('tests'):
            prefix = "test"
        elif change_counts.get('docs'):
            prefix = "docs"
        elif change_counts.get('refactor'):
            prefix = "refactor"
        elif change_counts.get('config'):
            prefix = "config"
        elif change_counts.get('dependencies'):
            prefix = "deps"
        else:
            prefix = "chore"
        
        # Gera descrição baseada nas mudanças
        descriptions = []
        
        if change_counts.get('features'):
            descriptions.append(f"add {change_counts['features']} feature(s)")
        
        if change_counts.get('fixes'):
            descriptions.append(f"fix {change_counts['fixes']} issue(s)")
        
        if change_counts.get('refactor'):
            descriptions.append(f"refactor {change_counts['refactor']} file(s)")
        
        if change_counts.get('tests'):
            descriptions.append(f"add {change_counts['tests']} test(s)")
        
        if change_counts.get('docs'):
            descriptions.append(f"update {change_counts['docs']} doc(s)")
        
        if change_counts.get('config'):
            descriptions.append(f"update {change_counts['config']} config(s)")
        
        if change_counts.get('dependencies'):
            descriptions.append(f"update {change_counts['dependencies']} dependency(ies)")
        
        if change_counts.get('other'):
            descriptions.append(f"update {change_counts['other']} file(s)")
        
        description = ", ".join(descriptions)
        
        # Adiciona timestamp
        timestamp = datetime.now().strftime("%Y-%m-%d %H:%M")
        
        return f"{prefix}: {description} ({timestamp})"
    
    def stage_all_changes(self) -> bool:
        """Adiciona todas as mudanças ao staging area"""
        try:
            subprocess.run(['git', 'add', '.'], check=True)
            print("✓ Todas as mudanças foram adicionadas ao staging area")
            return True
        except subprocess.CalledProcessError as e:
            print(f"✗ Erro ao adicionar mudanças: {e}")
            return False
    
    def commit_changes(self, message: str) -> bool:
        """Faz o commit com a mensagem fornecida"""
        try:
            subprocess.run(['git', 'commit', '-m', message], check=True)
            print(f"✓ Commit realizado com sucesso: {message}")
            return True
        except subprocess.CalledProcessError as e:
            print(f"✗ Erro ao fazer commit: {e}")
            return False
    
    def show_changes_summary(self):
        """Mostra um resumo das mudanças"""
        changes = self.analyze_changes()
        
        print("\n📊 Resumo das mudanças:")
        print("=" * 40)
        
        for category, files in changes.items():
            if files:
                print(f"\n{category.upper()}:")
                for file in files:
                    print(f"  • {file}")
        
        print("\n" + "=" * 40)

def main():
    parser = argparse.ArgumentParser(description='Gerador automático de commits')
    parser.add_argument('--commit', action='store_true', 
                       help='Fazer commit automaticamente')
    parser.add_argument('--message', type=str, 
                       help='Mensagem de commit customizada')
    parser.add_argument('--stage', action='store_true',
                       help='Adicionar mudanças ao staging area')
    parser.add_argument('--summary', action='store_true',
                       help='Mostrar resumo das mudanças')
    
    args = parser.parse_args()
    
    generator = GitCommitGenerator()
    
    # Verifica se é um repositório Git
    try:
        subprocess.run(['git', 'rev-parse', '--git-dir'], 
                      capture_output=True, check=True)
    except subprocess.CalledProcessError:
        print("❌ Erro: Não é um repositório Git válido")
        sys.exit(1)
    
    # Mostra resumo se solicitado
    if args.summary:
        generator.show_changes_summary()
    
    # Gera mensagem de commit
    message = generator.generate_commit_message(args.message)
    
    print(f"\n💬 Mensagem de commit gerada:")
    print(f"   {message}")
    
    # Adiciona ao staging se solicitado
    if args.stage:
        if not generator.stage_all_changes():
            sys.exit(1)
    
    # Faz commit se solicitado
    if args.commit:
        if not generator.stage_all_changes():
            sys.exit(1)
        
        if not generator.commit_changes(message):
            sys.exit(1)
        
        print("\n🎉 Commit realizado com sucesso!")
    else:
        print("\n💡 Para fazer o commit, use: --commit")
        print("💡 Para adicionar ao staging: --stage")

if __name__ == "__main__":
    main() 