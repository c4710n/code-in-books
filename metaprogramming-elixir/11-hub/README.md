# Hub

- At compile-time, `Hub` caches GitHub data directly within function definitions.
- At runtime, `Hub` provides a function `go/1` to open corresponding link in browser (macOS only).

## Setup

```sh
$ mix deps.get
```

## Play

```sh
$ iex -S mix

iex> Hub.

iex> Hub.go(:"code-in-books")
```
