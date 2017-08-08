// This script takes an image and inverts the colors
// pass the path to the image in the -i flag
// sometimes you want to invert all the interesting colors
// and leave the whites, greys, and blacks alone
// if you want to invert all but the grey colors, type another but 'no' after the -n flag
// run `invert_image -i /path/to/image.png -n yes`
// currently workds on png and jpgs but always outputs a png

package main

import (
	"flag"
	"image"
	_ "image/jpeg"
	"image/png"
	"log"
	"os"
	"strings"
)

func main() {

	// parse arguments
	filename := flag.String("i", "test.png", "path to the image")
	x := flag.Int("x", 0, "x coodinate")
	y := flag.Int("y", 0, "y coodinate")
	w := flag.Int("w", 0, "width")
	h := flag.Int("h", 0, "height")
	flag.Parse()

	// import the image
	inputImage, err := os.Open(*filename)
	if err != nil {
		log.Fatal(err)
	}

	defer inputImage.Close()

	// decode the image
	m, _, err := image.Decode(inputImage)
	if err != nil {
		log.Fatal(err)
	}

	// create new image with size of the cropped image
	newImage := image.NewRGBA(image.Rect(0, 0, *w, *h))

	endYPixel := *y + *w
	endXPixel := *x + *h

	j := 0
	for yOriginalImage := *y; yOriginalImage < endYPixel; yOriginalImage++ {
		i := 0
		for xOriginalImage := *x; xOriginalImage < endXPixel; xOriginalImage++ {
			color := m.At(xOriginalImage, yOriginalImage)
			if xOriginalImage%10 == 0 {
			}
			newImage.Set(i, j, color)
			i += 1
		}
		j += 1
	}

	// figure out a rational name to use for saving
	baseName := strings.Split(*filename, "/")
	baseNameAgain := baseName[len(baseName)-1]
	name := strings.Split(baseNameAgain, ".")
	toSave := name[len(name)-2 : len(name)-1][0]
	toSave = toSave + "_cropped.png"
	fullPath := strings.Join(baseName[:len(baseName)-1], "/") + "/" + toSave

	// save the result to a new image
	outputFile, err := os.Create(fullPath)
	if err != nil {
		log.Fatal(err)
	}

	// write as a png
	png.Encode(outputFile, newImage)

	outputFile.Close()

}
