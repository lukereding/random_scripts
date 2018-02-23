package main

import "fmt"
import "os"
import "os/exec"
import "github.com/gen2brain/dlgs"

// for use by Mary's FRI kids to take videos with ffmpeg
// without having to interact with the command line

func runFFMPEG( experiment, name string) {
	var (
		cmdOut []byte
		err    error
	)

	 m := make(map[string]string)
	 m["Sociality"] = "2"
	 m["maze"] = "4"

	 time := m[experiment]

	 fmt.Println("Will record for: " + time)

	 name = name + ".mp4"

	cmdName := "ffmpeg"
	cmdArgs := []string{"-f", "avfoundation", "-i", "1", "-r", "10", "-t", time, "-y", name}
	if cmdOut, err = exec.Command(cmdName, cmdArgs...).Output(); err != nil {
		fmt.Fprintln(os.Stderr, "There was an error running git rev-parse command: ", err)
		os.Exit(1)
	}
	sha := string(cmdOut)
	fmt.Println(sha)
	fmt.Println("done taking video")
}

func main() {
	item, _, err := dlgs.List("What's up homie?!",
		"What type of experiment are you doing?",
		[]string{"Sociality"})

	if err != nil {
	    panic(err)
	}

	fmt.Println(item)

	fishName, _, err := dlgs.Entry("fish name", "Enter the fish name here: ", "NA")
if err != nil {
    panic(err)
}

	runFFMPEG(item, fishName)



}
