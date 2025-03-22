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
👉 Add your UI photos here

### 🔄 Implementation Flow
👉 Add implementation flow images here

![1](https://github.com/user-attachments/assets/8892e81f-c09c-4cf9-9aa7-52c305109f5e)

![2](https://github.com/user-attachments/assets/ed383b14-5bfb-444d-9652-004d7eca9783)

![3](https://github.com/user-attachments/assets/9fcbb63a-e23a-4676-b9d5-e2ba66a2d26a)

![31](https://github.com/user-attachments/assets/c45fe508-d30a-4689-8ff4-57fc6868ec6e)

![4](https://github.com/user-attachments/assets/0e202667-f843-4662-b12b-3a5850426879)

![32](https://github.com/user-attachments/assets/dca67435-c33f-4f0a-b373-ead345435af7)

![5](https://github.com/user-attachments/assets/985d8fe9-7148-4e19-bc47-bb5c619e7873)

![6](https://github.com/user-attachments/assets/c9485cf9-5e6f-4606-8ef0-1911d8388597)

![40](https://github.com/user-attachments/assets/c63a8006-3780-4d82-bf95-a8e148cc5e38)

![7](https://github.com/user-attachments/assets/4060eb6e-8f44-4fab-85cd-7d763cd67435)

![40](https://github.com/user-attachments/assets/3aee04b8-07cb-46fe-a290-0e0eef9de2b0)


---

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
- [Raj Mistry](https://github.com/raj_mistry01)

💡 *Feel free to contribute by submitting pull requests!* 

# Team Big Brains



readme
