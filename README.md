# NSRR Ruby Gem

[![Build Status](https://travis-ci.com/nsrr/nsrr-gem.svg?branch=master)](https://travis-ci.com/nsrr/nsrr-gem)
[![Code Climate](https://codeclimate.com/github/nsrr/nsrr-gem/badges/gpa.svg)](https://codeclimate.com/github/nsrr/nsrr-gem)

The official ruby gem built to simplify file downloads and dataset integration tasks for the [National Sleep Research Resource](https://sleepdata.org).

## Prerequisites

You must have **Ruby 2.4+ installed** on your system to use the NSRR gem.

- [Install Ruby on Windows](https://github.com/remomueller/documentation/blob/master/windows/130-ruby.md)
- [Install Ruby on Mac](https://github.com/remomueller/documentation/blob/master/macos/130-install-rvm.md)
- [Install Ruby on Linux (CentOS)](https://github.com/remomueller/documentation/blob/master/centos/130-install-rvm.md)

## Installation

The following commands can be run in **Command Prompt** on Windows, and in **Terminal** on Mac OS X.

Install it yourself as:

```console
gem install nsrr --no-document
```

## Usage

### Download files from a dataset

**Note:** You can type `Ctrl-C` to pause downloads and resume later by retyping the command.

Download an entire dataset.

```console
nsrr download shhs
```

Download a subfolder of a dataset.

```console
nsrr download shhs/forms
```

Download a folder without downloading contents of subfolders. By default, when not specified, the command will recursively download all contents of the specified folder and subfolders.

```console
nsrr download shhs/datasets --shallow
```

Continue an in progress download and only compare file sizes. By default, when a downloaded file already exists, the command will do an MD5 file comparison to verify the file is identical to the one on the server. The MD5 comparison is exact, but can be slow on older machines. If you want a quick check, you can tell the command to simply compare the file sizes of the local file and the file on the server which speeds up the comparison process, however it may in some cases be inaccurate.

```console
nsrr download shhs --fast
```

Redownload all files and overwrite any existing downloaded files.

```console
nsrr download shhs --fresh
```

You can combine the file check flag with the folder depth flag as well.

```console
nsrr download shhs/datasets --shallow --fast
```

You can specify a regular expression to filter files that are downloaded.

```console
nsrr download nchsdb/health_data --file="^PROCEDURE.*\.csv$"
```

```console
      create nchsdb/health_data/
     skipped DEMOGRAPHIC.csv
     skipped DIAGNOSIS.csv
     skipped ENCOUNTER.csv
     skipped MEASUREMENT.csv
     skipped MEDICATION.csv
  downloaded PROCEDURE.csv
  downloaded PROCEDURE_SURG_HX.csv
     skipped SLEEP_ENC_ID.csv
     skipped SLEEP_STUDY.csv
     skipped Sleep_Study_Data_File_Format.pdf
```

### Open the console and download entire datasets

```console
nsrr console
```

```
d = Dataset.find "shhs"
d.download
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
  - "md5" [default]
    - Checks if a downloaded file exists with the exact md5 as the online version, if so, skips that file
  - "fresh"
    - Downloads every file without checking if it was already downloaded
  - "fast"
    - Only checks if a download file exists with the same file size as the online version, if so, skips that file

**depth**
  - "recursive" [default]
    - Downloads files in selected path folder and all subfolders
  - "shallow"
    - Only downloads files in selected path folder

For example to download only the shhs1 edfs folder and skip MD5 file validation:

```
d = Dataset.find "shhs"
d.download("edfs/shhs1", method: "fast", depth: "shallow")

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
d = Dataset.find "shhs"
d.download

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

d.download

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

```console
nsrr update
```

### Show the version of the NSRR gem

```console
nsrr version
```

### Show the available commands of the NSRR gem

```console
nsrr help
```

## Common Issues

### Errors Running Ruby in Windows Command Prompt

In some cases when using Ruby on Windows through the Command Prompt, it is
necessary to open the Command Prompt in **administrator mode** for the NSRR gem
to work. This may be due to how Ruby was installed (for admins only), or the
location the files are being downloaded to (a root directory C: for example).

It is recommended to use the gem without elevated privileges first in any case
(to download directly to Desktop for example) before using admin privileges for
the Ruby gem.
