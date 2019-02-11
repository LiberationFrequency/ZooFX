package main

// Random hex number seed by crypto_rand instead of time

import ( 
    "fmt"
    "flag"
    math_rand "math/rand"
    crypto_rand "crypto/rand"
    "encoding/binary"
)

func main() {
    var b   [8]byte
    var min int
    var max int
    flag.IntVar(&min, "min", 0, "Minimum value in range")
    flag.IntVar(&max, "max", 255, "Maximum value in range")
    flag.Parse()
    _, err := crypto_rand.Read(b[:])
    if err != nil {
        panic("Can not seed math/rand package with cryptographically secure random number generator.")
    }
    math_rand.Seed(int64(binary.LittleEndian.Uint64(b[:])))    
    random := min + math_rand.Intn(max-min+1)
    hex := fmt.Sprintf("%02X", random)
    fmt.Println(hex)
}
