# rescreen
### verb

1. To [screen](https://en.wikipedia.org/wiki/GNU_Screen) again.


USB serial ports tend to disappear and reappear when you're working with attached devices. Rescreen is a `screen` reconnector for USB serial ports. It allows you to select which device you want to talk to, and when it disappears it allows you to choose another one.

# Usage

1. Download `rescreen.sh`
2. Allow execution `chmod +x rescreen.sh`
3. Run `./rescreen.sh`

   Optional flags:
4. * --baudrate=115200: Specify a baudrate. rescreen will not ask for a baudrate when a port is selected
   * `--auto-connect`: Automatically connect to the first selected port with the default baud rate within 1 second. Without this flag, you will be prompted to select a port each time.

# Requirements

screen is shipped with every Mac and Linux machine

gum

`brew install gum`
