# diskrename.bash
This script is for renaming backup disks on macos. Makes uses of diskutil and FileVault.

My backup disk naming convention is \<hostname\>yyyymmdd. This script unlocks a FileVault encrypted backup disk and updates the date
portion of the name to the current date.

Example: A backup disk "MyMacBook20190415" is connected to the mac. The disk is locked with FileVault.

Executing diskrename.bash asks for the FileVault password, unlocks and mounts the disk, then offers to rename the disk from
MyMacBook20190415 to MyMacBook20190504 if the current date is 4th of May 2019. To prevent disks from accidental renaming,
the user is asked to type in a randomly generated string before the renaming happens.
