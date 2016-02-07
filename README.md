## grabcast

**grabcast** is based on the [radical](https://github.com/d-lord/radical) script for OS X<br /><br />
It has been modified for use in GNU/Linux environments and uses `gnome-screenshot` and `notify-send` 

### Features

 - Uses `gnome-screenshot` to take a screen grab of a window or area selection
 - Assigns a random name to the image
 - scp using authorised key to remote web server
 - Copies sharable URL to clipboard
 - Produces `notify-send` desktop notification when completed or failed

### Usage

#### Server

- Create a user with access to the web server folder
- Install [rssh](http://www.pizzashack.org/rssh/) to restrict user to scp/sftp only
- Configure a new SSH authorised key-pair for that user

#### Client

- Set the server name, user, authorised key in the script
- Use keyboard settings to configure hot-key launching i.e.` super+shift+a|w`

###### Command Line Switches
```
-a produces an interactive area selection screen grab
-w produces a screen grab of the current window (after 2s)
```

