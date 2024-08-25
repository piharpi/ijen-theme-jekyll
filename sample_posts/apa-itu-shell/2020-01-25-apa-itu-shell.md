---
title: What is a shell? 🐚 adalah kerang ajaib?
date: 2020-01-25 11:58:47 +07:00
modified: 2020-02-02 16:49:47 +07:00
tags: [unix/linux, cli]
description: Shell adalah sebuah command-line interpreter; program yang berperan sebagai penerjemah perintah yang diinputkan oleh User yang melalui terminal, sehingga perintah tersebut bisa dimengerti oleh si Kernel.
image: "/apa-itu-shell/shell_evolution.png"
---

<a href="http://www.youtube.com/watch?v=tc4ROCJYbm0&t=70" target="_blank" rel="noopener">Dulu</a> Sebelum adanya <abbr title="Graphical User Interface">GUI</abbr> cara user berinteraksi dengan komputer menggunakan <abbr title="Command Line Interface">CLI</abbr> yaitu mengetik baris perintah pada sebuah antarmuka dalam bentuk baris teks seperti 👇.

<figure>
<img src="/apa-itu-shell/terminal_nginx.gif" alt="installing nginx in ubuntu">
<figcaption>Fig 1. Terminal emulator, instalasi package dan check service.</figcaption>
</figure>

Jika kamu pernah menggunakan unix/linux mungkin pernah menggunakan program diatas, bahkan mungkin setiap hari menggunakannya untuk mengeksekusi suatu perintah melalui <a href="http://en.wikipedia.org/wiki/List_of_terminal_emulators" target="_blank" rel="noopener">terminal emulator</a>.

User<sup id="user">[[1]](#user-ref)</sup> tidak bisa secara langsung berkomunikasi dengan sebuah hardware komputer, maka dari itu kita membutuhkan sebuah sistem operasi; **Kernel** adalah program yang merupakan inti utama dari sistem operasi komputer.

<figure>
<img src="/apa-itu-shell/kernel.png" alt="kernel central of operating system">
<figcaption>Fig 2. bagan kernel.</figcaption>
</figure>

Kernel memfasilitasi interaksi antara komponen perangkat keras dan perangkat lunak, berperan untuk menangani permintaan input/ouput dari perangkat lunak, selanjutnya menerjemahkannya ke dalam pemrosesan data untuk diintruksikan ke CPU, sehingga Hardware(cpu, memory, devices) mengerti perintah yang dimaksud dari pengguna.

Ketika kita menginputkan suatu perintah pada terminal emulator, kernel tidak langsung mengerti perintah yang kita ketik, kita membutuhkan suatu interface sebagai perantara menuju kernel yaitu **Shell**.

<figure>
<img src="/apa-itu-shell/shell.png" alt="shell">
<figcaption>Fig 3. bagan komunikasi shell.</figcaption>
</figure>

<mark>Shell adalah sebuah command-line interpreter; program yang berperan sebagai penerjemah perintah yang diinputkan oleh User yang melalui terminal</mark>, sehingga perintah tersebut bisa dimengerti oleh si Kernel.

Login shell biasanya ditetapkan oleh local System Administrator ketika pada saat pertama user kamu dibuat, kamu bisa lihat login shell yang sedang kamu gunakan dengan perintah dibawah ini.

```bash
$ echo $SHELL
# atau
$ echo $0
```

Setiap shell mempunyai default prompt. beberapa shell yang paling umum:

```bash
$ (dollar sign)   # sh, ksh, bash
% (percent sign)  # csh, tcsh
```

##### Terminologi pada shell prompt

Shell prompt adalah tempat dimana kita menuliskan suatu perintah, berikut adalah terminologinya ini membantu, jika kamu ingin mengetahui bagian-bagianya.

<figure>
<img src="/apa-itu-shell/term_shell_prompt.png" alt="shell">
<figcaption>Fig 4. bagian-bagin dari shell prompt.</figcaption>
</figure>

Dibawah ini salah satu contoh perintah sederhana untuk menampilkan sebuah arsitektur CPU komputer yang sedang saya gunakan.

<figure>
<img src="/apa-itu-shell/terminal_lscpu.gif" alt="installing nginx in ubuntu">
<figcaption>Fig 5. menampilkan informasi tentang arsitektur CPU.</figcaption>
</figure>

Dari perintah yang contohkan, ketika user mengetikan suatu inputan perintah di terminal dan menekan <kbd>ENTER</kbd>, maka shell akan mengubah perintah user menjadi bahasa yang bisa dipahami oleh kernel, dan Kernel menerjemahkannya ke dalam pemrosesan data untuk diintruksikan ke Hardware sehingga menghasilkan output yg sesuai dengan perintah user.

Shell mempunyai beberapa macam dan turunan, berikut yang paling umum.

<figure>
<img src="/apa-itu-shell/shell_evolution.png" alt="shell evolution">
<figcaption>Fig 6. evaluasi shell dari tahun ke tahun.</figcaption>
</figure>

Sedikit penjelasan dari gambar diatas.

- Bourne shell `sh`
  Dikembangkan oleh Stephen Bourne di Bell Labs, yang kala itu sebagai pengganti Thompson shell(diciptakan Ken Thompson), banyak sistem unix-like tetap memiliki `/bin/sh`—yang mana menjadi symbolic link atau hard link, bahkan ketika shell lain yang digunakan tetap `sh` adalah sebagai dasarnya, sebagai kompatibilitas perintah.
- Korn shell `ksh` Unix shell yang dikembangkan oleh David Korn di Bell Labs,
  inisialiasi pengembangan ini berdasar pada source code Bourne shell, namun juga memiliki fitur `csh` dan `sh`, pengembanganya pun pada saat saya menulis ini pun terus <a href="http://github.com/att/ast" target="_blank" rel="noopener">terawat</a>.
- Bourne again shell `bash`
  adalah proyek ini open source <a href="http://gnu.org/software/bash/" target="_blank" rel="noopener">GNU project</a> memilki kompatibel dengan `sh` yang menggabungkan fitur penting dari `ksh` dan `csh`, dan menjadi salah satu shell yang paling umum digunakan (umumnya menjadi default shell login Linux dan Apple's macOS Mojave).
- Z shell `zsh` ini mempunyai wadah komunitasnya disebutnya <a href="http://ohmyz.sh/"  target="_blank" rel="noopener">"Oh My Zsh"</a>, plug-in dan theme `zsh` bisa kita temukan di komunitas ini, saya saat ini menggunakan `zsh`, shell ini juga menjadi default dari sistem operasi macOS Catalina, yang menggantikan bash.
- friendly interactive shell `fish`
  yah sesuai dengan <a href="http://fishshell.com/" target="_blank" rel="noopener">deskripsi</a> di web nya, menurut saya shell ini fun banget, fitur yang saya sukai dari shell ini autosuggestions, dan konfigurasi yang mudah melalui web based.

Masih banyak yang belum dijelaskan pada tulisan ini jika masih tertarik, baca lebih <a href="http://en.wikipedia.org/wiki/List_of_command-line_interpreters#Operating_system_shells" target="_blank" rel="noopener">banyak</a> dan juga <a href="http://en.wikipedia.org/wiki/Comparison_of_command_shells" target="_blank" rel="noopener">komparasinya</a> masing-masing shell.

Jika kamu tertarik untuk mengubah default shell login pada sistem operasi, kamu bisa menginstall dengan cara mengikuti didokumentasi/cara penginstallan dimasing-masing shell disini saya tidak membahas karena distro yang kita pakai mungkin berbeda-beda.

Untuk menjadikan default shell login pada OS bisa menggunakan perintah ini.

```bash
# command
$ sudo chsh [options] [LOGIN]

# contoh penggunaan
$ sudo chsh -s /user/bin/zsh harpi
# mengubah default shell user harpi menjadi zsh shell.
$ reboot

# atau kamu juga bisa mengubah file /etc/passwd dan edit secara manual user shellnya.
# jika masih bingung manfaatkan perintah man untuk melihat manual page.
$ man chsh
```

Terakhir untuk tulisan ini, shell memilki berbagai macam, pilihlah shell yang sesuai dengan keinginanmu untuk menunjang produktivitas dan sesuaikan dengan kebutuhan, terlalu banyak plugin dan kebingungan memilih tema itu buruk 😁.

Terimakasih sudah baca, _penulis menerima kritik dan saran._

##### Notes

<small id="user-ref"><sup>[[1]](#user)</sup> Manusia yang mengoperasikan dan mengendalikan sistem komputer.</small>

##### Resources

- [Evolution shells in Linux](http://developer.ibm.com/tutorials/l-linux-shells/)
- [Kernel Defintion](http://www.linfo.org/kernel.html)
- [The Shell](http://www.cis.rit.edu/class/simg211/unixintro/Shell.html)
