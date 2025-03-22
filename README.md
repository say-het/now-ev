# now-ev
# Secure EV Rental Management

## Problem Statement
The electric vehicle (EV) rental industry is expanding but faces challenges with user verification, payment security, and operational control. Existing systems often lack robust KYC processes, secure payment handling, and efficient approval workflows, leading to fraud risks, payment disputes, and inefficiencies. This project aims to address these challenges by creating a secure EV rental management module for mobile/web platforms.

## Implementation

### Login
- Users can log in manually or via Google authentication.

### Registration
- Users can sign up manually or via Google authentication.

### OTP
- After logging in, users receive an OTP for verification.

### KYC
- Users upload their Aadhar card, verified against a dummy database replicating the Digilocker API.
- Data is encrypted using SHA256 and stored in the database.
- Users provide camera permissions for face verification and liveliness checks (e.g., blinking three times).
- The KYC scan results are sent for manual approval. Flagged scans are reviewed separately to minimize compliance workload.
- 
### Wallet and Payments
- Users deposit money into a wallet before booking EVs from nearby stations.
- Rental costs are calculated using the formula: Cost = Fixed_Cost * minutes_used / 60.
- The wallet is automatically debited based on the duration of the ride.

### Notifications
- Users receive real-time notifications for alerts and updates.

### Interaction with Physical EV
- Users scan a unique QR code attached to the EV after payment verification.
- The system compares tokens stored on the user's phone with those from the QR code to unlock the vehicle.

## Tech Stack

- *Backend*: Flask
- *Frontend*: Flutter
- *Authentication*: Firebase
- *Text Extraction, Face Matching, Liveliness Detection*: [Specify libraries/tools]
- *OTP and Notification Service*: Twilio
- *Payment Service*: Square
- *Data base*:MongoDB
- *Face matching and liveliness check* Tesseract for OCR (OPTICAL CHARACTER RECOGNITION) and Open CV

## Business Model
- Offers scooter, bike, and car rentals.
- Cost per hour rental calculation for each EV type.
- Fixed deposit of INR 500 for situations where wallet balance is exceeded or vehicle damage occurs.
- The deposit balance is used to cover excess costs, and users must replenish it before booking new rides.
- We will partner with colleges and universities and setup our EV Stands in colleges and universities
- Target customers: university and college students.

## Scaling
### Business
- we can expand the target customers from not just students of univerisities and colleges to societies making our services availiable for everyone to use 
- Since we are using electric vehicles we can partner with electricity providers.
- We can include more vehicles
### Technology
- The techologies can be scaled significantly, currently we use free and test services which can be replaced state of the arth srevices 
- Substription services can be introduces
- SOC | VAPT Concepts to make the platform robust
- Blockchain for the transactions from wallet
- 2 Factor Authentication 

## References
- https://developer.squareup.com/docs
- https://www.twilio.com/docs
- https://tesseract-ocr.github.io/tessdoc/
- https://docs.opencv.org/4.x/index.html
- https://ieeexplore.ieee.org/document/10817060
