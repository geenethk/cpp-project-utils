# C++ Project Utils

A Windows utility that bootstraps modern C++ projects by automatically configuring:

- CMake
- Git & GitHub
- vcpkg
- Ninja

Create a ready-to-build C++ project in minutes without manually setting up your development environment.

---

## Features

- 🚀 Create new C++ projects from a guided setup wizard
- 🔧 Initialize a Git repository automatically
- 🌐 Optionally connect a GitHub repository
- 📦 Install and configure vcpkg
- ⚡ Install and configure Ninja
- 🏗️ Generate essential CMake project files
- 📁 Customize project folder structure
- 🖱️ Windows Explorer context menu integration

---

## Installation

Clone the repository:

    git clone https://github.com/geenethk/cpp-project-utils.git
    cd cpp-project-utils

Run the setup script:

    setup-dev-env.bat

### What the setup script does

`setup-dev-env.bat` automatically:

- Downloads and installs **vcpkg**
- Downloads and installs **Ninja**
- Configures the required environment settings
- Adds Windows Registry entries for Explorer context menu integration

---

## Usage

1. Right-click a folder (or inside a folder).
2. Select **Dev → Create C++ Project**.
3. Complete the setup wizard:

### Project Configuration

- **Project Name**  
  Choose the name of your new project.

- **GitHub Repository URL** *(optional)*  
  Connect the project to an existing GitHub repository, or leave blank to skip GitHub integration.

- **Custom Project Structure** *(optional)*  
  Override the default project layout.

  Default structure:

  ```text
  project/
  ├── src/
  └── include/
  ```

---

## Generated Project Setup

A newly created project includes:

- Git repository initialization
- CMake build configuration
- vcpkg integration
- Ninja build support
- Configurable source and header directories

---

## Requirements

- Windows
- Git
- Internet connection (for downloading dependencies)

---

## License

See the LICENSE file for details.
