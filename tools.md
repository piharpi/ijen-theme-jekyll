---
title: Tools I use, like, and appreciate
permalink: /tools/
layout: page
excerpt: Overview of the tools that help me do my job
comments: false
---

#### Ultrawide Monitor

Finally being able to have 2 windows open side-by-side with no compromises has been a great benefit to my productivity. Previously even with large 16:10 monitors I found that the windows were just a little too narrow when side-by-side. 

```bash
rails db:system:change --to=<adapter>
# <adapter> : postgresql, mysql, sqlite3, oracle, sqlserver, dll...
```

Setelah menjalankan perintah diatas, jangan lupa untuk mengubah versi database adapter di `Gemfile`.

---

#### Ergodox EZ

A fully programmable keyboard helps me type faster, with less wrist strain.

```go
response, err := http.Get("https://link-ip.nextdns.io/9f324d/766bdabf400e6b1d") // without the thing we go to
	if err != nil {
		fmt.Println(err.Error())
	} else {
		bytes, err := ioutil.ReadAll(response.Body)
		if err != nil {
			fmt.Println(err.Error())
		} else {
			value := string(bytes)
			fmt.Println("ip:", value)
		}
	}
```

Dan lain waktu, gunakan <kbd>CTRL</kbd> + <kbd>C</kbd> untuk menghentikan server.
