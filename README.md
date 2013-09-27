# Pozi Connect Config

Pozi Connect, developed by Groundtruth, is a utility for translating and processing spatial and non-spatial data.

This repository contains the configuration files used by Pozi Connect for many of Groundtruth's clients. The projects include PIQA, M1s and Vicmap data loading.

## Client Instructions

To install the latest configuration into an existing installation of Pozi Connect:

1. backup your existing Pozi Connect configuration by renaming the Tasks folder (found within the PoziConnect folder) to something like 'Tasks.bak'
2.  download [this zip file](https://github.com/groundtruth/PoziConnectConfig/archive/master.zip)
3. unzip the zip file (to its default location or other temporary location)
4. rename the folder 'PoziConnectConfig-master' to 'Tasks'
5. move this Tasks folder into your PoziConnect folder (replacing the Tasks folder you renamed in Step 1.)

You are now ready to launch Pozi Connect (PoziConnect.exe).

#### Optional Setup

With the configuration now installed, your Pozi Connect task drop-down list will contain every task for every project maintained by Groundtruth in this repository.

If you want to see only the tasks relating to you, you may delete the unneeded Tasks subfolders, leaving only your folder and the '~Shared' folder. For instance, if your organisation's name is Melton, delete all folders with the Tasks folder except for '~Shared' and 'Melton'.

### Troubleshooting

#### I cannot find my PoziConnect folder.

Pozi Connect is typically installed at one of the following locations:

* C:\PoziConnect\
* C:\Program Files\PoziConnect\
* C:\Program Files\PoziConnect (x86)\
* C:\Users\\{your Windows user name}\Desktop\PoziConnect
* C:\Users\\{your Windows user name}\Downloads\PoziConnect
* C:\Downloads\PoziConnect

#### I cannot rename my 'Tasks' folder to 'Tasks.bak' because there is already a folder called 'Tasks.bak'.

The name you give your existing configuration folder is not important - only that it is not 'Tasks'. Instead, rename it to 'Tasks.bak2' or other unused name. Or delete any existing Tasks.bak folder if you no longer need it.

#### I cannot rename the 'PoziConnectConfig-master' folder.

You must unzip the zip file to a temporary location (such as the default unzip location suggested by your zip program) before you can rename the folder.

#### Pozi Connect cannot connect to my DSN

You may need to set up your DSN with a 32bit Windows driver. Run the 32bit ODBC setup wizard (instead of the standard DSN wizard in the Control Panel). At the Windows Start menu, type in `cmd`, then at the command-line prompt, type or paste in the following, then hit 'Enter':

`c:\windows\sysWOW64\odbcad32.exe`

#### I experience an error 'Errno -1073741512'

Go into your `C:\Windows\System32\` or `C:\Windows\SysWOW64\` folder and see if there is a file called libeay32.dll. If so, rename it to libeay32.bak.
 
Try running Pozi Connect again. If that solves the problem, you may leave the dll file in its renamed state. It's possible that other applications may rely on this dll file and could complain, but reverting the file name will resolve that. If this situation occurs, contact Groundtruth to discuss a more permanent solution.
 