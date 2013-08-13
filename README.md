# Pozi Connect Config

Pozi Connect, developed by Groundtruth, is a utility for translating and processing spatial and non-spatial data.

This repository contains the configuration files used by Pozi Connect for many of Groundtruth's clients. The projects include PIQA, M1s and Vicmap data loading.

## Client Instructions

To install the latest configuration into an existing installation of Pozi Connect:

1. backup your existing configuration by renaming the Tasks folder (found within the PoziConnect folder) to something like Tasks.bak
*  download [this repository](https://github.com/groundtruth/PoziConnectConfig/archive/master.zip)
*  unzip the zip file (to its default location or a temporary location)
*  rename the folder PoziConnectConfig-master to Tasks
*  move this folder into your PoziConnect folder in the place of the folder your renamed in Step 1.

### Troubleshooting

#### I cannot find my PoziConnect folder.

It is typically installed at one of the following locations:

* C:\Program Files\PoziConnect\
* C:\PoziConnect\
* C:\Users\{your Windows user name}\Desktop\PoziConnect

#### I cannot rename the 'PoziConnectConfig-master' folder.

You must unzip the zip file to a temporary location (such as the default unzip location suggested by your zip program) before you can rename the folder.

#### There is already a folder called 'Tasks.bak' in my PoziConnect folder.

Instead, rename your 'Tasks' to 'Tasks.bak2' or other unused name, or delete any existing Tasks.bak folder if you don't need it.