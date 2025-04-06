# 📚 CodePlay

**CodePlay** é um aplicativo educacional interativo desenvolvido em **Flutter**, com foco no ensino de conceitos fundamentais de codificação digital como **ASCII**, **cores RGB**, **números binários** e **Snake Game**, voltado para alunos do **Ensino Fundamental**. O projeto está alinhado com as competências da **BNCC (EF04CO04 e EF04CO05)**, integrando aprendizado, acessibilidade e gamificação para tornar o aprendizado de conceitos de computação mais divertido e eficaz.

---

## ✨ Funcionalidades

- 🎨 Interface moderna e responsiva com componentes reutilizáveis (Flutter Web & Android)
- 🤖 Mascote animado com mensagens contextuais e diferentes estados de humor
- 🧩 Módulos educacionais interativos:
  - 🔤 **ASCII**: Conversão de caracteres e tabela completa de referência
  - 0️⃣1️⃣ **Binário**: Jogo de conversão binário ↔ decimal com dificuldade progressiva
- 🏆 Sistema de progresso e recompensas
- 🌓 Suporte completo a tema claro/escuro
- 🔊 Sons e animações responsivas para feedback imersivo
- 📊 Visualização de resultados e estatísticas de aprendizado
- 📱 Design responsivo otimizado para desktop e dispositivos móveis

---

## 🏗 Arquitetura e Tecnologias

- 🔄 **Flutter 3.29.0** com suporte multiplataforma (Web e Mobile)
- 📦 **Riverpod 2.4.0** para gerenciamento de estado escalável
- 🧩 **Arquitetura modular** com separação de camadas (presentation, domain, data, core)
- 🧭 **Go Router 13.0.1** para navegação declarativa
- 🎭 **Flutter Animate 4.5.2** para animações sofisticadas
- 🎵 **AudioPlayers 6.4.0** para efeitos sonoros
- 🖼️ **Lottie 3.3.1** para animações vetoriais complexas
- 🔡 **Google Fonts 6.2.1** para tipografia moderna e acessível
- 📱 **Design responsivo** otimizado para diferentes tamanhos de tela
- 🧪 **Componentização** para reuso fácil de UI complexos (GlassUtils, Mascote, Cards)

---

## 🎯 Objetivos Educacionais (BNCC)

- **EF04CO04:** Compreender como os computadores representam dados digitalmente
- **EF04CO05:** Explorar sistemas de codificação como binário, ASCII e RGB
---

## 🧑‍💻 Equipe

- **Desenvolvimento:** Mateus ([@peSuperSam](https://github.com/peSuperSam))
- **Disciplina:** Ensino de Computação II – 2025.1

---

## 🚀 Como executar

```bash
# Clonar o repositório
git clone https://github.com/peSuperSam/code_play.git

# Entrar na pasta do projeto
cd code_play

# Instalar as dependências
flutter pub get

# Executar no navegador
flutter run -d chrome --web-renderer canvaskit

# Ou executar no Android
flutter run -d android

```

## 🧩 Estrutura do Projeto

```
lib/
├── core/            # Componentes principais reutilizáveis
│   ├── constants/   # Constantes da aplicação
│   ├── routes/      # Configuração de rotas
│   ├── theme/       # Temas e estilos
│   └── utils/       # Utilitários (GlassUtils, ColorUtils, etc)
├── data/            # Fontes de dados e repositórios
├── domain/          # Modelos e lógica de negócios
├── presentation/    # Interface do usuário
│   ├── modules/     # Módulos da aplicação (Ascii, RGB, Binário, Snake)
│   └── shared/      # Widgets compartilhados
└── providers/       # Provedores de estado (Riverpod)