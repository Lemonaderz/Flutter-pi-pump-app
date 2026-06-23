# Vent App

The Vent App connects to a chest training model and controls its respiratory rate and respiration strength.

Use this document as a support reference for answering user questions about how the Vent App works.

## What the Vent App Does

- The user opens the Vent App from the home screen by tapping **Vent App**.
- The app scans for and connects to the chest training model over Bluetooth.
- Once connected, the user can start, change, or stop the respiration.

## Screen Elements

### Top Bar

- **Back arrow (< icon):** Returns to the home screen.
- **Status text:** Shows the current connection state.
- **Help button (? icon):** Opens a "How to Use" dialog with basic instructions.
- **Report issue button (! icon):** Opens a "Report Issue" dialog.

### Main Controls

- **Scan button:** Starts scanning for the chest training model.
- **Respiratory Rate input:** Lets the user type a respiratory rate.
- **Start button:** Starts the respiration using the value in the Respiratory Rate input.
- **Preset respiratory rate buttons:** `10`, `16`, `20`.
- **Strength buttons:** **Weak** and **Strong**.
- **Stop button:** Stops the respiration.

## Status Text Meanings

- **Ready:** The Vent App has been opened and no scan or connection is currently in progress.
- **Scanning:** The app is searching for the chest training model.
- **Connecting:** The training model has been found and the app is attempting to connect.
- **Connected:** The app is successfully connected to the training model.

## How Each Control Behaves

### Scan

- Tapping **Scan** starts searching for the chest training model.
- The user should wait until the status text shows **Connected** before trying to change respiration settings.

### Respiratory Rate Input and Start

- The user can type a number into the **Respiratory Rate** input.
- Tapping **Start** starts the respiration at the entered respiratory rate.
- Valid respiratory rate values are numbers from `0` to `30`.

If the user taps **Start** with no value entered, or with an invalid value, the app shows this dialog:

- **Dialog title:** `Input Issue`
- **Dialog message:** `Please only input numbers from 0-30`

### Preset Respiratory Rate Buttons

- The preset buttons are `10`, `16`, and `20`.
- Tapping one of these buttons immediately starts or updates the respiration to that value.
- The tapped preset value is also filled into the Respiratory Rate input.

### Weak and Strong

- The strength options are **Weak** and **Strong**.
- **Strong** is selected by default when the Vent App first opens.
- The selected strength button is red.
- The unselected strength button is grey.
- Tapping **Weak** or **Strong** changes the respiration strength immediately.

### Stop

- Tapping **Stop** stops the respiration.

## Not Connected Behavior

If the user tries to use any of these controls before connecting:

- a preset respiratory rate button
- **Weak**
- **Strong**
- **Stop**

the app shows this dialog:

- **Dialog title:** `Not Connected`
- **Dialog message:** `Please connect before modifying respiratory rate`

## Report Issue Dialog

When the user taps the **Report issue** button:

- a dialog opens asking: `Go to the form to report an issue?`
- the dialog has two buttons: **Cancel** and **Yes**
- choosing **Yes** takes the user to an online issue report form

## Bluetooth Requirement

- The Vent App uses Bluetooth to connect to the training model.
- Bluetooth must be enabled on the user's phone or tablet for scanning and connection to work.

## Quick How-To

1. Open **Vent App** from the home screen.
2. Tap **Scan**.
3. Wait until the status text says **Connected**.
4. Enter a respiratory rate and tap **Start**, or tap a preset respiratory rate button.
5. If needed, tap **Weak** or **Strong** to change strength.
6. Tap **Stop** when you want to stop the respiration.
7. If needed, tap the **!** icon to report an issue.

## Support Answering Notes

- If a user says the controls are not working, first check whether the app status says **Connected**.
- If a user gets an input error, confirm they entered numbers only and that the value is between `0` and `30`.
- If a user cannot find the device, remind them that Bluetooth must be turned on.