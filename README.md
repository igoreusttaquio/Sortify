# Sortify

Sortify é um organizador de arquivos automático e baseado em regras para desktop.
Ele monitora pastas, classifica arquivos por tipo/nome/extensão e os move para
destinos configurados por regras personalizadas.

## Funcionalidades

- Monitoramento automático de pastas (watch mode)
- Regras personalizadas com condições e ações
- Organização por tipo de arquivo, extensão, nome e data
- Interface desktop (Windows, Linux e macOS)
- Suporte a idiomas: Português, Inglês e Espanhol
- Inicialização junto ao sistema e minimização para a bandeja (tray)

## Requisitos

Antes de começar, instale as ferramentas abaixo.

### 1. Flutter SDK

O Sortify usa o canal **stable** do Flutter (>= 3.13).

- Baixe e instale o Flutter em https://docs.flutter.dev/get-started/install
- Adicione o Flutter ao `PATH`
- Confirme a instalação com:

```powershell
flutter --version
```

### 2. Dart

O Dart já vem junto com o Flutter. Verifique com:

```powershell
dart --version
```

### 3. Ferramentas de build por plataforma

**Windows (alvo principal):**

- Instale o **Visual Studio 2022** com a workload
  **"Desktop development with C++"** (necessária para compilar o runner Windows).
- Habilite o suporte a desktop:

```powershell
flutter config --enable-windows-desktop
```

**Linux:**

```bash
sudo apt install clang cmake ninja-build pkg-config libgtk-3-dev liblzma-dev
flutter config --enable-linux-desktop
```

**macOS:**

```bash
flutter config --enable-macos-desktop
```

### 4. Inno Setup 6 (apenas para gerar o instalador Windows)

Necessário somente se você quiser empacotar o app em um instalador `.exe`.

- Baixe em https://jrsoftware.org/isdl.php
- Instale no diretório padrão (`C:\Program Files (x86)\Inno Setup 6`)

### 5. Verifique o ambiente

```powershell
flutter doctor
```

Certifique-se de que a seção "Visual Studio" esteja com status OK.

## Preparando o ambiente

1. Clone o repositório:

```powershell
git clone git@github.com:igoreusttaquio/Sortify.git
cd Sortify
```

2. Instale as dependências:

```powershell
flutter pub get
```

3. Gere o código (Freezed, JSON serialization e localizações):

```powershell
dart run build_runner build --delete-conflicting-outputs
flutter gen-l10n
```

> O código gerado já está versionado no repositório, então este passo só é
> necessário após alterar os modelos, os arquivos `.arb` de tradução ou as
> anotações do Freezed.

## Executando em desenvolvimento

```powershell
flutter run -d windows
```

Para Linux/macOS, use `flutter run -d linux` ou `flutter run -d macos`.

## Testes e análise

```powershell
flutter test
flutter analyze
```

## Gerando o executável (build)

Compila a versão de release do Sortify:

```powershell
flutter build windows --release
```

O executável fica em:

```
build\windows\x64\runner\Release\sortify.exe
```

Para Linux e macOS:

```bash
flutter build linux --release
flutter build macos --release
```

## Gerando o instalador (Windows)

O script `installer/build.ps1` compila o app em release e gera o instalador
com o Inno Setup 6 em uma única etapa.

```powershell
powershell -ExecutionPolicy Bypass -File installer\build.ps1
```

Para gerar um instalador com versão específica:

```powershell
powershell -ExecutionPolicy Bypass -File installer\build.ps1 -Version 1.1.0
```

O instalador é salvo em:

```
dist\Sortify-Setup-1.0.0.exe
```

> Pré-requisito: Inno Setup 6 instalado (veja a seção Requisitos).

## Estrutura do projeto

```
lib/
  core/         # infraestrutura compartilhada (db, tema, router, di, fs)
  features/     # módulos por feature (regras, pastas, atividade, configurações)
  l10n/         # traduções (arb) e código gerado
installer/      # script de build e Inno Setup (.iss)
assets/         # imagens e ícones
```
