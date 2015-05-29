# NSRR Ruby Gem

[![Build Status](https://travis-ci.org/nsrr/nsrr-gem.svg?branch=master)](https://travis-ci.org/nsrr/nsrr-gem)
[![Dependency Status](https://gemnasium.com/nsrr/nsrr-gem.svg)](https://gemnasium.com/nsrr/nsrr-gem)
[![Code Climate](https://codeclimate.com/github/nsrr/nsrr-gem/badges/gpa.svg)](https://codeclimate.com/github/nsrr/nsrr-gem)

The official ruby gem built to simplify file downloads and dataset integration tasks for the [National Sleep Research Resource](https://sleepdata.org).

## Prerequisites

You must have **Ruby 2.0+ installed** on your system to use the NSRR gem.

- [Install Ruby on Windows](http://rubyinstaller.org/)
- [Install Ruby on Mac](https://github.com/remomueller/documentation/blob/master/macosx/140-install-ruby.md)
- [Install Ruby on Linux (CentOS)](https://github.com/remomueller/documentation/blob/master/centos/140-install-ruby.md)

## Installation

Install it yourself as:

    $ gem install nsrr --no-ri --no-rdoc

Or add this line to your application's Gemfile:

    gem 'nsrr'

And then execute:

    $ bundle


## Usage

### Download files from a dataset

**Note:** You can type `Ctrl-C` to pause downloads and resume later by retyping the command.

Download an entire dataset.

```console
$ nsrr download shhs
```

Download a subfolder of a dataset.

```console
$ nsrr download shhs/forms
```

Download a folder without downloading contents of subfolders. By default, when not specified, the command will recursively download all contents of the specified folder and subfolders.

```console
$ nsrr download shhs/datasets --shallow
```

Continue an in progress download and only compare file sizes. By default, when a downloaded file already exists, the command will do an MD5 file comparison to verify the file is identical to the one on the server. The MD5 comparison is exact, but can be slow on older machines. If you want a quick check, you can tell the command to simply compare the file sizes of the local file and the file on the server which speeds up the comparison process, however it may in some cases be inaccurate.

```console
$ nsrr download shhs --fast
```

Redownload all files and overwrite any existing downloaded files.

```console
$ nsrr download shhs --fresh
```

You can combine the file check flag with the folder depth flag as well.

```console
$ nsrr download shhs/datasets --shallow --fast
```

### Open the console and download entire datasets

```console
$ nsrr console
```

```
> d = Dataset.find 'shhs'
> d.download
  Get your token here: https://sleepdata.org/token
  Your input is hidden while entering token.
     Enter your token: AUTHORIZED
           File Check: md5
                Depth: recursive

      create shhs/
      create shhs/datasets
   identical shhs-cvd-dataset-0.6.0.csv
   identical shhs-data-dictionary-0.6.0-domains.csv
   identical shhs-data-dictionary-0.6.0-forms.csv
   identical shhs-data-dictionary-0.6.0-variables.csv
   identical shhs1-dataset-0.6.0.csv
   ...
```

**method**
  - 'md5' [default]
    - Checks if a downloaded file exists with the exact md5 as the online version, if so, skips that file
  - 'fresh'
    - Downloads every file without checking if it was already downloaded
  - 'fast'
    - Only checks if a download file exists with the same file size as the online version, if so, skips that file

**depth**
  - 'recursive' [default]
    - Downloads files in selected path folder and all subfolders
  - 'shallow'
    - Only downloads files in selected path folder

For example to download only the shhs1 edfs folder and skip MD5 file validation:

```
> d = Dataset.find 'shhs'
> d.download('edfs/shhs1', method: 'fast', depth: 'shallow')

  Get your token here: https://sleepdata.org/token
  Your input is hidden while entering token.
     Enter your token: AUTHORIZED
           File Check: md5
                Depth: recursive

      create shhs/edfs/shhs1
    download 100001.EDF
    download 100002.EDF
    download 100003.EDF
    download 100004.EDF
    ...
```

You can type `Ctrl-C` to pause the download, and retype the command to restart:

```
> d = Dataset.find 'shhs'
> d.download

  Get your token here: https://sleepdata.org/token
  Your input is hidden while entering token.
     Enter your token: AUTHORIZED
           File Check: md5
                Depth: recursive

      create shhs/
      create shhs/datasets
    download shhs-cvd-dataset-0.6.0.csv
    download shhs-data-dictionary-0.6.0-domains.csv
^C
    Interrupted

Finished in 4.384734 seconds.

1 folder created, 2 files downloaded, 60 MiBs downloaded, 0 files skipped, 0 files failed

> d.download

  Get your token here: https://sleepdata.org/token
  Your input is hidden while entering token.
     Enter your token: AUTHORIZED
           File Check: md5
                Depth: recursive

      create shhs/
      create shhs/datasets
   identical shhs-cvd-dataset-0.6.0.csv
   identical shhs-data-dictionary-0.6.0-domains.csv
^C
    Interrupted

Finished in 2.384734 seconds.

1 folder created, 0 files downloaded, 0 MiBs downloaded, 2 files skipped, 0 files failed
```

### Update the NSRR gem

To make sure you're using the latest stable version of the NSRR gem, you can run the following command:

```
nsrr update
```

### Show the version of the NSRR gem

```
nsrr version
```

### Show the available commands of the NSRR gem

```
nsrr help
```
