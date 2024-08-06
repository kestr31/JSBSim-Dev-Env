# JSBSim Development Environment Container and Script Tools

- This repository contains a Dockerfile and a set of scripts to build a Docker container for JSBSim development.
- The container is based on Ubuntu 22.04 LTS (jammy) and includes all the necessary tools to build and run JSBSim.
- The container is designed to be used with the provided scripts to simplify the development process.

## 1. Pre-requisites

### 1.1. HW & OS-Specific Requirements

- AMD64(x64) Based Linux System (Recommends Ubuntu 22.04 LTS)
- Network Connection (For downloading external resources)

### 1.2. SW Requirements

- `sudo` permission

## 2. Initial Setup and Basic Usage

### 2.1. Initial Setup

- First, clone this repository.

```bash
git clone https://github.com/kestr31/JSBSim-Dev-Env.git
```

- Then, run `initial_setup.sh` to install docker.
- The script will ask you to reboot the system after the installation.
- **You must reboot the system to apply the changes and run scripts properly.**

```bash
cd jsbsim-dev-env
./initial_setup.sh
```

- After the reboot, use following commands to clone and build the JSBSim to the JSBSim container workspace.
- The workspace is set to `${HOME}/Documents/JSBSim` by default.
- `1.2.0` of JSBSim is cloned and built by default.

```bash
./script/run.sh clone
./script/run.sh build
```

### 2.2. Basic Usage

- You can deploy the JSBSim development environment container with the following command.
    - The container will do nothing after deployment.

```bash
./script/run.sh debug
```

- After deployment, you can enter the container with the following command.
    - Then you can do development work inside the container.
- Or you can use [VSCode](https://code.visualstudio.com/docs/setup/linux) with [Remote Development](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.vscode-remote-extensionpack) extension to develop inside the container more easily (**Recommended**).

```bash
docker exec -it jsbsim-env bash
```

- Use following command to kill the deployed container.
- All works saved inside the workspace directory (`/home/user/workspace` in the container) will be preserved.

```bash
./script/run.sh stop
```

## 3. Script Details

### 3.1. `initial_setup.sh`

```bash
./script/initial_setup.sh
```

- This script installs `docker` and add user to the group `docker`.
- The script will ask you to reboot the system after the installation.
- You only need to run this script once after cloning the repository.
- If you have `docker` installed and if the user is already in the `docker` group, you can skip this script.

### 3.2. `build.sh`

```bash
./script/build.sh
```

- This script builds the JSBSim development environment container.
- By default, the container is tagged as `kestr3l/jsbsim:latest`.
- This value is hardcoded in the script and can be changed manually.

### 3.3. `run.sh`

```bash
./script/run.sh [run|stop|debug|clone|build|clean|*.sh]
```

- This script deploys the JSBSim development environment container and provides additional functionalities.
- **Available arguments**:
    - `run`: Deploy the JSBSim development environment container.
    - `stop`: Kill the deployed container.
    - `debug`: Deploy the JSBSim development environment container in debug mode (sleep infinity).
    - `clone`: Clone the JSBSim repository to the JSBSim container workspace.
    - `build`: Build the JSBSim in the JSBSim container workspace.
    - `clean`: Remove the JSBSim repository and the built JSBSim in the workspace.
    - `*.sh`: Run any user-defined script placed under `scripts` directory of the JSBSim container workspace.

## 4. LICENSE

- This repository is licensed under the MIT License.