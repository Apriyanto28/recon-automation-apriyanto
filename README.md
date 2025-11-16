# Day Automation – Build Your Own Recon Automation Tool

## Deskripsi Proyek

Proyek ini merupakan tugas dari mentor dibimbing.id untuk melakukan proses reconnaissance terhadap lima domain website yang legal dan berada dalam allowed scope. Tujuan dari proyek ini adalah membangun sebuah alat otomatisasi (automation tool) berbasis Bash yang memanfaatkan beberapa perintah recon populer seperti:

* subfinder
* anew
* amass
* tee
* serta beberapa perintah Bash lainnya.

Tool ini dijalankan di lingkungan Linux.

---

## Setup Environment

Sebelum menjalankan script, pastikan environment sudah terpasang dengan benar. Berikut langkah-langkah pemasangannya.

### 1. Install jq dan golang-go

```
sudo apt update && sudo apt install -y git curl wget jq golang-go
```

### 2. Install Subfinder

```
GO111MODULE=on go install github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest
```

### 3. Install Amass

```
sudo apt install -y amass
```

### 4. Install httpx

```
GO111MODULE=on go install -v github.com/projectdiscovery/httpx/cmd/httpx@latest
```

### 5. Install anew

```
GO111MODULE=on go install github.com/tomnomnom/anew@latest
```

---

## Instalasi Otomatis (Rekomendasi)

Gunakan perintah berikut untuk menjalankan setup script otomatis:

```
wget https://gist.githubusercontent.com/yogikortisa/3101f7e80a31a63eff1536518423690c/raw/e3f7f1549df8e22c9cbb029a59d24056152bb14d/setup-recon.sh \
&& chmod +x setup-recon.sh \
&& ./setup-recon.sh
```

Note: Script ini akan memasang seluruh tools yang dibutuhkan secara otomatis.

---

## Cara Menjalankan Script

Pastikan Anda berada di folder yang memiliki struktur berikut:

```
input/
output/
logs/
scripts/
README.md
```

### 1. Isi daftar domain

```
nano input/domain.txt
```

Tambahkan domain yang ingin direcon (pastikan domain tersebut legal, public, atau memiliki izin).

Contoh domain:

```
example.com
mozilla.org
nginx.org
```

### 2. Berikan permission pada script

```
chmod +x scripts/recon-auto.sh
```

### 3. Jalankan automation tool

```
./scripts/recon-auto.sh input/domain.txt
```

Tunggu proses hingga selesai.

---

## Contoh Output

```
http://example.com [200] [Example Domain]
```

---

## Catatan Etika

* Hanya lakukan recon pada target yang memiliki izin tertulis atau berada dalam allowed scope.
* Tidak diperbolehkan melakukan scanning pada target ilegal atau tanpa persetujuan.

