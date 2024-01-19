STM32CubeMX blank project for EDU32F103 v0.4 board using Makefile and including configurations for VS Code.

## Requirements

### System software

#### Ubuntu
- VS Code: https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64
- STM32CubeMX: https://www.st.com/content/ccc/resource/technical/software/sw_development_suite/group0/1a/ce/b1/79/ed/9c/42/9f/stm32cubemx-lin-v6-10-0/files/stm32cubemx-lin-v6-10-0.zip/jcr:content/translations/en.stm32cubemx-lin-v6-10-0.zip
- ARM-None-EABI toolchain: `sudo apt install gcc-arm-none-eabi`
- GDB MultiArch (or ARM-None-EABI): `sudo apt install gdb-multiarch`
- OpenOCD: `sudo apt install openocd`
- Make: `sudo apt install make`

If you installed GDB MultiArch (and not ARM-None-EABI), run the following command so that the Cortex-Debug extension in VS Code can find the appropriate GDB executable:
```
sudo ln -s /usr/bin/gdb-multiarch /usr/local/bin/arm-none-eabi-gdb
```

#### Windows
- VS Code: https://code.visualstudio.com/sha/download?build=stable&os=win32-x64-user
- STM32CubeMX: https://www.st.com/content/ccc/resource/technical/software/sw_development_suite/group0/d7/f0/6a/65/f9/28/4d/31/stm32cubemx-win-v6-10-0/files/stm32cubemx-win-v6-10-0.zip/jcr:content/translations/en.stm32cubemx-win-v6-10-0.zip

To automatically install all the following dependencies and the STM32Cube MCU package, run the "Install.cmd" script. Otherwise, install them manually:

- Arm GNU Toolchain:
    - https://developer.arm.com/-/media/Files/downloads/gnu/13.2.rel1/binrel/arm-gnu-toolchain-13.2.rel1-mingw-w64-i686-arm-none-eabi.exe
    - Check `Add path to environment variable` at the end of installation.
    - OR: `choco install -y gcc-arm-embedded`
- Chocolatey: `Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))`
- Make: `choco install make`
- OpenOCD: `choco install -y openocd`
- EDU32F103 Driver: https://bitbucket.org/edge-team-leat/microai_edu/downloads/InstallDriver_EDU32F103_v0.4-2.exe

### STM32Cube MCU package
- STM32CubeF1 (rename to `stm32cube_fw_f1_v180.zip`): https://www.st.com/content/ccc/resource/technical/software/firmware/40/db/b8/d5/bd/a7/41/b1/stm32cubef1.zip/files/stm32cubef1.zip/jcr:content/translations/en.stm32cubef1.zip
- STM32CubeF1 1.8.5 patch (rename to `stm32cube_fw_f1_v185.zip`): https://www.st.com/content/ccc/resource/technical/software/library/group0/39/89/07/72/a0/fe/4c/71/stm32cubef1-v1-8-5/files/stm32cubef1-v1-8-5.zip/jcr:content/translations/en.stm32cubef1-v1-8-5.zip

Extract to ~/STM32Cube/Repository, rename directory from v1.8.0 to v1.8.5

### VS Code extensions
Extensions are suggested when first opening the project, otherwise call the "Extensions: Show Recommended Extensions" command with Ctrl+Shift+P, or install them manually from VSIX:

- Microsoft C/C++: https://marketplace.visualstudio.com/items?itemName=ms-vscode.cpptools
- Microsoft Makefile Tools: https://marketplace.visualstudio.com/items?itemName=ms-vscode.makefile-tools
- Microsoft Serial Monitor: https://marketplace.visualstudio.com/items?itemName=ms-vscode.vscode-serial-monitor
- Marus Cortex-Debug: https://marketplace.visualstudio.com/items?itemName=marus25.cortex-debug
- Marus Cortex-Debug Device Support Pack STM32F1: https://marketplace.visualstudio.com/items?itemName=marus25.cortex-debug-dp-stm32f1

## How to use

### Generate base project source code with STM32CubeMX
- Start STM32CubeMX
- Load `EDU32F103_v0.4.ioc`
- Generate Code

### Open the project in VS Code
- Start VS Code
- Open this directory
- Install the recommended extensions

### Edit the source code
- In VS Code, open the `Core/Src/main.c` file
- Insert the following source code between the `USER CODE BEGIN WHILE` and `USER CODE END WHILE` markers:
```
    static unsigned int i = 0;

	  static char send_msg[255] = {'\0'};
	  size_t len = snprintf(send_msg, 255, "Hellord! %u\r\n", i);
	  HAL_UART_Transmit(&huart1, (const uint8_t *)send_msg, len, 0x200);

    i++;

    HAL_Delay(1000);
```
- You can edit the source code as you please but make sure to only edit inside the `USER CODE BEGIN` and `USER CODE END` markers

### Build and run with VS Code
- Make sure the EDU32F103 board is plugged in to the USB port, you may need to enter bootloader mode (press and hold `BOOT0` then press and release `RST#`, finally release `BOOT0` after a couple of seconds)
- Click `Start Debugging` in the `Run` menu, this will compile the source code, send the binary to the MCU, start it, and open the debugger

### Visualize the serial output
- In VS Code, click `New Terminal` in the `Terminal`
- Select the `Serial Monitor` tab in the bottom terminal window
- Select the correct serial port (e.g., `/dev/ttyUSB1`)
- Make sure baud rate is set to 115200
- Click `Start Monitoring`

## Command line usage

### Build
```
make
```

### Flash
```
openocd -f openocd.cfg -c init -c "reset halt; flash write_image erase ./build/EDU32F103_v0.4.elf; reset"
```

## Troubleshooting

### `fatal error: main.h: No such file or directory`
Do not use the `Debug C/C++ File` or `Run C/C++ File` commands of VS Code (top right button). This is designed to build and run a single file from a source tree on the local computer.

Instead, use the `Start Debugging` command in the `Run` menu or the `Run and Debug` button of the `Run and Debug` panel. This will build the project using the Make build system and run it on the target.

### `fatal error: core_cm3.h: No such file or directory`
The STM32CubeF1 firmware package is probably corrupt. Open the `STM32Cube` folder in your home directory and delete the `Repository` folder.

You can try to run the `Install.cmd` script again.

Alternatively, you can let STM32CubeMX download the package when generating code but this will require to log into an STMicroelectronics account.

### `process_begin: CreateProcess(NULL, arm-none-eabi-gcc […]) failed. make (e=2): File not found.`
The Arm toolchain cannot be found.

First, try to logout and log back in to your Windows account or reboot the machine to reload environment variable.

Then, try to install it again by running `choco install -y gcc-arm-embedded --force` in a PowerShell as Administrator.

Alternatively, you can download and install the Arm GNU Toolchain 13.2 from https://developer.arm.com/-/media/Files/downloads/gnu/13.2.rel1/binrel/arm-gnu-toolchain-13.2.rel1-mingw-w64-i686-arm-none-eabi.exe .
Make sure to check `Add path to environment variable` at the end of installation.

### No `Debug with OpenOCD` launch configuration in the `Run and Debug` panel
Make sure to download the entire repository, using either `git clone` or the `Download Repository` link in the `Downloads` tab of BitBucket.
Make sure to open the Session1 folder itself in VS Code, otherwise the VS Code configuration in the `.vscode/` directory will not get loaded.

### `Could not start GDB process, does the program exist in filesystem?` or `GDB executable "arm-none-eabi-gdb" was not found.`
If running on Ubuntu/Debian (or a derivative), gcc-multiarch must be installed and a symbolic link from gdb-multiarch to arm-none-eabi-gdb must be created as follows:
```
sudo ln -s /usr/bin/gdb-multiarch /usr/local/bin/arm-none-eabi-gdb
```

### `OpenOCD: GDB Server Quit Unexpectedly.`
This means that there was an issue communicating with the board over the JTAG debug interface. Open the `Terminal` → `gdb-server` tab as suggested to get a more detailed error

#### `libusb_open() failed with LIBUSB_ERROR_NOT_FOUND`
On Windows, this most likely means that the board has an inappropriate driver loaded for the JTAG interface.
Open Device Manager, and look into the `Universal Serial Bus controllers` section.
You should see `EDU32F103 v0.4 JTAG` if the driver is correct.

If you see `USB serial interface A`, it is likely that the driver is incorrect. You can double check by opening the Properties window and clicking on the Driver tab.
If the driver vendor is FTDI, then the incorrect driver is selected. The device must use the Microsoft-provided WinUSB driver instead.
You can download and install the driver package again: https://bitbucket.org/edge-team-leat/microai_edu/downloads/InstallDriver_EDU32F103_v0.4-2.exe
Alternatively, you can use Zadig (https://zadig.akeo.ie/) software to set the driver manually.

#### `Error: no device found` (with no libusb error)
The board is probably not recognized at all. Check under the `Universal Serial Bus controllers` of Device Manager and try to unplug/replug.
Make sure the jumpers of J3 are seated properly and set appropriately, see section `4.1 USB routing selection header` of EDU32F103 v0.4 User Manual v0.1 (between FTDI+ and PORT+, and between FTDI- and PORT- in case of no USB hub).

#### `Error: timed out while waiting for target halted`
Try to put the board in bootloader mode by holding the `BOOT0` button and clicking the `RST#` button once.

### `Failed to launch GDB: Remote communication error. Target disconnected.`
Try to put the board in bootloader mode by holding the `BOOT0` button and clicking the `RST#` button once.

