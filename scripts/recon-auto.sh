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
