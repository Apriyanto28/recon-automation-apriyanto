#!/bin/bash

# cara penggunaan perintah: 
# - Terlebih dahulu jadikan file script-auto.sh menjadi script yang bisa dijalankan
# dengan perinth: chmod +x script-auto.sh
# - Jalan script ini dengan perintah ./script-auto.sh [daftar domain yang mau di-recon


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
