How to run local server on your own device.

1. Download Python dan pastikan sudah berjalan dengan lancar.
2. Install pip untuk menginstall package yang diperlukan
3. Di terminal atau cmd, ketikkan
 - pip install flask
 - pip install PIL
 - pip install pytesseract
 - pip install googletrans
4. Install aplikasi Tesseract.
5. Pada imgTrans.py line-8 sesuai dengan folder install aplikasi Tesseract kamu.
6. Pada local.py line-20 ganti 192.168.1.4 dengan ip laptop tempat kamu menjalankan python.
7. Buka cmd lalu arahkan sampai ke folder 'TUGAS AI'
8. ketikkan py local.py