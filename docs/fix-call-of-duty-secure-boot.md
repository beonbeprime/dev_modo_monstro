# Fix Call of Duty - Ação Necessária: Secure Boot e BIOS

## Problema

O Call of Duty está exibindo a mensagem "AÇÃO NECESSÁRIA" com dois requisitos:
1. **Firmware do BIOS: Atualização necessária**
2. **Inicialização Segura (Secure Boot): não habilitada**

O jogo não vai funcionar corretamente até que esses requisitos sejam atendidos.

---

## Passo a Passo para Resolver

### ETAPA 1: Coletar informações do PC

Rode os seguintes comandos no PowerShell ou CMD para identificar a placa-mãe e o status atual:

```powershell
# Informações do sistema
systeminfo

# Modelo da placa-mãe
wmic baseboard get manufacturer,product,version

# Versão atual da BIOS
wmic bios get name,version,releasedate

# Status do Secure Boot
Confirm-SecureBootUEFI
```

Anote:
- **Fabricante da placa-mãe** (ex: ASUS, Gigabyte, MSI, ASRock)
- **Modelo da placa-mãe** (ex: B550M AORUS PRO, ROG STRIX B450-F, etc.)
- **Versão atual da BIOS**
- **Se o Secure Boot está ativo ou não**

---

### ETAPA 2: Verificar se o Windows está em modo UEFI

Rode no CMD:

```cmd
bcdedit /enum {current}
```

Procure a linha `path`. Se aparecer `\EFI\Microsoft\Boot\bootmgfw.efi`, o Windows está em modo UEFI (correto). Se aparecer `\Windows\system32\winload.exe` (sem EFI), está em modo Legacy e será necessário converter antes.

#### Se estiver em modo Legacy (CSM/MBR):

> **ATENÇÃO: Faça backup dos seus dados antes de converter.**

```cmd
# Verificar se é possível converter (rodar como Administrador)
mbr2gpt /validate /disk:0

# Se a validação passar, converter
mbr2gpt /convert /disk:0
```

Depois da conversão, será necessário entrar na BIOS e mudar o boot para UEFI Only (desativar CSM).

---

### ETAPA 3: Ativar Secure Boot na BIOS

1. **Reinicie o PC**
2. **Entre na BIOS** apertando repetidamente a tecla correta durante o boot:
   - **ASUS**: DEL ou F2
   - **Gigabyte**: DEL
   - **MSI**: DEL
   - **ASRock**: DEL ou F2
   - **Dell**: F2
   - **HP**: F10
   - **Lenovo**: F1 ou F2
   - **Acer**: F2 ou DEL

3. **Na BIOS, navegue até as configurações de boot/segurança:**

   **ASUS:**
   - Vá em Boot > Secure Boot
   - Mude OS Type para "Windows UEFI mode"
   - Secure Boot State: Enabled
   - Se necessário: Boot > CSM > Launch CSM: Disabled

   **Gigabyte:**
   - Vá em BIOS > Secure Boot
   - Secure Boot Enable: Enabled
   - Se necessário: BIOS > CSM Support: Disabled

   **MSI:**
   - Vá em Settings > Security > Secure Boot
   - Secure Boot: Enabled
   - Se necessário: Settings > Advanced > Windows OS Configuration > CSM: Disabled

   **ASRock:**
   - Vá em Security > Secure Boot
   - Secure Boot: Enabled
   - Se necessário: Boot > CSM: Disabled

4. **Salve e saia** apertando F10

5. O PC vai reiniciar. O Windows deve iniciar normalmente.

---

### ETAPA 4: Atualizar a BIOS (se necessário)

Depois de ativar o Secure Boot, abra o Call of Duty. Se ainda pedir atualização de BIOS:

1. **Descubra o modelo exato da placa** (comando da Etapa 1)
2. **Vá ao site do fabricante:**
   - ASUS: https://www.asus.com/br/support/
   - Gigabyte: https://www.gigabyte.com/br/Support
   - MSI: https://www.msi.com/support
   - ASRock: https://www.asrock.com/support/
3. **Busque pelo modelo da sua placa-mãe**
4. **Baixe a versão mais recente da BIOS**
5. **Copie o arquivo para um pendrive formatado em FAT32**
6. **Reinicie e entre na BIOS**
7. **Use a ferramenta de atualização da BIOS:**
   - ASUS: EZ Flash (na aba Tool)
   - Gigabyte: Q-Flash (apertando F8)
   - MSI: M-Flash
   - ASRock: Instant Flash
8. **Selecione o arquivo do pendrive e confirme**
9. **NUNCA desligue o PC durante a atualização da BIOS**
10. Após concluir, o PC reinicia automaticamente

---

### ETAPA 5: Verificar se funcionou

Após reiniciar, rode no PowerShell:

```powershell
# Deve retornar True
Confirm-SecureBootUEFI
```

Abra o Call of Duty. A mensagem de "Ação Necessária" não deve mais aparecer.

---

## Resumo Rápido

| Passo | Ação |
|-------|------|
| 1 | Coletar info da placa-mãe |
| 2 | Verificar se Windows está em UEFI |
| 3 | Ativar Secure Boot na BIOS |
| 4 | Atualizar BIOS se necessário |
| 5 | Testar o jogo |

## Notas

- Na maioria dos casos, **só ativar o Secure Boot resolve** sem precisar atualizar a BIOS
- Se após ativar Secure Boot o Windows não iniciar, entre na BIOS novamente e desative o CSM (Legacy Boot)
- Se o disco estiver em MBR, será preciso converter para GPT antes (Etapa 2)
