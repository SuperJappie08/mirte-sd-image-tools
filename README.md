## Prerequisites

You need Apptainer container. You can follow the instructions of the Apptainer manual to compile it ([from source](https://github.com/apptainer/apptainer/blob/main/INSTALL.md)), or use a ([package](https://apptainer.org/docs/admin/main/installation.html#install-debian-packages)). For Ubuntu 20.04 this means:
   ```
   $ sudo add-apt-repository -y ppa:apptainer/ppa
$ sudo apt update
$ sudo apt install -y apptainer
   ```


## Installing the image builder

1. Clone this repository
   ```
   $ git clone https://github.com/mirte-robot/mirte_sd_image_tools.git
   ```
2. Install the sigularity image
   ```
   $ cd /mirte_sd_image_tools
   $ sudo ./install.sh
   ```

## Generating the Mirte SD image

1. Create the sd card image (this will take some time) (NOTE: this will overwrite existing images)
   ```
   $ ./run.sh build_sd_image
   ```
2. This will generate a mirte_orangepi_sd.img in the current directory
3. Use an image burning tool (e.g. dd or etcher ([link](https://www.balena.io/etcher/)) to burn it to an SD card


## Generating the Mirte SD image for a Raspberry Pi (2,3,4)

1. Create the sd card image (this will take some time) (NOTE: this will overwrite existing images)
   ```
   $ sudo ./run.sh build_sd_card raspberry
   ```
2. This will generate a mirte_raspberry_sd.img in the current directory
3. Use an image burning tool (e.g. dd or etcher ([link](https://www.balena.io/etcher/)) to burn it to an SD card


## Generating an SD card image using branches of Mirte repos

1. In the repository folder create a file called repos.yaml.
   ```
   $ nano repos.yaml
   ```
2. This yaml format used is the same as [vcstool](https://github.com/dirk-thomas/vcstool). The example below will create an image with the my_branch branch of the mirte-web-interface repository. For an overview of all the repositories used, have a look at the version in [install_scripts](https://github.com/mirte-robot/mirte_install_scripts/blob/main/repos.yaml).
```yaml
repositories:
  mirte-web-interface:
    type: git
    url: https://github.com/mirte-robot/mirte-web-interface
    version: my_branch
```

3. Create the sd card image (this will take some time) (NOTE: this will overwrite existing images)
   ```   
   $ ./run.sh build_sd_image [raspberrypi]
   ```

## (For Developer) Generating an SD card image using a local repository

1. Make sure you have one or more local repositories in <mirte-sd-image-tools>/git_local/.

```bash
.
├── git_local
│   └── mirte-install-scripts
```

2. Now create (or use an existing) repos.yaml, but now use another url by prepeding "/working_dir/" as can be seen in the example below. Please note that this will checkout the branch mentioned, so you need to commit changes to that branch.

```yaml
repositories:
  mirte-install-scripts:
    type: git
    url: /working_dir/git_local/mirte-install-scripts
    version: master
```

3. Create the sd card image (this will take some time) (NOTE: this will overwrite existing images)
   ```
   $ sudo ./run.sh build_sd_card [raspberry]
   ```

## Generating an SD card image using modifications made on a Mirte robot
TODO


## Run created Armbian image on non ARM machine
1. Make sure you have a Mirte image called mirte_orangepi_sd.img in the repository directory

2. Start an ARM shell
   ```
   $ sudo ./run.sh image_shell [orangepi|raspberry]
   ```
3. Note that you are logged in as root now. In order to switch to the mirte user please do (which will ask you to reset the default password (mirte_mirte)):
   ```
   # su mirte
   ```
4. You can now find all Mirte repositories in /usr/local/src/mirte
   ```
   $ ls /usr/local/src/mirte
   ```
