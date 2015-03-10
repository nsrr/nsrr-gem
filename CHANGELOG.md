## 0.2.0

### Enhancements
- The `nsrr download` command now allows users to download files from private datasets
- The `nsrr download` command provides better feedback on the validity of the authorization token provided by the user
- Use of Ruby 2.2.1 is now recommended

## 0.1.1 (October 23, 2014)

### Enhancements
- User token input is now hidden to prevent discovery of tokens in console history
- Use of Ruby 2.1.3 is now recommended

## 0.1.0 (September 29, 2014)

### Enhancements
- Added a `nsrr download` command that allows users to download partial or entire datasets
  - Example: `nsrr download shhs`
- Added a `nsrr console` command that allows users to access and download datasets and files
  - Datasets can be loaded in the console environment
    - `d = Dataset.find 'shhs'`
  - Dataset files can be downloaded as well
    - `d.download`
  - The download function can include a path, method, and depth
    - **path**
      - can be `nil` to download entire dataset or a string to specify a folder
    - **method**
      - 'md5' [default]
        - Checks if a downloaded file exists with the exact md5 as the online version, if so, skips that file
      - 'fresh'
        - Downloads every file without checking if it was already downloaded
      - 'fast'
        - Only checks if a download file exists with the same file size as the online version, if so, skips that file
    - **depth**
      - 'recursive' [default]
        - Downloads files in selected path folder and all subfolders
      - 'shallow'
        - Only downloads files in selected path folder
- Added a `nsrr update` command the provides the user with information on how to update the nsrr gem
- Added a `nsrr version` command the returns the current version of the nsrr gem
- Added testing framework to more easily add new tests for new features
