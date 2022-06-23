#!/bin/sh
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
rustup target add riscv64gc-unknown-linux-gnu
rustup target add riscv64gc-unknown-none-elf
