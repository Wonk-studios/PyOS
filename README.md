# PyOS

PyOs.

PyOS is a rudimentary python interpreter operating system I started in 2024 as a hobby project and wrote by myself. It allows you to paint off the canvas, and take your projects next level.

How to use:

1. fork the repository into your own.

2. Open "/workspaces/PyOS/PyOS/interpret/script/script.py"

3. Write your python script in that file

4. Make.
	For Linux/Unix users:
	- Run build.bash
	For Windows users:
	- Run build.bat

For Python Modules:
The stock interpreter does not support any python modules. In order to be able to interpret Python modules you must install the corresponding plugin from the website or organization and install them into "/workspaces/PyOS/PyOS/interpret/plugins/".

>[!NOTE]
>You will need to know how to write makefile code to install plugins in order to have the plugins be compiled!

## Alternative method for modules
- Each official PyOS plugin comes with a "compiled" folder, and instructions are included in the readme under compiled folder.

>[!IMPORTANT]
>The operating system has not been fully written. Do not download the operating system until it has been written.
>THIS PROJECT IS WORK IN PROGRESS!

DO NOT REMOVE THE LICENSE!

System requirements:
- Memory: Minimum 200 mb
- Disk storage: Minimum 20 GB free disk space
- Network: Broadband internet connection
- Software: Python 2.7 minimum, 3.x reccomended

For nerds:
- Firmware: must boot to 0x7C00 for boot manager
- UEFI support is optional but recommended
- Minimum 2 GHz dual-core processor
- At least 1 GB of swap space
- Support for virtualization (VT-x or AMD-V)
- Network interface card (NIC) with PXE boot capability
- Serial console redirection support
