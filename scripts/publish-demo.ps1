# Публикация ДЕМО-версии на GitHub (ветка main) — без реальных данных.
#
# Что делает:
#   1. Проверяет метку SAFE-DEMO-SEED в seed_data.dart. Если её нет —
#      значит подставлен реальный сид: публикация ОТМЕНЯЕТСЯ.
#   2. Проверяет, что нет незакоммиченных изменений в master.
#   3. Пересобирает чистую ветку github-public (один коммит, без истории)
#      из текущего дерева master и force-push в origin main.
#   4. Возвращается на master.
#
# Реальные фамилии остаются только в локальной ветке master и на устройстве —
# на GitHub уходит лишь снимок текущего (демо) дерева, без истории.
#
# Использование (из корня проекта):
#   powershell -ExecutionPolicy Bypass -File scripts\publish-demo.ps1 "текст коммита"

param([string]$Message = "Табель — демо-версия (обновление)")
$ErrorActionPreference = "Stop"

# 1. Защита: демо-метка обязательна.
$seedPath = "lib/data/database/seed_data.dart"
if (-not (Select-String -Path $seedPath -Pattern "SAFE-DEMO-SEED" -Quiet)) {
    Write-Host "СТОП: в $seedPath нет метки SAFE-DEMO-SEED." -ForegroundColor Red
    Write-Host "Похоже, подставлен реальный сид. Публикация отменена — верни демо-сид." -ForegroundColor Red
    exit 1
}

# 2. Рабочее дерево должно быть чистым (всё закоммичено в master).
$dirty = git status --porcelain
if ($dirty) {
    Write-Host "СТОП: есть незакоммиченные изменения. Сначала закоммить их в master." -ForegroundColor Red
    exit 1
}

Write-Host "Метка демо на месте, дерево чистое. Публикую..." -ForegroundColor Green

# 3. Пересобрать чистую orphan-ветку из текущего дерева и выложить.
git branch -D github-public 2>$null
git checkout --orphan github-public
git add -A
git commit -m $Message | Out-Null
git push -f origin github-public:main

# 4. Вернуться на master.
git checkout master

Write-Host "Готово: GitHub main обновлён демо-версией. master (с реальными данными) не тронут." -ForegroundColor Green
