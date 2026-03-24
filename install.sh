#!/bin/bash

# Отключаем лишние подсказки Homebrew для чистоты консоли
export HOMEBREW_NO_ENV_HINTS=1

# ==========================================
# 📋 СПИСКИ ПРОГРАММ ДЛЯ УСТАНОВКИ
# ==========================================

CASK_APPS=(
    #AI
    claude
    chatgpt
    cursor

    #Dev tools
    android-studio
    flutter
    

    #Work Apps
    slack
    telegram
    google-chrome
    notion
    libreoffice

    #tools
    android-platform-tools
    qbittorrent
    nordvpn
    spotify
    deepl

    #games
    steam
    epic-games
    whisky
)

SPECIFIC_PACKAGES=(
    python@3.14

    #AI tools
    qwen-code
    copilot-cli
    cline
    opencode
    
    #macos cleaner
    mole
)

# ==========================================

echo "🚀 Начинаем настройку системы..."

# --- Умная функция установки ---
install_package() {
    local name=$1
    local type=$2

    if brew list ${type:+--cask} "$name" &>/dev/null; then
        echo "✅ $name уже установлен (через brew). Пропускаем."
        return 0
    fi

    echo -n "⏳ Проверка и установка $name... "

    local output
    if [[ "$type" == "cask" ]]; then
        output=$(brew install --cask "$name" 2>&1)
    else
        output=$(brew install "$name" 2>&1)
    fi
    
    local status=$?

    if [ $status -eq 0 ]; then
        echo "Готово! 📥"
    elif echo "$output" | grep -q -i "already an App at"; then
        echo "Уже установлен вручную. Пропускаем. 👾"
    elif echo "$output" | grep -q -i "No available formula\|Cask '$name' is unavailable"; then
        echo "Пакет не найден! ❌"
    else
        echo "Ошибка установки! ⚠️"
    fi
}

echo "🔄 Обновление баз Homebrew (это может занять минутку)..."
brew update -q >/dev/null 2>&1

# 3. CLI Инструменты
install_package "docker"

# 4. NotepadNext (нужен tap)
brew tap dail8859/notepadnext >/dev/null 2>&1
install_package "notepadnext" "cask"

# 5. Установка Casks (перебираем массив)
echo "💻 Установка Casks..."
for app in "${CASK_APPS[@]}"; do
    install_package "$app" "cask"
done

# 6. Установка специфичных пакетов (перебираем массив)
echo "⚠️ Установка специфичных пакетов..."
for pkg in "${SPECIFIC_PACKAGES[@]}"; do
    install_package "$pkg"
done

# Очистка кэша от скачанных установщиков
echo "🧹 Очистка кэша..."
brew cleanup -q >/dev/null 2>&1

echo "🎉 Установка полностью завершена!"
