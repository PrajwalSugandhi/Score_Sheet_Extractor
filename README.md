# Score Sheet to Excel Conversion

**A Flutter-based app for automating the process of extracting marks from answer sheets into an Excel sheet, simplifying the workload for faculty members.**

---

## 🚀 Features

- Capture answer sheet images to detect student marks and roll numbers.
- Can either create new excel or use old excel.
- Extract marks from tables in answer sheets using Google Cloud Vision API / Github API + SERP API.
- Automatically populate an Excel sheet with marks and roll numbers using the Flutter `excel` package.
- Table detection using image processing algorithms for precise data extraction.
- Admin controls for managing student records (add/delete names and roll numbers).
- OAuth-based session authentication for secure admin access.

---

## 🛠️ Tech Stack

- **Frontend:** Flutter (Dart), Riverpod  
- **Backend:** Flask (Python)  
- **Database:** MySQL  
- **Cloud Services:** Google Cloud Platform (Vision API, OAuth)  
- **Tools:** Android Studio, VS Code, GitHub  
- **Libraries:**  
  - Optical Character Recognition (OCR)  
  - Template Matching  
  - Various Flutter packages, including `excel` for Excel operations and `cunning_document_scanner` for document cropping  
  - GitHub API for additional functionality


---

## 📽️ Video Demo

[Watch the Demo](https://drive.google.com/file/d/1KzOnyaMLB_DGLvTablAVS8J3eyXs3sWL/view?usp=sharing)  

---

## 💡 How It Works

1. The app provides two options: create a new Excel file or upload an existing one.
2. Users capture an image of a student's answer sheet using the app.
3. The image is captured using the Flutter `cunning_document_scanner` camera, which processes and sends only the document image to the backend.
4. The app detects the table containing marks and the student's roll number and extracts the data.
5. The roll number's location on the sheet is identified using template matching in the backend.
6. For creating a new Excel file, student names are retrieved from the database. For uploading an existing Excel file, the names are taken from the uploaded file.
7. Multiple entries can be added to a single Excel file.
8. The data is exported to an Excel sheet using the Flutter `excel` package and saved on the user's mobile device.
9. Admins can manage student records through a dedicated admin panel.