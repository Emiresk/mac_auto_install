#!/bin/bash

echo "🚀 Начинаем настройку системы и последовательную установку софта..."

# 1. Проверка и установка Homebrew
if ! command -v brew &> /dev/null; then
    echo "📦 Homebrew не найден. Начинаем установку..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    
    echo "⚙️ Выполнение пост-инстал команд для настройки PATH..."
    # Проверяем, куда установился Homebrew (Apple Silicon или Intel)
    if [[ -x "/opt/homebrew/bin/brew" ]]; then
        echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
        eval "$(/opt/homebrew/bin/brew shellenv)"
    elif [[ -x "/usr/local/bin/brew" ]]; then
        echo 'eval "$(/usr/local/bin/brew shellenv)"' >> ~/.zprofile
        eval "$(/usr/local/bin/brew shellenv)"
    fi
    echo "✅ Homebrew успешно установлен и настроен!"
else
    echo "✅ Homebrew уже установлен. Идем дальше."
fi

# 2. Обновляем Homebrew перед установкой пакетов
echo "🔄 Обновление баз Homebrew..."
brew update

# 3. Обычные пакеты
echo "🐳 Установка Docker..."
brew install docker

# 4. Установка NotepadNext через пользовательский tap
echo "📝 Установка NotepadNext..."
brew tap dail8859/notepadnext
brew install --no-quarantine notepadnext

# 5. Приложения с графическим интерфейсом (Casks)
echo "💻 Установка программ с графическим интерфейсом (Casks)..."
brew install --cask claude
brew install --cask chatgpt
brew install --cask slack
brew install --cask telegram
brew install --cask android-platform-tools
brew install --cask android-studio
brew install --cask cursor
brew install --cask flutter
brew install --cask epic-games
brew install --cask deepl
brew install --cask spotify

# 6. Специфичные пакеты
echo "⚠️ Попытка установки нестандартных пакетов..."
brew install qwen-code || echo "❌ qwen-code не найден в стандартных репозиториях brew."
brew install --cask antigravity || echo "❌ antigravity не найден."
brew install copilot-cli || echo "❌ copilot-cli не найден."
brew install cline || echo "❌ cline не найден."
brew install opencode || echo "❌ opencode не найден."

echo "🎉 Установка полностью завершена!"
