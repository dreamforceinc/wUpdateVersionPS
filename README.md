# wUpdateVersionPS

Скрипт PowerShell для автоматического обновления номера версии программы.

_**Файл ресурсов должен быть в ANSI или UTF-8 кодировке.**_


## Назначение скрипта ##
`wUpdateVersionPS` служит для автоматического обновления версии программы перед этапом компиляции в среде разработки Microsoft Visual Studio. Скрипт извлекает значение версии из файла, содержащего макрос или определение `APP_VERSION`, и записывает эту версию в блок `VERSIONINFO` файла ресурсов.

## Что делает скрипт? ##

1. Извлекает версию программы из заданного файла (*например `version.h`*), содержащего строку вида `#define APP_VERSION "X.Y.Z.W"`.

2. Обновляет в указанном файле ресурсов (*например `resources.rc`*) блок `VERSIONINFO`, содержащий строки `FileVersion` и `ProductVersion`, соответственно.

## Как запустить скрипт? ##

Запускайте скрипт командой в консоли PowerShell:

```bash
powershell.exe -ExecutionPolicy Bypass -File path\to\wUpdateVersionPS.ps1 arg1 arg2
```
Параметры:

`path\to\wUpdateVersionPS.ps1`: Полный путь к PowerShell-скрипту.

`arg1`: Путь к файлу, содержащему определение версии (`version.h`).

`arg2`: Путь к файлу ресурсов (`resources.rc`).

Например:

```bash
powershell.exe -ExecutionPolicy Bypass -File C:\Scripts\wUpdateVersionPS.ps1 C:\Project\version.h C:\Project\resources.rc
```

## Автоматизация запуска скрипта перед сборкой проекта ##

Вы можете добавить вызов скрипта в качестве предкомпиляционного шага в проекте Microsoft Visual Studio, выполнив следующие шаги:

1. Щёлкните правой кнопкой мыши по проекту в Solution Explorer и выберите пункт Properties.

2. Перейдите на вкладку Build Events, раздел Pre-Build Event, Command Line.

3. Добавьте туда следующий код:
```bash
powershell.exe -ExecutionPolicy Bypass -File "$(SolutionDir)wUpdateVersionPS.ps1" "$(ProjectDir)version.h" "$(ProjectDir)resources.rc"
```
> *В данном примере скрипт `wUpdateVersionPS.ps1` находится в папке решения, а файлы `version.h` и `resources.rc` - в папке проекта.*

4. Обновите определение макроса `APP_VERSION` в файле `version.h` (Например `APP_VERSION "1.0"` -> `APP_VERSION "1.1"`).

Таким образом, каждый раз перед компиляцией проекта версия программы будет автоматически обновляться.

_(c) 2026 Vladislav Salikov aka W0LF aka 'dreamforce'_

> _Этот текст создан с помощью Giga.Chat._
-----


# wUpdateVersionPS

A PowerShell script for automatically updating the program version number.

_**The resource file must be in ANSI or UTF-8 encoding.**_

## Script Purpose ##
`wUpdateVersionPS` is used to automatically update the program version before compilation in the Microsoft Visual Studio IDE. The script extracts the version value from a file containing the `APP_VERSION` macro or definition and writes this version to the `VERSIONINFO` block of the resource file.

## What does the script do? ##

1. Extracts the program version from the specified file (*e.g. `version.h`*) containing the string `#define APP_VERSION "X.Y.Z.W"`.

2. Updates the `VERSIONINFO` block in the specified resource file (*e.g. `resources.rc`*) containing the strings `FileVersion` and `ProductVersion`, respectively.

## How do I run the script? ##

Run the script with the following command in the PowerShell console:

```bash
powershell.exe -ExecutionPolicy Bypass -File path\to\wUpdateVersionPS.ps1 arg1 arg2
```
Parameters:

`path\to\wUpdateVersionPS.ps1`: Full path to the PowerShell script.

`arg1`: Path to the file containing the version definition (`version.h`).

`arg2`: Path to the resource file (`resources.rc`).

For example:

```bash
powershell.exe -ExecutionPolicy Bypass -File C:\Scripts\wUpdateVersionPS.ps1 C:\Project\version.h C:\Project\resources.rc
```

## Automating the execution of a script before building a project ##

You can add a script call as a pre-compile step in a Microsoft Visual Studio IDE by following these steps:

1. Right-click the project in Solution Explorer and select Properties.

2. Go to the Build Events tab, Pre-Build Event section, Command Line.

3. Add the following code there:
```bash
powershell.exe -ExecutionPolicy Bypass -File "$(SolutionDir)wUpdateVersionPS.ps1" "$(ProjectDir)version.h" "$(ProjectDir)resources.rc"
```
> *In this example, the `wUpdateVersionPS.ps1` script is located in the solution folder, and the `version.h` and `resources.rc` files are in the project folder.*

4. Update the definition of the `APP_VERSION` macro in the `version.h` file (e.g. `APP_VERSION "1.0"` -> `APP_VERSION "1.1"`).

This way, the program version will be automatically updated every time the project is compiled.

_(c) 2026 Vladislav Salikov aka W0LF aka 'dreamforce'_

> _This text was created using Giga.Chat._
