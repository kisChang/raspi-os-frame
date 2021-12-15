use std::fs;

fn main() {
    fs::write("/tmp/hw.txt", "FROM RUST PROGRAM, Hello, world!")
        .unwrap();
}