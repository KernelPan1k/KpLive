# KpLive

**KpLive** is based on **Mininal Linux Live** (thanks)

- The original source code is located here: https://github.com/ivandavidov/minimal

I added ntfs-3g, fuse and attr to manipulate Windows partitions, files and file attributes. The initial purpose of this Live is to restore the backups of the Windows registry created by KpRm.

To change the keyboard configuration (default us), you can do (for example):

- loadkeys us (default)
- loadkeys fr
- loadkeys fr_CH

This LiveCD contains 3 custom scripts:

- kprm_restore_hives: restore the backup of the windows registry created by KpRm -> https://github.com/KernelPan1k/kprm-restore-hives
- ntfs_attr: see/modify Windows file attributes -> https://gitlab.com/snippets/1720133
- noahdfear_driver.sh: noahdfear script that allows you to disinfect Windows drivers -> https://github.com/KernelPan1k/driver.sh

If you want to mount an NTFS partition you must use ntfs-3g:

- ntfs-3g /dev/sdax /mnt/point


Thank you to all the contributors of: **Mininal Linux Live** for your excellent work, you are incredible!
