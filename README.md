# LolzDOS 1.0

Ретро-ОС в браузере: настоящая x86 DOS-среда на [js-dos](https://js-dos.com) (DOSBox → WebAssembly).
*Lovely OS for lovely people.* — `lolzdos.apruxdomain.lol`

## Запуск

```sh
python3 serve.py        # Windows: serve.bat
# открыть http://localhost:8000/
```

Через `file://` страница не работает: браузер блокирует загрузку диска.
Эмулятор берётся из `./jsdos/`, а если его там нет — с CDN `v8.js-dos.com`.
Для работы без сети один раз выполните `./setup_offline.sh` (нужны npm и интернет).

**GitHub Pages:** Settings → Pages → Deploy from a branch → `main` / root. Проект статический, сборка не нужна.

## Возможности

- Верхняя панель: настройки (RAM 16/32/64 MB, дата, масштаб 4:3 / растянуть / 1:1, звук SB16 / SBPro / Speaker), Reboot, Fullscreen, часы, Copy history.
- Загрузка файлов в `C:\DOWNLOAD` кнопкой или перетаскиванием (разрешены только расширения, имеющие смысл для DOS, список — `ALLOWED` в `index.html`).
- Команда `NET адрес` открывает сайт в оверлее поверх DOS (через файл `C:\NET_URL.TMP`, который опрашивает страница).
- Дискета A:: вставить `.img`, создать пустую 1,44 МБ, сохранить образ (перед сохранением выполните `EJECT`).
- Свои программы: `LOLZ.BAT`, `NET.BAT`, `EJECT.BAT`, `SNAKE.COM`, `VIEW.COM`, `NOW.COM`.

Подробности и ограничения: дата из настроек — виртуальные часы LolzDOS (`C:\LOLZDATE.CFG`), штатные `DATE`/`TIME` DOS показывают реальное время. Copy history берёт текст из консольного вывода DOS, программы, пишущие прямо в видеопамять, в него не попадают.

## Структура

```
index.html            страница и вся логика (диск собирается в браузере)
disk_c/               содержимое диска C:
disk_manifest.json    список файлов диска (генерируется build.py)
lolzdos.jsdos         запасной статический бандл (генерируется build.py)
bundle/.jsdos/        базовый dosbox.conf для lolzdos.jsdos
src/*.s               исходники .COM (GNU as, intel syntax)
serve.py / .bat / .sh локальный сервер
```

## Сборка

```sh
sh src/build_com.sh     # .COM из src/*.s, нужны GNU as и ld (binutils)
python3 build.py        # disk_manifest.json и lolzdos.jsdos
```

После изменения `disk_c/` запустите `build.py` и закоммитьте обновлённые `disk_manifest.json` и `lolzdos.jsdos`.
Имена папок и файлов на диске — не длиннее 8.3 символов.
