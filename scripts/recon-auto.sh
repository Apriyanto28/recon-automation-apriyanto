#!/bin/bash

# cara penggunaan perintah: 
# - Terlebih dahulu jadikan file script-auto.sh menjadi script yang bisa dijalankan
# dengan perinth: chmod +x script-auto.sh
# - Jalan script ini dengan perintah ./script-auto.sh [daftar domain yang mau di-recon]


# Perintah ini digunakan untuk mencegah terjadinya kesalahan pada perintah pada saat 
# dijalankan

# Perintah ini digunakan untuk menghentikan perintah apabila ada yang tidak berjalan
set -o errexit

# Perintah ini digunakan menghentikan perintah apabila variabel tersebut belum dikenalkan
# sebelumnya
set -o nounset

# Perintah ini digunakan untuk menghentikan proses apabila salah satu perintah pada 
# pipeline tidak berhasil dijalankan
set -o pipefail


# Melakukan konfigurasi dasar untuk menjalankan file

# Perintah ini berfungsi untuk mengambil argumen pertama yang dimasukkan oleh pengguna
# argumen tersebut berisi file domain-domain yang digunakan
# Apabila tidak mendapatkan argumen, maka secara default menggunakan file input/domain.txt
INPUT_FILE="${1:-input/domains.txt}"

# Perintah ini digunakan untuk menyimpan nama folder ke dalam variabel OUTDIR
OUTDIR="output"

# Perintah ini digunakan untuk menyimpan nama folder log ke dalam variabel LOGDIR
LOGDIR="logs"

# Perintah ini digunakan untuk menyimpan lokasi skrip yang sedang di jalankan
# ke dalam variabel SCRIPTDIR
SCRIPTDIR="$(dirname "$0")"

# Perintah ini berfungsi untuk menyimpan setiap progress yang berjalan ke dalam file log
# yang disimpan ke dalam folder LOGDIR dengan nama file progress.log
PROGRESS_LOG="$LOGDIR/progress.log"

# Perintah ini berfungsi untuk menyimpan setiap kesalahan yang terjadi pada saat 
# menjalankan perintah yang disimpna ke dalam folder LOGDIR dengan nama
# file errors.log
ERROR_LOG="$LOGDIR/errors.log"

# Perintah ini berfungsi untuk menyimpan setiap sub-domain yang didapatkan disimpan
# ke dalam file all-subdomains.txt yang disimpan di dalam folder OUTDIR
# Folder ini nantinya menyimpan setiap sub-domain dari perintah subfinder
ALL_SUBS="$OUTDIR/all-subdomains.txt"

# Perintah ini berfungsi untuk menyimpan setiap folder yang berstatus 200 (OK)
# ke dalam file live.txt yang disimpan di dalam folder OUTDIR
# Folder ini nantinya menyimpan setiap sub-domain live dari perintah httpx
ALIVE_OUT="$OUTDIR/live.txt"

# Perintah ini berfungsi dan sekaligus menjalankan perintah untuk membuat folder
# temporary/sementar untuk menyimpan semua file yang dijalankan pada script
# dengan nama folder TMPDIR
TMPDIR="$(mktemp -d)"

# Perintah ini bertujuan untuk menetapkan seberapa banyak jumlah sub-domain yang mau
# diperiksa secara bersamaan
HTTPX_THREADS=50


# Menambahkan beberapa fungsi dasar untuk membantu proses menjalankan script

# Perintah ini untuk menjalankan fungsi timestamp
timestamp() { 

# Perintah ini nantinya akan memunculkan hari dalam format
# %Y = 2025 (tahun dengan format full)
# %m = 11 (bulan dengan format angka
# %d = 11 (hari dalam folder angka)
# %H = 23 (waktu dalam folder 24 jam)
# %M = 52 (menit)
# %S = 30 (detik)
date +"%Y-%m-%d %H:%M:%S";

# Fungsi ini nantinya untuk menampilkan waktu saat ini ketika perintah tersebut dipanggil
}

# Perintah ini untuk menjalanakn fungsi log
log() { 

# Perintah ini nantinya bertujuan untuk menampilkan ke dalam layar sekaligus untuk 
# menyimpan ke dalam file log

# printf = berfungsi untuk mencetak keluaran dengan format tertentu
# %s %s\n = berfungsi untuk mencetak format 2 string yang digunakan
# NB: String pertama fungsi timestamp, String kedua pesan yang dimasukkan

# $(timestamp) = memanggil fungsi yang dibuatkan sebelumnya
# $* = mencetak string yang diberikan pada saat menjalankan fungsi log
# NB: log "cetak ke layar" => string = cetak ke layar

# | = berfungsi untuk mengirimkan keluaran ke perintah berikutnya
# tee = berfungsi untuk menampilkan hasil dan mengirimkan hasil ke dalam file
# -a = berfungsi untuk menambahkan hasil keluaran ke baris paling akhir
# $PROGRESS_LOG = nama file yang digunakan untuk file log
printf "%s %s\n" "$(timestamp)" "$*" | tee -a "$PROGRESS_LOG"

# Fungsi ini nantinya digunakan untuk menampilkan pesan terhadap proses yang dijalankan
# dan berfungsi untuk menyimpan semua proses yang dilakukan
}

# Perintah ini untuk menjalankan fungsi dari err
err() {

# Perintah ini nantinya bertujuan untuk menampilkan ke dalam layar sekaligus untuk
# menyimpan ke dalam file log

# printf = berfungsi untuk mencetak keluaran dengan format tertentu
# %s %s\n = berfungsi untuk mencetak format 2 string yang digunakan
# NB: String pertama fungsi timestamp, String kedua pesan yang dimasukkan

# $(timestamp) = memanggil fungsi yang dibuatkan sebelumnya
# ERROR = menambahkan pesan error sebagai penanda terjadi kesalahan pada saat
# script dijalankan

# $* = mencetak string yang diberikan pada saat menjalankan fungsi log
# NB: log "cetak ke layar" => string = cetak ke layar
# | = berfungsi untuk mengirimkan keluaran ke perintah berikutnya
# tee = berfungsi untuk menampilkan hasil dan mengirimkan hasil ke dalam file
# -a = berfungsi untuk menambahkan hasil keluaran ke baris paling akhir
# $PROGRESS_LOG = nama file yang digunakan untuk file log

# >&2 = berfungsi untuk menyimpan hasil kesalahan ketika script dijalankan
# NB: Perintah ini nantinya memberikan keluaran dalam bentuk kesalahan yang 
# terjadi pada perintah

printf "%s %s\n" "$(timestamp)" "ERROR: $*" | tee -a "$PROGRESS_LOG" >&2

# Fungsi ini nantinya digunakan untuk menampilkan setiap pesan kesalahan yang terjadi
# pada saat perintah dijalankan
}

# Perintah ini berfungsi untuk memasukkan setiap kesalahan pada perintah ke dalam
# file error.log yang sudah dibuat sebelumnya
exec 2>>"$ERROR_LOG"


# Menjalankan proses recon

# Mencetak log informasi untuk proses berjalan
log "=== Memulai Proses recon-auto.sh ==="
log "File berisi nama domain: $INPUT_FILE"

# Menghapus semua isi log yang pernah ada sebelumnya
: > "$ALL_SUBS"
: > "$ALIVE_OUT"

# Dikarenakan jumlah domain yang mau diproses lebih dari 1 baris, sehingga dilakukan
# proses perulangan dengan menggunakan while

# Perintah ini digunakan untuk melakukan proses perulangan
# IFS = digunakan untuk mengosongkan spasi yang terdapat pada awal maupun akhir teks
# read -r domain = digunakan untuk membaca 1 baris domain
# || = perintah OR yang digunakan untuk memilih salah satu yang benar
# [-n "$domain"] = berfungsi untuk memastikan kalau masih ada domain yang mau diproses
while IFS= read -r domain || [ -n "$domain" ]; do
  # xargs = menghapus spasi yang ada didepan maupun dibelakang
  domain="$(echo "$domain" | xargs)" 

  # -z = melanjutkan ke proses berikutnya apabila baris kosong
  [ -z "$domain" ] && continue

  # \# = melanjutkan proses apabila menjumpain komentar
  case "$domain" in \#*) continue ;; esac

  # Mencetak ke dalam layar mengenai domain yang sedang diproses
  log "[*] Processing domain: $domain"

  # Membuat 2 buah file yang digunakan untuk masing-masing proses yang dilakukan

  # Membuat file untuk menampung hasil perintah subfinder
  SF_OUT="$TMPDIR/${domain}_subfinder.txt"

  # Membuat file untuk menampung hasil perintah amass
  AMASS_OUT="$TMPDIR/${domain}_amass.txt"

  # Mejalankan perintah subfinder
  log "    - running subfinder for $domain"
  subfinder -d "$domain" -silent -nW -o "$SF_OUT" || {
    err "subfinder failed for $domain (continuing)"
  }

  # Menjalankan perintah amass
  log "    - running amass (passive) for $domain"
  amass enum -passive -d "$domain" -o "$AMASS_OUT" || {
    err "amass (passive) failed for $domain (continuing)"
  }

  # Menggabungkan hasil pencarian menggunakan perintah subfinder dan amass

  # Melakukan pengecekan apakah file ada hasil dari subfinder
  if [ -f "$SF_OUT" ]; then
    # Jika ada, gabungkan dengan isi ke dalam file ALL_SUBS
    cat "$SF_OUT" | anew "$ALL_SUBS" > /dev/null || true
  fi

  # Melakukan pengecekan apakah file ada hasil dari amss
  if [ -f "$AMASS_OUT" ]; then
    # Jika ada, gabungkan dengan isi ke dalam file ALL_SUBS
    cat "$AMASS_OUT" | anew "$ALL_SUBS" > /dev/null || true
  fi

  # Menampilkan jumlah sub-domain yang didapatkan dari perintah subfinder dan amass
  log "    - combined unique subdomains so far: $(wc -l < "$ALL_SUBS" || echo 0)"

# Mengakhiri perulangan
done < "$INPUT_FILE"

