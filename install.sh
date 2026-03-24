#!/bin/bash

echo "🚀 Начинаем настройку системы..."

# --- Функция для умной установки ---
# Аргумент 1: название пакета
# Аргумент 2: тип (formula или cask, по умолчанию formula)
install_package() {
    local name=$1
    local type=$2

    if [[ "$type" == "cask" ]]; then
        if brew list --cask "$name" &>/dev/null; then
            echo "✅ Cask '$name' уже установлен. Пропускаем."
        else
            echo "📥 Установка $name..."
            brew install --cask "$name"
        fi
    else
        if brew list "$name" &>/dev/null; then
            echo "✅ Пакет '$name' уже установлен. Пропускаем."
        else
            echo "📥 Установка $name..."
            brew install "$name"
        fi
    fi
}

# 1. Проверка и установка Homebrew
if ! command -v brew &> /dev/null; then
    echo "📦 Homebrew не найден..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    
    if [[ -x "/opt/homebrew/bin/brew" ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    elif [[ -x "/usr/local/bin/brew" ]]; then
        eval "$(/usr/local/bin/brew shellenv)"
    fi
fi

echo "🔄 Обновление баз Homebrew..."
brew update

# 3. CLI Инструменты
install_package "docker"

# 4. NotepadNext (нужен tap)
brew tap dail8859/notepadnext
install_package "notepadnext"

# 5. Приложения с графическим интерфейсом (Casks)
echo "💻 Установка Casks..."
for app in claude chatgpt slack telegram android-studio cursor flutter epic-games deepl spotify google-chrome; do
    install_package "$app" "cask"
done

# Отдельно для специфичных настроек
install_package "android-platform-tools" "cask"

# 6. Специфичные пакеты с обработкой ошибок
echo "⚠️ Проверка специфичных пакетов..."
for pkg in qwen-code copilot-cli cline opencode; do
    if ! brew list "$pkg" &>/dev/null; then
        brew install "$pkg" || echo "❌ $pkg не найден."
    else
        echo "✅ $pkg уже на месте."
    fi
done

echo "🎉 Установка полностью завершена!"
