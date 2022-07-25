# Orwell

This project requires Elixir.

## How to install Elixir on Ubuntu.

```
$ apt install elixir
```

## How to get repo

```
git clone https://github.com/supertrevlig/orwell.git
```

## How to build


```
$ cd orwell
$ mix deps.get
$ mix compile
$ mix escript.build
```

## How to run

Add pixel <img> tag to your page. Do not forget to update the src attribute if
needed.

If this is to much see "tools" below for simple (python) http-server script and 
files.

```
<img src="http://localhost:4001/pixel.gif" referrerpolicy="unsafe-url"/>
```

Start server.

```
$ cd orwell
$ LOG_FILE=/tmp/orwell.log PORT=4001 mix run --no-halt
```
Ctrl-C Ctrl-C to stop server. 

Log-file will be created when server starts.

To use the CLI

```
$ ./orwell --from='2022-07-20T00:00:00Z' --to='2022-07-30T00:00:00Z' --log-file=/tmp/orwell.log
```

## Tools (can be ignored)

Run http-server with static files (wrapper around python3) that serves
some static html files with the the tracking pixel (hard-coded to localhost:4001).

```
$ cd orwell/tools/http
$ ./http-server files/
```

Combo:

```
$ # first terminal
$ LOG_FILE=/tmp/orwell.log PORT=4001 mix run --no-halt

$ # second terminal
$ tail -f /tmp/orwell.log

$ # third terminal
$ cd orwell/tools/http
$ ./http-server files/
```

open browser: http://localhost:5001/index.html

