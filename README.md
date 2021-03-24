# Hello Go
I was starting to learn Golang and I stumbled at the very first hurdle, writing *Hello World*. 

Now it is easy to write hello world, you create a go file like this:
```
package main

import "fmt"

func main() {
	fmt.Println("Hello, world.")
}
```

and then run something like:
```
go run hello.go
```

and that's great but then I thought how can I put this in a docker container and then I got `go: cannot find main module` so I needed to find out about workspaces versus modules. After some research I figured it out and I wanted to share for all the other beginner Gophers out there.

## How to run Golang Hello World in Docker
The first step is the same as above, create a hello.go file and put in the code:
```
package main

import "fmt"

func main() {
	fmt.Println("Hello, world.")
}
```

Now, a lot of tutorials start talking about workspaces at this point, but `starting in Go 1.13, module mode will be the default for all development.` 
[blog.golang.org/using-go-modules](https://blog.golang.org/using-go-modules)

So if you are starting in Go you can ignore all that workspace stuff.

The first step to create your module is to run:
```
go mod init <module name>
```
Where `<module name>` can be anything you want (it is not related to the filepath which I thought at first).

Now you can run `go install` and if your environment is setup correctly you can run hello and get hello world output to the terminal.

But we want to do it in docker and for this we will use a [multistage](https://docs.docker.com/develop/develop-images/multistage-build/) docker build.

One of Go's advantages over other languages like Python or Java is that it compiles to a small binary executable which means the docker image you run it in can be very small, in this case ~2Mb. With two stage build you can do both the compiling and container creation in one Dockerfile like this:
```
# STEP 1 build executable binary

FROM golang:1.16 AS builder

WORKDIR $GOPATH/src/mypackage/myapp/
COPY . .
# Build the binary.
RUN go build -o /go/bin/hello

# STEP 2 build a small image

FROM scratch
# Copy our static executable.
COPY --from=builder /go/bin/hello /go/bin/hello
# Run the hello binary.
CMD ["/go/bin/hello"]
```

Then just run docker build and run and you get *Hello World*

```
docker build -t hellogo .
docker run hellogo
```
Here endeth the lesson.

Any questions or comments feel free to reach out to me at  [vfxger.com](https://https://www.vfxger.com/).
