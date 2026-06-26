# Pulse App

The Pulse App connects to an arterial line training model and controls its pulse rate and pulse strength.

Use this document as a support reference for answering user questions about how the Pulse App works.

## What the Pulse App Does

- The user opens the Pulse App from the home screen by tapping **Pulse App**.
- The app scans for and connects to the arterial line training model over Bluetooth.
- Once connected, the user can start, change, or stop the pulse.

## Screen Elements

### Top Bar

- **Back arrow (< icon):** Returns to the home screen.
- **Status text:** Shows the current connection state.
- **Help button (? icon):** Opens a "How to Use" dialog with basic instructions.
- **Report issue button (! icon):** Opens a "Report Issue" dialog.

### Main Controls

- **Scan button:** Starts scanning for the arterial line training model.
- **Heart Rate input:** Lets the user type a heart rate.
- **Start button:** Starts the pulse using the value in the Heart Rate input.
- **Preset heart rate buttons:** `40`, `60`, `80`, `100`, `120`.
- **Strength buttons:** **Weak** and **Strong**.
- **Stop button:** Stops the pulse.

## Status Text Meanings

- **Ready:** The Pulse App has been opened and no scan or connection is currently in progress.
- **Scanning:** The app is searching for the arterial line training model.
- **Connecting:** The training model has been found and the app is attempting to connect.
- **Connected:** The app is successfully connected to the training model.

## How Each Control Behaves

### Scan

- Tapping **Scan** starts searching for the arterial line training model.
- The user should wait until the status text shows **Connected** before trying to change pulse settings.

### Heart Rate Input and Start

- The user can type a number into the **Heart Rate** input.
- Tapping **Start** starts the pulse at the entered heart rate.
- Valid heart rate values are numbers from `40` to `120`.

If the user taps **Start** with no value entered, or with an invalid value, the app shows this dialog:

- **Dialog title:** `Input Issue`
- **Dialog message:** `Please only input numbers from 40-120`

### Preset Heart Rate Buttons

- The preset buttons are `40`, `60`, `80`, `100`, and `120`.
- Tapping one of these buttons immediately starts or updates the pulse to that value.
- The tapped preset value is also filled into the Heart Rate input.

### Weak and Strong

- The strength options are **Weak** and **Strong**.
- **Strong** is selected by default when the Pulse App first opens.
- The selected strength button is red.
- The unselected strength button is grey.
- Tapping **Weak** or **Strong** changes the pulse strength immediately.

### Stop

- Tapping **Stop** stops the pulse.

## Not Connected Behavior

If the user tries to use any of these controls before connecting:

- a preset heart rate button
- **Weak**
- **Strong**
- **Stop**

the app shows this dialog:

- **Dialog title:** `Not Connected`
- **Dialog message:** `Please connect before modifying heart rate`

## Report Issue Dialog

When the user taps the **Report issue** button:

- a dialog opens asking: `Go to the form to report an issue?`
- the dialog has two buttons: **Cancel** and **Yes**
- choosing **Yes** takes the user to an online issue report form

## Bluetooth Requirement

- The Pulse App uses Bluetooth to connect to the training model.
- Bluetooth must be enabled on the user's phone or tablet for scanning and connection to work.

## Quick How-To

1. Open **Pulse App** from the home screen.
2. Tap **Scan**.
3. Wait until the status text says **Connected**.
4. Enter a heart rate and tap **Start**, or tap a preset heart rate button.
5. If needed, tap **Weak** or **Strong** to change strength.
6. Tap **Stop** when you want to stop the pulse.
7. If needed, tap the **!** icon to report an issue.

## Support Answering Notes

- If a user says the controls are not working, first check whether the app status says **Connected**.
- If a user gets an input error, confirm they entered numbers only and that the value is between `40` and `120`.
- If a user cannot find the device, remind them that Bluetooth must be turned on.