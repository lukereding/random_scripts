package main

import (
	"fmt"
	"os"
	"os/exec"
	"strings"

	"github.com/gen2brain/dlgs"
)

// for use by Mary's FRI kids to take videos with ffmpeg
// without having to interact with the command line

func runFFMPEG(e experimentData) {
	var (
		cmdOut []byte
		err    error
	)

	// // define a map that stores the possible experiment types and times in seconds
	// m := make(map[string]string)
	// m["sociality"] = "600"   // two parts
	// m["mate choice"] = "900" // two parts
	// m["scototaxis"] = "1200"
	// m["detour"] = "600"
	// m["complex maze"] = "600"
	// m["color discrimination"] = "600"

	// time := m[experiment]

	fmt.Println("Will record for " + e.timeSeconds + " seconds.")

	cmdName := "ffmpeg"
	cmdArgs := []string{"-f", "avfoundation", "-i", "1", "-r", "10", "-t", e.timeSeconds, "-y", e.makeVideoName()}
	if cmdOut, err = exec.Command(cmdName, cmdArgs...).Output(); err != nil {
		fmt.Fprintln(os.Stderr, "There was problem running ffmpeg: ", err)
		os.Exit(1)
	}
	sha := string(cmdOut)
	fmt.Println(sha)
	fmt.Println("done taking video")
}

type experimentData struct {
	experimentType string
	userName       string
	fishName       string
	timeSeconds    string
	species        string
	part           string
	folderPath     string
	half           string
}

// define a method that builds the name of the video from the experimentData
func (x *experimentData) makeVideoName() string {
	temp := fmt.Sprintf("%s/%s,%s,%s,%s,%s.mp4", x.folderPath, x.experimentType, x.species, x.fishName, x.part, x.userName)
	return strings.Join(strings.Fields(temp), "")
}

func main() {

	m := make(map[string]string)
	m["sociality"] = "600"   // two parts
	m["mate choice"] = "900" // two parts
	m["scototaxis"] = "1200"
	m["detour"] = "600"
	m["complex maze"] = "600"
	m["color discrimination"] = "600"

	experimentsWithHalves := map[string]bool{
		"mate choice": true,
		"sociality":   true,
	}

	folderPath, _, err := dlgs.File("Select the folder where you want to save the video", "", true)
	if err != nil {
		panic(err)
	}

	fmt.Println(folderPath)

	experimentType, _, err := dlgs.List("What's up homie?!",
		"What type of experiment are you doing?",
		[]string{"sociality", "mate choice", "scototaxis", "detour", "complex maze", "color discrimination"})

	if err != nil {
		panic(err)
	}

	fishName, _, err := dlgs.Entry("fish name", "The name or ID of the fish: ", "NA")
	if err != nil {
		panic(err)
	}

	userName, _, err := dlgs.Entry("your name", "Your name: ", "NA")
	if err != nil {
		panic(err)
	}

	species, _, err := dlgs.List("species",
		"What species are you testing?",
		[]string{"P. reticulata", "G. affinis", "G. vittatta", "X. nigrensis", "X. variatus", "L. perugiae"})

	part := "NA"
	if experimentsWithHalves[experimentType] {
		part, _, err = dlgs.List("part",
			"If this is a two-part assay, which part is this?",
			[]string{"part1", "part2"})
	}

	if err != nil {
		panic(err)
	}

	// define the struct that defines the metadata of the experiment
	experiment := experimentData{experimentType: experimentType, fishName: fishName, userName: userName, timeSeconds: m[experimentType], species: species, part: part, folderPath: folderPath, half: part}

	// make sure the user entered in everthing as they expected
	text := fmt.Sprintf("To summarise: \n\nyour name: %s\nfish name: %s\nexperiment type: %s\nspecies: %s\nhalf: %s\n\nfilename: %s\n\nSelect 'yes' to start recording!", experiment.userName, experiment.fishName, experiment.experimentType, experiment.species, experiment.half, experiment.makeVideoName())
	userProblem, err := dlgs.Question("last chance", text, true)
	if err != nil {
		panic(err)
	}

	if userProblem == false {
		fmt.Println("user identified a problem with the inputs. Exiting.\n\n")
		os.Exit(2)
	}

	fmt.Println(experiment.makeVideoName())

	runFFMPEG(experiment)

}
