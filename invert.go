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
	"fmt"
	"image"
	"image/color"
	"image/png"
	"math"
	"os"
	"path/filepath"
)

// flips a value around 128 to get the 'inverse' color
func invert(x uint32) uint8 {
	absoluteVal := int(math.Abs((float64(x)) - 128))

	y := int(x)

	var result int

	if y < 128 {
		result = 128 + absoluteVal - 1
	} else if x > 128 {
		result = 128 - absoluteVal - 1
	} else {
		result = 128
	}

	resultU := uint8(result)

	return resultU
}

func main() {

	// parse arguments
	filename := flag.String("i", "test.png", "path to the image")
	invertGray := flag.String("invert_grey", "yes", "do you only want to invert grey pixels?")
	invertNonGrey := flag.String("invert_color", "yes", "do you only want invert non-grey pixels?")
	flag.Parse()

	// only_grey := *nonGrayOnly

	// import the image
	inputImage, err := os.Open(*filename)
	if err != nil {
		fmt.Println("could not open", *filename)
		os.Exit(1)
	}

	defer inputImage.Close()

	// decode the image
	m, _, err := image.Decode(inputImage)
	if err != nil {
		os.Exit(2)
	}

	// get the size of image the image
	// note that m.Bounds().X is not guarenteed to be zero for some reason
	bounds := m.Bounds().Size()

	// create new image with same bounds
	newImage := image.NewRGBA(image.Rect(0, 0, bounds.X, bounds.Y))

	// looping over all pixels
	for y := 0; y <= bounds.Y; y++ {
		for x := 0; x <= bounds.X; x++ {
			r, g, b, a := m.At(x, y).RGBA()

			// figure out whether to invert the pixel
			var isGray, invertPixel bool
			isGray = r == g && g == b

			// figure out whether to invert the pixel
			// if is gray and onlyGrey, true
			// if is not gray and notGreyOnly, true
			if (isGray && (*invertGray == "yes")) || (!isGray && (*invertNonGrey == "yes")) {
				invertPixel = true
			} else {
				invertPixel = false
			}
			// fmt.Println("invert_pixel: ", invertPixel)

			// if the user only wants to invert non-grey colors,
			// and the pixel is grey, don't invert the color
			if !invertPixel {
				/// don't change the color
				newImage.Set(x, y, color.RGBA{uint8(r), uint8(g), uint8(b), uint8(a)})
			} else {
				rNew, gNew, bNew := invert(r), invert(g), invert(b)

				// define the new color
				color := color.RGBA{
					rNew,
					gNew,
					bNew,
					uint8(a),
				}

				// create the pixel in the new image
				newImage.Set(x, y, color)
			} // end else
		} // end x for
	} // end y for

	// save the result to a new image

	// find basename
	fileBasename := filepath.Base(*filename)
	// strip extension
	fileExtention := filepath.Ext(*filename)
	outputFileName := fileBasename + "_inverted" + fileExtention

	fmt.Println(outputFileName)

	outputFile, err := os.Create(outputFileName)
	if err != nil {
		panic(err.Error())
	}
	defer outputFile.Close()

	png.Encode(outputFile, newImage)

}
