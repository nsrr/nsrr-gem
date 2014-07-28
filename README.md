# NSRR Ruby Gem

[![Build Status](https://travis-ci.org/nsrr/nsrr-gem.svg?branch=master)](https://travis-ci.org/nsrr/nsrr-gem)
[![Dependency Status](https://gemnasium.com/nsrr/nsrr-gem.svg)](https://gemnasium.com/nsrr/nsrr-gem)
[![Code Climate](https://codeclimate.com/github/nsrr/nsrr-gem.png)](https://codeclimate.com/github/nsrr/nsrr-gem)

The official ruby gem built to simplify file downloads and dataset integration tasks for the [National Sleep Research Resource](https://sleepdata.org).

## Prerequisites

You must have [Ruby 2.0+ installed](https://github.com/remomueller/documentation/) on your system to use the NSRR gem.

## Installation

Add this line to your application's Gemfile:

    gem 'nsrr'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install nsrr

## Usage

### Open the console and download entire datasets

```console
$ nsrr console
```

```
> d = Dataset.find 'shhs'
> d.download

     File Integrity Check Method: md5
                           Depth: recursive
             Get your token here: https://sleepdata.org/token
Please enter your download token:
      create shhs/
      create shhs/datasets
   identical shhs-cvd-dataset-0.4.0.csv
   identical shhs-data-dictionary-0.4.0-domains.csv
   identical shhs-data-dictionary-0.4.0-forms.csv
   identical shhs-data-dictionary-0.4.0-variables.csv
   identical shhs1-dataset-0.4.0.csv
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

     File Integrity Check Method: fast
                           Depth: shallow
             Get your token here: https://sleepdata.org/token
Please enter your download token:

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

     File Integrity Check Method: md5
                           Depth: recursive
             Get your token here: https://sleepdata.org/token
Please enter your download token:

      create shhs/
      create shhs/datasets
    download shhs-cvd-dataset-0.4.0.csv
    download shhs-data-dictionary-0.4.0-domains.csv
^C
    Interrupted

Finished in 4.384734 seconds.

1 folder created, 2 files downloaded, 60 MiBs downloaded, 0 files skipped, 0 files failed

> d.download

     File Integrity Check Method: md5
                           Depth: recursive
             Get your token here: https://sleepdata.org/token
Please enter your download token:

      create shhs/
      create shhs/datasets
   identical shhs-cvd-dataset-0.4.0.csv
   identical shhs-data-dictionary-0.4.0-domains.csv
^C
    Interrupted

Finished in 2.384734 seconds.

1 folder created, 0 files downloaded, 0 MiBs downloaded, 2 files skipped, 0 files failed
```

### Show the version of the NSRR gem

```
nsrr version
```

### Show the available commands of the NSRR gem

```
nsrr help
```
