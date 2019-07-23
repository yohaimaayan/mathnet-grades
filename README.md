# Mathnet grade scraper

A little bash script that scrapes the Technion Mathnet website for grades in one or more courses, and organizes the results in `.csv` files.

## Prerequisites

You will need to make sure that `curl` is installed on your system.
For Debian/Ubuntu, use

```
apt-get install curl
```
In general, replace `apt-get` with the appropriate package manager.
For example,
```
brew install curl
```
for macOS. 

## Installing

Just download the script, or clone the repository:

```
git clone https://github.com/yohaimaayan/mathnet-grades.git
```

## Usage

Run the script with the course numbers as arguments:
```
./mathnet-grade.sh 104016 104004
```

## Contributing

This will probably be a short lived project, but contributions are welcome.
Issue a pull request and it will be reviewed.
