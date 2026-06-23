# Vent App

An app for connecting to and controlling the respiratory rate of a chest training model.

From the home screen, select the **Vent App** button to enter the Vent App. The Vent App screen contains the following features:

- **Back arrow/button (< icon)** in the top left-hand corner. This takes the user back to the home screen.
- **Status indicator text** in the top middle of the screen. This displays the following statuses:
    1. "Ready" - when the Vent App is first opened, and no connecting is happening yet.
    2. "Scanning" - when the **Scan** button is clicked. This is shown while the app is finding the peripheral device (the chest training model).
    3. "Connecting" - when the peripheral device has been found, and is being connected to.
    4. "Connected" - when the peripheral device is successfully connected.
- **Help button (? icon)** in the top right-hand corner. Clicking this displays a "How to Use" dialog box/pop-up, with simple usage instructions for the Vent App.
- **Report issue button (! icon)** in the top right-hand corner, next to the Help button. Clicking this displays a "Report Issue" dialog box/pop-up, with a button that takes the user to an online form to report an issue. The dialog says "Go to the form to report an issue?", and has buttons **Cancel** and **Yes**.
- **Scan button** to start scanning for the peripheral device.
- **Enter Respiratory Rate text input** in the middle of the screen. The user can type numbers into this input to specify a respiratory rate which the chest training model will use.
- **Start button** which starts the respiration in the chest training model. This starts it with whatever respiratory rate is inputted into the text input. If a respiratory rate is not provided or is invalid, an "Input Issue" dialog box will be displayed, saying "Please only input numbers from 0-30".
- **Specific respiratory rate option buttons** including 10, 16 and 20. These are under the Start button. Clicking one of these immediately starts or updates the training model with the selected respiratory rate, and also fills the selected rate into the Respiratory Rate text input.
- **Weak and Strong buttons**. The currently selected one is coloured red, while the unselected one is coloured grey. Selecting one changes the respiratory rate immediately to that setting. The **Strong** button is selected initially by default.
- **Stop button** at the bottom of the screen. This stops the respiration in the chest training model if it is going.

**NOTE:** Selecting the specific respiratory rate option buttons, Weak, Strong, or Stop buttons while not connected to the peripheral devices causes a **Not Connected** dialog box to be displayed, telling the user "Please connect before modifying heart rate".

**NOTE:** The Vent App uses Bluetooth to connect to peripheral devices, so make sure your Bluetooth is turned on/enabled on your mobile device/tablet.

## How to Use the Vent App

1. Click **Scan**. Wait until the status says "Connected".
2. Enter a respiratory rate and click **Start**. Alternatively, use one of the preset buttons.
3. If you want to change the strength, click **Weak**/**Strong**.
4. To stop, click **Stop**.
5. If you have found an issue or bug, click the warning icon in the top right to fill out a report form.