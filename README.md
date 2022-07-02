# Some build experiments for AppImages

### Scratchpad

Building `hello-rs`

```sh
cd recipe;
docker compose up --force-recreate --build rusty-hello-rs
docker compose up --force-recreate --build appimg-hello-rs-build
```

Regenerate config (interactive)
```sh
cd recipe;
docker compose up --force-recreate --build rusty-hello-rs
docker compose build appimg-hello-rs && docker compose run --rm appimg-hello-rs
```
