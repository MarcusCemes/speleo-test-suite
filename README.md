<div align="center">

# *Speleo MT-2019* Test Suite

🔥 An automated build/test script for the EPFL C++ *Speleo MT-2019* project. Written purely in bash 🔥
<br /><sub>Formally known as the <i>Boulic-Proof Test Suite</i></sub>

</div>

<div align="center">

![EPFL][badge-epfl]&nbsp;&nbsp;
![Bash][badge-bash]&nbsp;&nbsp;
[![Release][badge-release]][link-release]&nbsp;&nbsp;
![Compliance][badge-compliance]

<br />

<img width="600" src="https://gist.githubusercontent.com/MarcusCemes/854b9eead943ec8aeb7ed17e203f4239/raw/7931faa3d7e302d83135d86bd2d7f8c6434518bc/speleo-test-suite-demo.svg" alt="An example of usage">

<br />
<br />

**Quick Links**<br>
[Prerequisites](#prerequisites) &nbsp;**•**&nbsp;
[Installation](#installation) &nbsp;**•**&nbsp;
[Usage](#usage) &nbsp;**•**&nbsp;
[Performance Analysis](#performance-analysis) &nbsp;**•**&nbsp;
[Updating](#updating)

</div>


## Preface

This test suite is derived from the C++ *ColoReduce MT-2018* project. It is *strongly recommended* to understand the C++ build/debug process, and use this only as a helper to double-check your work. Experiment with your own build/test scripts!

While providing out-of-the-box support for the *Speleo* project, the build/test scripts can easily be modified to support most simple C++ projects.

### ✅ What this does

- 🛠️ Compiles your program with the official C++ compilation tool and [compilation flags](lib/compiler.sh)
- 🤔 Compares the output *and* execution time of your program against the reference program
- 🤨 Judges you.

### ❌ What this doesn't do

- 🐛 Fix your bugs automagically
- ✏️ Write your program for you
- 😎 Turn you into a pro-coder
- 🧮 Solve the *P versus NP problem*
- 🦄 Make unicorns real

## Prerequisites

This tool is purely written in Bash, and works universally on most Linux systems (and probably also on WSL/emulators). The only required dependencies are the `g++`, `script` and `time` commands.

```bash
$ sudo apt install g++
```
<div align="center"><sub>This is most likely already installed on your system</sub></div><br />

## Installation

The recommended way to grab a copy of the test suite is to run `git clone`.

```bash
$ git clone https://github.com/MarcusCemes/speleo-test-suite.git
```
<div align="center"><sub>Type this in a terminal (without the "$") to download the suite</sub></div><br />

If you don't have `git`, you can also use the `Clone or download` → `Download ZIP` button at the top of this page. This will not support updates.

## Usage

The test suite comes with all the standard *Speleo* tests and the reference demo program by default. To run the test suite, provide your source code to the `run.sh` script like so:

```bash
$ ./run.sh ../path/to/source.cpp
```
<div align="center"><sub>

You may need to add execute permissions with `chmod +x run.sh`

</sub></div><br />

This will compile your C++ code with the official compilation flags and stricter syntax enforcement, before executing the binary against each test and running the performance analysis.

You may add your own tests to the `tests/` directory. Each file represents a single test, and is piped to the program via `stdin`. The execution results, for manual inspection, will be generated under the `results/` directory.

## Performance Analysis

The performance analysis will score your program against a reference program. The Speleo binary is bundled by default, but this may be replaced with any other binary.

Each test is worth **3 points**. A negative score for your test will deduct from your total.

### Output correctness

The most important factor in the examination, verifying if your algorithm provides correct results.

- `+3` **Correct** - Your program outputs byte-perfect results.
- `+1` **Similar** - Your program has the same output with all spacing and new-lines removed. Maybe you're missing a new-line at the end?
- `+0` **Incorrect** - Your output did not match the reference output.

### Execution time

While not explicitly required by the regulations, a long execution time probably means there's something quite wrong and may result in your submission being terminated pre-maturely for safety reasons.

- `+0` **Negligible** - If the reference program is faster than 100ms.
- `+0` **Faster** - Your program was faster than the reference program!
- `+0` **Acceptable** - Your program was 1-2x slower than the reference program.
- `-2` **Too slow** - Your program was more than 2x slower than the reference program!

## Updating

The `run.sh` script can automatically update itself. If prompted, the script will automatically download new commits from GitHub and pull the changes into the repository using `git pull`.

In order for the auto-update function to work, you must have downloaded the repository using `git clone`. This will correctly initialize the the `remote` branch.

If you have messed something up, you can revert all local changes and re-synchronize yourself with GitHub by running the following:

```bash
$ git reset --hard origin/master
```
<div align="center"><sub>⚠ This will delete ALL modifications you may have made! Be warned! ⚠</sub></div><br />

To skip updates altogether, such as when making your own changes to avoid merge conflicts, you can do pass a second parameter as shown below. You can manually update by running `git pull`.

```bash
$ ./run.sh code.cpp --no-update
```

## Contributing

This was written as my own collection of automation scripts, which I decided unify, document and share with others as a result of the amount of work I put into it.

Got an idea? Create an [issue][link-issue] or submit a [pull request][link-pull-request].

## Disclaimer

This is in no way an official evaluation, just a handy helper to make your life a bit easier. Don't rely solely on this.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Author

* **Marcus Cemes** \<marcus.cemes@epfl.ch\>


<!-- BADGES -->
[badge-epfl]:https://img.shields.io/badge/EPFL--c70d3a.svg?style=for-the-badge
[badge-bash]:https://img.shields.io/badge/Bash--f45905.svg?style=for-the-badge
[badge-release]:https://img.shields.io/github/release/MarcusCemes/speleo-test-suite.svg?style=for-the-badge&color=45969b
[badge-compliance]:https://img.shields.io/badge/Speleo-v1.0-512c62.svg?style=for-the-badge

<!-- LINKS -->
[link-release]:https://github.com/MarcusCemes/speleo-test-suite/releases/latest
[link-issue]:https://github.com/MarcusCemes/speleo-test-suite/issues
[link-pull-request]:https://github.com/MarcusCemes/speleo-test-suite/pulls
