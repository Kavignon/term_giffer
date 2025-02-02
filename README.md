# TermGiffer 🖥️➡️🎥

## Overview
🎥 Record. Convert. Share. With TermGiffer.

Record your terminal and generate GIFs effortlessly, all within a Docker container. No dependencies—just record and share!

TermGiffer leverages both [asciinema](https://asciinema.org) and [agg](https://github.com/asciinema/agg).

> Its typical use cases include creating tutorials, demonstrating command-line tools, and sharing reproducible bug reports. It focuses on simplicity and interoperability, which makes it a popular choice among computer users working with the command-line, such as developers or system administrators.

> agg is a command-line tool for generating animated GIF files from terminal session recordings.


## Default behavior
1. The terminal session is captured by asciinema.
2. The terminal session is converted into a gif by agg.
3. TermGiffer will save the gif in your working directory.


## 🛠️ Installation

You don't need to install anything on your machine!

## 🎬 Usage

Run it in a container:

```sh
docker run --rm -v $(pwd):/output term_giffer record my-session
```

🎛️ Configuration Options

| Flag | Description |  Default | 
|----------|----------|----------|
| --speed  | Playback speed multiplier   |  1x   |
| --font-size | Font size in pixels  | 20   |
| --output| 	Specify output directory |  Current working directory   |
