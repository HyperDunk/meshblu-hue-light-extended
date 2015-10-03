A Meshblu connector for use in Octoblu or with other services.

### Usage

#### Gateblu Installation

Use (gateblu)[https://gateblu.octoblu.com/] to run this as a device.

#### Manual Installation

1. `npm install meshblu-util -g`
1. `npm install meshblu-hue-light-extended` or `git clone [GIT_URL]`
1. go into connector folder
1. `meshblu-util register -t device:meshblu-hue-light-extended > meshblu.json`
1. `meshblu-util claim`
1. `npm start` or to start with debug `DEBUG='meshblu-hue-light-extended*' npm start`


### Platform Dependencies

Edit the package.json to change the platformDependencies. This will show up when installing the connector in Octoblu and Gateblu.
