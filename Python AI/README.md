How to run local server on your own device.

1. Download Python dan pastikan sudah berjalan dengan lancar.
2. Install pip untuk menginstall package yang diperlukan
3. Di terminal atau cmd, ketikkan
 - pip install flask
 - pip install PIL
 - pip install pytesseract
 - pip install googletrans==3.1.0a0
4. Install aplikasi Tesseract. https://digi.bib.uni-mannheim.de/tesseract/tesseract-ocr-w64-setup-5.3.1.20230401.exe
5. Pada imgTrans.py line-8 sesuai dengan folder install aplikasi Tesseract kamu.
6. Pada local.py, di baris paling bawah, ubah ip yang saya set dengan ip laptop tempat kamu menjalankan python.
7. Buka cmd lalu arahkan sampai ke folder 'Python AI'
8. ketikkan py local.py