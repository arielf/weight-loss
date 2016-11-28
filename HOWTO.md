# How to run this code

------------------
## Prerequisites:

This code depends on:

>- vowpal wabbit (aka vw)
>- R
>- ggplot2 (an R library to create charts)
>- GNU make
>- git (to clone this repository)
>- bash, perl, and python (these are usually preinstalled and available on all Linux and MacOs systems)

------------------
## Installation of prerequisites:

#### Linux: Ubuntu, Mint, or any Debian derivative 

>    sudo apt-get install make vowpal-wabbit r-base r-base-core r-cran-ggplot2 git

#### Other Linux systems

Packages are usually named differently.
Contributions to this section very welcome

#### MacOs / OS-X

Use `brew` to install the above packages
Contributions to this section very welcome

#### Windows

The only sane way to run this code in a Windows environment, is to install run Ubuntu Linux on a VM (virtual machine) inside Windows, and use the Ubuntu instructions in the VM.

For instructions how to set up a VM on Windows, follow these youtube videos:
>    - http://www.howtogeek.com/170870/5-ways-to-run-linux-software-on-windows/
>    - https://www.youtube.com/watch?v=uzhA5p-EzqY

One you have Ubuntu on Windows you just install all the prerequisites. e.g. in a terminal:

>    sudo apt-get install make r-base r-base-core r-cran-ggplot2 vowpal-wabbit git

inside it, to run everything from start to finish.


------------------
## Running the code

Using git, you clone this repository:

>    git clone https://github.com/arielf/weight-loss

And change directory to it:

>    cd weight-loss

Finally type:

>    make

It should produce a file `scores.txt` with your weight-loss scores.

To get a chart of the scores:

>    make sc

or

>    make score-chart

------------------
## Changing `make` parameters

There are a few adjustable variables (which have reasonable defaults) in the
`Makefile`, and which you may change if interested:

To change these you may call `make` with arguments changing the
values, like this: 

>     make VarName1=Value1 VarName2=Value2 ...

The current variables and their defaults settings are:

    BS = 7            # -- bootstrapping rounds
    P = 4             # -- multiple passes over the data
    L = 0.05          # -- learning rate
    L2 = 1.85201e-08  # -- L2 regularization
    NDAYS = 3         # -- Aggregate consecutive daily-data up to NDAYS days


