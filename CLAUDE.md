# Dev Modo Monstro

## Sincronização Desktop <-> Web

Este repositório serve como ponte de sincronização entre o Claude Code no **desktop** e o Claude Code na **web**.

### Como funciona

1. **Git é o mecanismo de sync** — todo trabalho é commitado e pushado automaticamente
2. **Branch principal de trabalho**: `main`
3. **Convenção de commits**: descrever claramente o que foi feito para manter histórico legível
4. **Antes de começar a trabalhar**: sempre fazer `git pull` para pegar as últimas mudanças
5. **Ao terminar uma tarefa**: sempre commitar e pushar

### Regras do Projeto

- Todos os arquivos de código, configuração e documentação ficam versionados
- Nunca deixar trabalho sem commit — tudo que for feito deve ser salvo no repositório
- Scripts utilitários ficam em `scripts/`
- Configurações ficam em `config/`
- Código principal fica em `src/`

### Instruções para Sessions

Ao iniciar uma sessão (desktop ou web):
1. Rode `./scripts/sync.sh pull` para baixar as últimas mudanças
2. Trabalhe normalmente
3. Ao terminar, rode `./scripts/sync.sh push` para enviar as mudanças
