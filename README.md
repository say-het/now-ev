# 🚀 Secure EV Rental Management

## 📌 Problem Statement
The electric vehicle (EV) rental industry is expanding but faces challenges with:
- 🔍 **User Verification:** Lack of robust KYC processes.
- 🔒 **Payment Security:** Issues with fraud risks and payment disputes.
- ⚡ **Operational Efficiency:** Inefficient approval workflows.

This project aims to **create a secure EV rental management module** for mobile/web platforms to address these challenges.

---

## 🛠️ Implementation

### 🔑 Authentication
- Users can **log in** manually or via **Google authentication**.
- OTP verification is required after logging in.

### 📝 Registration & KYC
- Users sign up manually or via Google authentication.
- Upload **Aadhar card** for verification (integrated with a dummy Digilocker API).
- Data is **encrypted using SHA256** and stored securely.
- **Face verification & liveliness check** (blinking three times for validation).
- **Manual Approval Process**: Flagged scans undergo a separate review to ensure compliance.

### 💰 Wallet & Payments
- Users deposit money into a **wallet** before booking EVs.
- **Cost Calculation Formula:**
  ```bash
  Cost = Fixed_Cost * minutes_used / 60
  ```
- Automatic **wallet debit** based on ride duration.
- **Fixed deposit** of INR 500 for excess usage or damage coverage.

### 📲 Notifications
- Users receive **real-time notifications** for alerts and updates.

### 🔗 Interaction with Physical EV
- Users scan a **QR code** on the EV to unlock after payment verification.
- System verifies tokens stored on the phone with the **QR data** to enable unlocking.

---

## 🏗️ Tech Stack

### 🔧 Backend: **Flask**
### 🎨 Frontend: **Flutter**
### 🔐 Authentication: **Firebase**
### 🔎 Text Extraction, Face Matching & Liveliness Detection:
- 📜 **OCR**: Tesseract
- 🖼 **Face Matching & Liveliness**: OpenCV
### 📩 OTP & Notifications: **Twilio**
### 💳 Payment Service: **Square**
### 🗄 Database: **MongoDB**
### 🔒 Security Enhancements:
- **SOC | VAPT Concepts** for platform robustness
- **Blockchain** for wallet transactions
- **2-Factor Authentication (2FA)** for enhanced security

---

## 💼 Business Model
- 🚗 Rental options: **Scooters, Bikes, and Cars**
- ⏳ Cost calculated **per hour** for each EV type
- 💰 **Deposit Requirement:** INR 500 (used for damage/excess usage)
- 🏫 **Target customers:** University & college students
- 🏢 **Expansion plans:** Partnering with **colleges, universities & societies**

---

## 📈 Scaling Plans

### 📊 Business Growth
- Expand **target audience** beyond students to societies and corporate users.
- Collaborate with **electricity providers** for charging stations.
- Increase **EV fleet** options.

### 🏗️ Tech Scaling
- Upgrade **free/test services** to enterprise-level solutions.
- Introduce **subscription services** for frequent users.
- Implement **blockchain** for transparent transactions.

---

## 🏞 UI & Implementation Flow

### 📸 Screenshots


<img src="https://github.com/user-attachments/assets/da74b2b3-11e1-4778-89c5-34dc3962dfee" width="400" height="700">
<img src="https://github.com/user-attachments/assets/1c30463a-a975-4fbd-8191-f5789a6ad9f7" width="400" height="700">
<br>
<img src="https://github.com/user-attachments/assets/88bb8a4b-5cc8-400c-be48-9fd979d09292" width="400" height="700">
<img src="https://github.com/user-attachments/assets/2c8a4d2c-3b98-4c73-a77a-d572f061041b" width="400" height="700">
<br>
<img src="https://github.com/user-attachments/assets/734a1fbf-f599-4854-b7c0-2b3dc31bf3b5" width="400" height="700">
<img src="https://github.com/user-attachments/assets/794f3efa-3e13-4635-a8c5-86a86190e4a2" width="400" height="700">




### 🔄 Implementation Flow
👉 Add implementation flow images here



![Implementation Flow](path/to/your/image2.png)

## 📚 References
- [Square API Docs](https://developer.squareup.com/docs)
- [Twilio Docs](https://www.twilio.com/docs)
- [Tesseract OCR](https://tesseract-ocr.github.io/tessdoc/)
- [OpenCV Docs](https://docs.opencv.org/4.x/index.html)
- [IEEE Research](https://ieeexplore.ieee.org/document/1081706)

---

## 💻 Installation & Setup
1. Clone the repository:
   ```bash
   git clone https://github.com/your-repo.git
   ```
2. Install dependencies:
   ```bash
   pip install -r backend/requirements.txt
   flutter pub get
   ```
3. Run the backend:
   ```bash
   python backend/app.py
   ```
4. Run the frontend:
   ```bash
   flutter run
   ```

---

## 🎯 Future Enhancements
- **AI-powered fraud detection** for fake KYC submissions.
- **EV route optimization** using real-time GPS tracking.
- **Dynamic pricing** based on demand and peak hours.

---

## 🤝 Contributors
- [Het Modi](https://github.com/say-het)
- [Jay Shah](https://github.com/Jay-1409)
- [Krish Chothani](https://github.com/KrishChothani)
- [Jainil Patel](https://github.com/JainilPatel2502)
- [Raj Mistry](https://github.com/raj-mistry-01)

💡 *Feel free to contribute by submitting pull requests!* 

# Team Big Brains
