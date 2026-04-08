+++
date = '2025-04-08T22:20:00+07:00'
draft = false
title = 'Ironi Seorang Digital Marketer: Nge-hack Router Xiaomi 3 Demi Memblokir Iklan'
tags = ["Tech", "OpenWRT", "Digital Marketing", "Irony", "Router", "AdBlock", "Privacy"]
+++

## Kenapa Saya Membenci Iklan (Padahal Kerjaannya Nge-iklan)

Ya, saya sadar ini ironi yang cukup lucu. Saya adalah digital marketer. Setiap hari saya bikin strategi iklan, optimasi kampanye, analisis data conversion rate, mikirin targeting yang paling efektif buat klien-klien saya. Tapi di sisi lain? Saya benci iklan. Sebenci-bencinya.

Bukan karena iklan itu jahat atau salah. Tapi karena saya *capek*. Setiap hari sudah dikelilingi iklan di berbagai platform—Facebook, Instagram, Google, TikTok—you name it. Di kantor, di rumah, di jalan, di handphone. Iklan ada di mana-mana. Dan saya sudah cukup.

## Titik Jenuh: "Gue Udah Muak!"

Hari itu biasa saja. Saya browsing laptop, mau nonton YouTube santai. Tapi sebelum video dimulai, ada iklan 15 detik. Lalu 30 detik. Lalu double iklan yang tidak bisa di-skip. Setelah itu? Iklan banner di website. Iklan popup. Iklan di aplikasi. Iklan di game. Iklan di email.

Saya berhenti sejenak dan mikir: "Ini rumah gue. Kenapa gue harus lihat iklan di rumah gue sendiri?"

Itu titik baliknya. Saya memutuskan untuk mengambil kendali penuh atas jaringan internet di rumah. Dan solusinya adalah: **router modifikasi dengan sistem adblock di level network**.

## Apa itu OpenWRT? (Dan Kenapa Saya Pilih Ini)

Sebelum lanjut, mungkin ada yang bertanya-tanya: *"OpenWRT tuh apa sih?"*

**OpenWRT** adalah sistem operasi open-source yang didesain khusus untuk router. Bayangkan ini: kalau router kamu pakai firmware bawaan pabrikan (stock firmware), itu kaya HP Android tapi tanpa akses ke Play Store dan gak bisa install apa-apa. Murni apa yang diberikan pabrik, ya udah itu doang.

OpenWRT mengubah router "bodoh" itu jadi perangkat "pintar" yang bisa di-custom sesuai kebutuhan. Dengan OpenWRT, kamu bisa:

- Install berbagai macam aplikasi (packages) kaya VPN, AdBlock, QoS, monitoring tools
- Punya kontrol penuh atas network configuration
- Setup VLAN, mesh network, guest network yang advanced
- Otomatisasi berbagai hal via scripting
- Bikin router murah jadi powerful enterprise-grade device

Intinya? **Freedom.** OpenWRT memberikan kebebasan untuk mengontrol infrastruktur internet di rumah sendiri, tanpa dibatasi oleh kebijakan vendor.

> 💡 **Fun fact:** Nama OpenWRT berasal dari WRT54G, router Linksys yang legendaris. "Open" karena open source, "WRT" dari Wireless Router. Jadi technically, ini adalah tribute kepada router yang bikin WiFi mainstream di rumah-rumah.

## Target: Xiaomi Mi Router 3

Kenapa Xiaomi Mi Router 3? Karena:

1. **Murah** - Dapet second di marketplace cuma 80-100 ribu
2. **Powerful enough** - Hardware 128MB RAM, 128MB Flash cukup buat OpenWRT
3. **OpenWRT compatible** - Komunitasnya besar, dokumentasi lengkap
4. **WiFi dual-band** - 2.4GHz dan 5GHz, cukup buat rumah

Router ini sebenarnya router entry-level, tapi dengan OpenWRT, dia bisa jadi monster kecil yang powerful.

## Proses Hacking (Baca: Flashing)

### Step 1: Persiapan Alat Perang

- Xiaomi Mi Router 3 (tentu saja)
- Kabel LAN
- Laptop dengan Ethernet port (atau USB-to-Ethernet adapter)
- Software PuTTY (Windows) atau Terminal (Mac/Linux)
- File firmware OpenWRT yang compatible
- Niat dan kesabaran (ini yang paling penting)

### Step 2: Unlock & Flashing

Ini bagian yang tricky. Xiaomi tidak bikin router ini "plug and play" buat modifikasi. Prosesnya kurang lebih:

1. **Unlock SSH** - Harus request ke Xiaomi, tapi untungnya ada exploit buat bypass ini
2. **Backup stock firmware** - Jaga-jaga kalau gagal, bisa balikin ke semula
3. **Flash bootloader (Breed)** - Ini intermediat bootloader yang bikin proses flashing aman
4. **Flash OpenWRT firmware** - Masukin firmware OpenWRT yang sudah disiapkan

Prosesnya memakan waktu sekitar 2-3 jam, termasuk googling kalau ada error (dan pasti ada error).

### Step 3: Setting OpenWRT

Setelah OpenWRT terinstall, router sudah tidak lagi pakai interface Xiaomi yang user-friendly. Sekarang kita punya akses penuh ke Linux-based router system.

Setting awal yang perlu dilakukan:

- Konfigurasi network (WAN, LAN, WiFi)
- Setting password root
- Update package lists
- Install luci (web interface) biar gak perlu command line terus

## Yang Ditunggu-tunggu: Instalasi AdBlock

Ini inti dari semua usaha. OpenWRT punya package **adblock** yang bisa diinstall via opkg (package manager OpenWRT).

```bash
opkg update
opkg install adblock luci-app-adblock
```

Selesai install, konfigurasinya via web interface (LuCI) atau command line. Adblock bekerja dengan cara:

1. **DNS-based blocking** - Nge-block domain-domain iklan di level DNS
2. **Multiple blocklists** - Bisa pakai blocklist dari EasyList, AdGuard, StevenBlack, dsb
3. **Automatic updates** - Blocklist diupdate otomatis setiap hari
4. **Device-wide protection** - Semua device yang connect ke router ikut kena blokir iklan

### Hasilnya?

- ✅ YouTube di TV Smart: Tanpa iklan
- ✅ Browsing di laptop: Tanpa banner ads
- ✅ Main game di handphone: Tanpa iklan popup
- ✅ Streaming di tablet: Tanpa pre-roll ads
- ✅ Semua device di rumah: Auto protected

**Bliss.**

## Ironi yang Lebih Dalam

Saya sadar ini hipokrisi yang cukup lucu. Saya kerja bikin iklan, tapi saya juga pengen bebas dari iklan. Tapi coba pikirkan: sebagai digital marketer, saya tahu persis seberapa invasif dan mengganggu iklan itu. Saya tahu teknik targeting yang digunakan. Saya tahu cara kerja retargeting yang bikin iklan "ngikutin" user ke mana-mana.

Dan justru karena saya tahu, saya makin gak tahan lihat iklan.

Bedanya mungkin di sini: saya gak masalah dengan iklan yang **relevan dan respectful**. Iklan yang tidak mengganggu user experience. Tapi realitanya? Kebanyakan iklan di internet adalah spam visual yang memaksa.

## Buat Apa Semua Ini?

Beberapa orang bilang, "Ah, ribet amat. Kan bisa install adblocker extension di browser."

Benar. Tapi ada perbedaan besar:

| Browser Extension | Router-Level AdBlock |
|-------------------|---------------------|
| Hanya jalan di satu browser | Semua device, semua browser |
| Bisa di-circumvent website | Network-level, harder to bypass |
| Tidak proteksi apps/mobile | Semua apps kena proteksi |
| Perlu install di tiap device | Satu setup, whole house protected |
| Bisa conflict dengan website | DNS-level, lebih clean |

Plus, ada kepuasan tersendiri bisa mengutak-atik hardware, install custom firmware, dan punya kontrol penuh atas infrastruktur internet di rumah.

## Credits & Resources

Proses flashing Xiaomi Mi Router 3 ini gak mungkin tanpa kerja keras komunitas open source. Saya ingin berterima kasih dan memberikan credit kepada:

### 🛠️ OpenWRTInvasion
**Repository:** https://github.com/acecilia/OpenWRTInvasion

Ini adalah tool yang bikin proses unlock SSH di Xiaomi router jadi sangat mudah. Tanpa tool ini, kita harus melalui proses yang jauh lebih rumit dan berisiko. OpenWRTInvasion adalah exploit script yang memanfaatkan vulnerability di firmware Xiaomi untuk membuka akses root. *Brilliant work by the community!*

Kalau kamu punya Xiaomi Mi Router 3 (atau varian lain seperti 3G, 3A, 4, 4C, 4A), tool ini adalah starting point yang wajib.

### 🌐 OpenWRT Official
**Website:** https://openwrt.org/

Ini adalah sumber utama segala informasi tentang OpenWRT:
- Table of Hardware (TOH) buat cek compatibility router
- Documentation yang lengkap
- Forum komunitas yang aktif
- Download firmware official

Kalau mau mulai petualangan OpenWRT, situs ini adalah bible-nya. Mereka juga punya wiki yang super detail untuk hampir semua router yang pernah ada di muka bumi ini.

### 📚 Tutorial References
Selain dua resource di atas, saya juga belajar dari berbagai blog post, YouTube tutorial, dan forum thread dari komunitas OpenWRT Indonesia dan internasional. Komunitas ini amazing—selalu siap bantu newbie yang stuck di proses flashing.

## Kesimpulan

Saya mungkin digital marketer. Tapi saya juga manusia yang butuh *peace of mind* di rumah sendiri. Setelah setup ini, browsing jadi lebih cepat (karena gak perlu load iklan), baterai device lebih awet (gak perlu render iklan), dan yang paling penting: **saya merasa punya kendali**.

Dan mungkin itu pelajaran yang lebih besar: di era di mana tech giant mencoba mengontrol setiap aspek digital kita, ada kebebasan dalam mengambil kendali kembali. Meskipun itu cuma berarti nge-hack router murah demi menghilangkan iklan.

Ironis? Ya. Worth it? **Sangat.**

---

**P.S.** Buat yang mau coba, silakan cek resource yang saya sebut di atas. Prosesnya memang butuh waktu dan kesabaran, tapi hasilnya worth it. Tapi ingat, flashing firmware ada risiko bricking router. Do with your own risk! 😉

**P.P.S.** Jangan bilang-bilan ke klien saya ya kalau saya blokir iklan di rumah. *It's our little secret.* 🤫

**Tags:** #OpenWRT #RouterHack #AdBlock #DigitalMarketing #TechDIY #Privacy #XiaomiRouter
