# a beginner's guide to Docker

_quick note: the best guide to Docker I've found is [here](http://odewahn.github.io/docker-jumpstart/introduction.html). The tutorial at the Docker website seems like it's good, but I didn't really understand anything until reading the above tutorial._

## what is docker and why you would use it

Docker is a tool you use to develop and share your software with others. Using Docker, you get your code working on a very basic Linux operating system, downloading all the packages and libraries you need to have your code run to this basic operating system. You can upload your image--your software--to the internet where others can download your stripped-down, bare-bones operating system with all the code need to run your program.

Why use Docker? __compatibility__ If you've used a lot of software, you've probably run into compatibility issues: two pieces of software not playing nice, or giving you an error because version 2.3 of one piece of software is incompatible with version 0.1.11 of some other software. This is common when downloading code from Github, for example. Docker solves this problem by shipping you not only the base code, but also all the libraries and dependencies your code needs in order to run, and a simple operating system. __reproducability__ When someone takes your code to repeat some analysis you do, they run it on their computer with their version of R or Python or C++. In order for something to be totally reproducable, it should be run exactly the same way, with all the same versions of software. Docker ensures this is the case. __sharing__ Docker makes it easy to share code because you can get your code working in a Docker container, post it online, and anyone (running Windows, Mac, or Linux) can use Docker to run your code just like you can.

### some quick vocab:

From the Docker website:
> A _container_ is a stripped-to-basics version of a Linux operating system. An _image_ is software you load into a container. Images come in _layers_ representing the state of the code through time.

These terms are really important to the discussion below. 

## example of docker usage



## some basic docker commands

`docker stat`

`docker images`

`docker ps` and `docker ps -a`