---
title: "Cara Membuat Lead Generator dari WiFi Captive Portal Menggunakan Ruijie Network Cloud + Google Sheets"
date: 2026-04-14
draft: false
tags: ["wifi-marketing", "lead-generation", "ruijie", "captive-portal", "google-sheets", "networking", "javascript"]
categories: ["Tutorial", "Networking", "Business Tech"]
author: "Agung Sukariman"
description: "Studi kasus lengkap bagaimana saya membangun sistem lead generator menggunakan WiFi captive portal mirip WiFi.id dengan Ruijie Network Cloud, custom login page, dan integrasi Google Sheets untuk menyimpan data pengunjung."
---

Beberapa waktu lalu, saya dapat tantangan menarik dari klien di bidang hospitality:

> *"Gimana caranya kita bisa collect data visitor (nama dan email) setiap kali mereka connect ke WiFi guest, tanpa perlu beli software mahal?"*

Singkat cerita: mereka punya venue di Bali dan mau memanfaatkan WiFi guest sebagai **lead generation tool**. Bayangin WiFi.id, tapi custom branding dan data lead-nya langsung masuk ke Google Sheets. *Challenge accepted!*

Di tulisan ini, saya akan share **end-to-end workflow** bagaimana saya membangun solusi ini menggunakan **Ruijie Network Cloud**, **custom captive portal HTML**, dan **Google Apps Script** sebagai webhook backend. Dokumentasi lengkap dan source code bisa cek di repo GitHub saya: [github.com/mewt/leadseedbali-connector](https://github.com/mewt/leadseedbali-connector/tree/main/portal_fresh).

---

## Apa Itu Captive Portal dan Kenapa Dipakai Buat Lead Gen?

**Captive portal** adalah halaman login/intercept yang muncul pertama kali saat user connect ke public WiFi. Contoh paling familiar di Indonesia ya **WiFi.id** — connect SSID-nya, langsung disambut halaman login.

Nah, ternyata halaman ini bisa kita *customize* dan jadikan **lead capture form**. Setiap orang yang mau internetan harus isi nama + email dulu. Data itu kita simpan, lalu otomatis redirect ke sosial media atau website venue.

**Stack yang saya pilih:**

| Komponen | Fungsi |
|----------|--------|
| **Ruijie Network Cloud** | Cloud controller untuk manage AP (Access Point) dan deploy captive portal |
| **Custom HTML Portal** | Form capture nama & email dengan branding klien |
| **Google Apps Script** | Webhook gratis yang nerima POST data dan append ke Google Sheets |
| **Google Sheets** | Database sederhana untuk nyimpen leads |

Kenapa Google Sheets? Karena gratis, no-server, dan tim marketing klien bisa langsung akses real-time tanpa perlu login dashboard Ruijie.

---

## Arsitektur Sistemnya

Flow-nya sangat straightforward:

```
User connect Guest WiFi
        ↓
Redirect ke Custom Captive Portal (Ruijie Cloud)
        ↓
User isi Full Name + Email + checklist "Receive Offers"
        ↓
Klik "Connect Now"
        ↓
[1] Data dikirim via AJAX ke Google Apps Script Webhook
        ↓
[2] Ruijie one-click authentication triggered
        ↓
[3] User dapat akses internet
        ↓
[4] Redirect ke Instagram page (@THESEEDBALI)
```

Dua hal terjadi secara paralel di step klik tombol: **simpan lead ke Google Sheets** dan **buka akses internet user**.

---

## Step 1: Setup Google Sheets + Webhook (5 Menit)

Ini bagian paling gampang. Kita nggak perlu sewa VPS atau setup database. Cukup Google Sheets + Apps Script.

### Buat Google Sheet
1. Buka [sheets.new](https://sheets.new)
2. Beri nama: **"THE SEED WiFi - Guest Registrations"**
3. Di Row 1, isi header:
   - **A1:** `Timestamp`
   - **B1:** `Full Name`
   - **C1:** `Email`
   - **D1:** `Receive Offers`

### Buat Google Apps Script
1. Di Google Sheet, klik **Extensions → Apps Script**
2. Hapus default code, lalu paste kode dari file `google-apps-script.js` di repo saya:

```javascript
function doPost(e) {
  try {
    var params = (e && e.parameter) ? e.parameter : {};

    if (params.fullName || params.email) {
      var sheet = SpreadsheetApp.getActiveSpreadsheet();
      var targetSheet = sheet.getActiveSheet();
      targetSheet.appendRow([
        params.timestamp || new Date().toISOString(),
        params.fullName || "",
        params.email || "",
        params.receiveOffers === "true" || false
      ]);
      return ContentService.createTextOutput(
        JSON.stringify({ result: "success", message: "Data saved via query params" })
      ).setMimeType(ContentService.MimeType.JSON);
    }

    var contents;
    var postData = (e && e.postData) ? e.postData : null;
    if (postData && postData.contents) {
      contents = postData.contents;
    } else if (params.payload) {
      contents = params.payload;
    } else {
      return ContentService.createTextOutput(
        JSON.stringify({ result: "error", message: "No data found" })
      ).setMimeType(ContentService.MimeType.JSON);
    }

    var data = JSON.parse(contents);
    var sheet = SpreadsheetApp.getActiveSpreadsheet();
    var targetSheet = sheet.getActiveSheet();
    targetSheet.appendRow([
      data.timestamp || new Date().toISOString(),
      data.fullName || "",
      data.email || "",
      data.receiveOffers || false
    ]);

    return ContentService.createTextOutput(
      JSON.stringify({ result: "success", message: "Data saved via POST body" })
    ).setMimeType(ContentService.MimeType.JSON);
  } catch (error) {
    return ContentService.createTextOutput(
      JSON.stringify({ result: "error", message: error.toString() })
    ).setMimeType(ContentService.MimeType.JSON);
  }
}
```

### Deploy sebagai Web App
1. Klik **Deploy → New deployment**
2. Klik gear icon → pilih **Web app**
3. Isi:
   - **Description:** `WiFi Portal Webhook`
   - **Execute as:** `Me`
   - **Who has access:** `Anyone`
4. Klik **Deploy** dan copy Web App URL-nya (contoh: `https://script.google.com/macros/s/AKfycb.../exec`)

---

## Step 2: Bangun Custom Captive Portal

Ruijie Cloud punya fitur **Custom HTML Portal**. Artinya kita bisa upload file HTML/CSS/JS sendiri dan mengganti halaman login bawaan mereka.

### Struktur File Portal

```
portal_fresh/
├── index.html
├── css/
│   └── index.css
├── js/
│   ├── index.js          # Logic utama (webhook + auth)
│   ├── language.js       # i18n
│   ├── i18n/i18n.js
│   └── jquery/
│       └── jquery.min.js
├── img/
│   ├── logo-seed.PNG
│   ├── bg-alt.jpeg
│   └── loading.gif
└── loadConfig.json
```

### HTML Form-nya

Saya buat form sederhana dengan dua field utama: **Full Name** dan **Email**, plus checkbox consent:

```html
<div class="login-card">
  <div class="brand-section">
    <img class="brand-logo" src="./img/logo-seed.PNG" alt="THE SEED logo" />
    <div class="brand-subtitle">STAY CONNECTED TO THE SEED</div>
  </div>

  <div class="login-form-wrapper">
    <div class="login-item">
      <input class="rj-input" type="text" id="full_name" placeholder="Full Name" />
    </div>
    <div class="login-item">
      <input class="rj-input" type="email" id="email_input" placeholder="Email" />
    </div>
  </div>

  <div class="checkbox-row">
    <label class="checkbox-label">
      <input type="checkbox" id="receive_offers" />
      <span class="checkbox-custom"></span>
      Receive invitations and curated offerings
    </label>
  </div>

  <div class="login-button-wrapper">
    <button class="rj-btn rj-btn-primary login-btn" id="login_btn">Connect Now</button>
  </div>
</div>
```

Styling-nya saya buat pakai **glassmorphism** dengan background image venue-nya biar keliatan premium.

### JavaScript: Mengirim Data ke Google Sheets

Ini inti dari sistem lead generation-nya. Di `js/index.js`, saya taruh logic submit form:

```javascript
const WEBHOOK_URL = "https://script.google.com/macros/s/AKfycb.../exec";

$(document).on('click', '#login_btn', function() {
  const fullName = $('#full_name').val().trim();
  const email = $('#email_input').val().trim();
  const receiveOffers = $('#receive_offers').is(':checked');

  if (!fullName || !email) {
    showMsg('Please fill in all fields');
    return;
  }

  // Kirim data ke Google Sheets
  $.ajax({
    url: WEBHOOK_URL,
    method: 'POST',
    contentType: 'text/plain', // Penting! Hindari CORS preflight
    data: JSON.stringify({
      timestamp: new Date().toISOString(),
      fullName: fullName,
      email: email,
      receiveOffers: receiveOffers
    }),
    success: function() {
      // Trigger Ruijie auth setelah data tersimpan
      ruijieAuth();
    },
    error: function() {
      // Tetap auth meski webhook fail, jangan bikin user stuck
      ruijieAuth();
    }
  });
});
```

**Catatan penting soal CORS:** Google Apps Script secara default nggak handle `OPTIONS` preflight kalau kita kirim `contentType: application/json`. Solusinya? Pakai `contentType: 'text/plain'`. Data tetap JSON string, tapi browser nggak kirim preflight request. *Small hack, big impact.*

---

## Step 3: Auth Trigger dan Redirect

Setelah data lead tersimpan, user harus tetap bisa internetan. Di sini kita trigger Ruijie authentication.

Secara default, template Ruijie punya endpoint local:

```javascript
// Untuk local AP deployment
fetch('/api/auth/general', { ... })
```

Tapi ada **gotcha besar** di Ruijie Cloud: endpoint `/api/auth/general` itu **hanya bekerja di local AP**, bukan di cloud domain (`cloud-as.ruijienetworks.com`).

### Cloud vs Local AP

| Deployment Mode | Auth Endpoint | Keterangan |
|-----------------|---------------|------------|
| **Local AP** (EG/AC lokal) | `http://<AP-IP>/api/auth/general` | ✅ Langsung works |
| **Ruijie Cloud** | `https://cloud-as.ruijienetworks.com/api/auth/general` | ❌ 404, endpoint tidak ada |

Ini saya discover setelah debugging berjam-jam. Preview mode di dashboard Ruijie Cloud selalu keluar error **"Oops! Server Not Available"** karena preview itu cuma file viewer tanpa auth context.

**Solusi untuk Ruijie Cloud:** Saat user redirect ke captive portal, URL-nya sebenarnya sudah include query parameter seperti `sessionId`, `userUrl`, `wlanuserip`, dll. Parameter inilah yang harus kita parse dan gunakan untuk POST auth request ke endpoint yang benar.

Contoh URL saat redirect:
```
https://noc.ruijie.com.cn/...?sessionId=xxx&userUrl=xxx&wlanuserip=xxx
```

Di `js/index.js`, saya tambahkan parser:

```javascript
function getQueryParam(name) {
  const urlParams = new URLSearchParams(window.location.search);
  return urlParams.get(name);
}

function ruijieAuth() {
  const sessionId = getQueryParam('sessionId');
  const userUrl = getQueryParam('userUrl');
  
  // Logic auth untuk cloud environment
  if (sessionId && userUrl) {
    // POST ke userUrl atau endpoint yang disediakan Ruijie
    // ... implementation depends on exact Ruijie cloud version
  } else {
    // Fallback untuk local AP
    fetch('/api/auth/general', {
      method: 'POST',
      body: JSON.stringify({ auth_type: 'pass' })
    });
  }
}
```

*Detail exact endpoint untuk cloud auth bisa bervariasi tergantung versi firmware dan region Ruijie Cloud. Saya sarankan inspect network tab atau kontak support Ruijie untuk dapatkan endpoint exact.*

Setelah auth sukses, redirect ke halaman tujuan:

```javascript
window.location.href = 'https://www.instagram.com/THESEEDBALI/';
```

---

## Step 4: Zip dan Upload ke Ruijie Cloud

Setelah semua file siap, zip folder `portal_fresh`:

```bash
cd /path/to/portal_fresh/..
zip -r portal_fresh.zip portal_fresh/ -x "portal_fresh/.DS_Store"
```

Lalu upload ke Ruijie Cloud:
1. Login [Ruijie Cloud Dashboard](https://noc.ruijie.com.cn/)
2. Navigasi ke **Cloud Auth / Portal Management**
3. Pilih **Custom HTML Portal**
4. Upload `portal_fresh.zip`
5. Set **Post-login URL** ke: `https://www.instagram.com/THESEEDBALI/`
6. Apply policy ke SSID Guest WiFi yang sesuai

**Pastikan** walled garden di Ruijie mengizinkan domain `script.google.com` supaya webhook bisa jalan sebelum user login.

---

## Hasil Akhir

Sekarang setiap ada tamu yang connect ke WiFi:
1. Muncul halaman login custom dengan branding THE SEED
2. Isi nama dan email
3. Data otomatis masuk Google Sheets real-time
4. Dapat akses internet
5. Langsung redirect ke Instagram

**Screenshot Google Sheets hasil capture:**
*(bisa cek langsung di repo untuk detail teknis lengkapnya)*

Repo dengan full source code dan dokumentasi: [github.com/mewt/leadseedbali-connector](https://github.com/mewt/leadseedbali-connector/tree/main/portal_fresh)

---

## Lessons Learned

1. **Google Apps Script + `text/plain` = CORS-free webhook gratis.** No backend server needed.

2. **Ruijie Cloud ≠ Local AP.** Jangan asumsi endpoint local works di cloud. Always inspect query parameters saat real redirect.

3. **Graceful degradation.** Kalau webhook gagal, tetap trigger auth. Jangan bikin user stuck di portal hanya karena Google Sheets error.

4. **Keep it simple.** Klien nggak butuh dashboard fancy. Google Sheets + Data Studio sudah cukup powerful untuk tim marketing.

---

## Penutup

Dari challenge yang awalnya kelihatan kompleks, ternyata solusinya bisa sangat **lean dan no-cost** (selain hardware AP Ruijie). Custom captive portal + Google Sheets adalah kombinasi yang powerful untuk UMKM atau venue hospitality yang mau collect leads tanpa harus invest software mahal.

Kalau kamu punya setup serupa atau mau diskusi lebih detail soal endpoint auth Ruijie Cloud, feel free reach out atau buka issue di repo GitHub saya.

**Happy networking!** 🚀
