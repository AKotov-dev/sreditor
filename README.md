# SrEditor - automatic rule editor for scanners
SrEditor designed for automatically inserting rules for scanners that are not in the lists of rules /etc/udev/rules.d/60-libsane.rules

1. In the list of connected USB-Devices (1), find your scanner that is not recognized when working with XSane and select it with the mouse
2. If the device is not in the list of rules, the necessary line (2) will be offered to insert into the file with the rules
3. Click the button "Plus" (Add & Apply) and reconnect the scanner

It can also be useful: rm -rf ~/.sane  
  
**Note_1:** Add the user to the desired groups `usermod -aG usb,scanner $(logname)`  
**Note_2:** For older devices, use the USB2 port to connect  
  
![](https://github.com/AKotov-dev/sreditor/blob/main/ScreenShot.png)
