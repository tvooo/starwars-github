starwars-github
===============

A physical notifier for things that happen in your Github repository. Star Wars themed.

> May the fork be with you.

## Features

It plays sounds via a connected computer and rotates a spinning wheel to indicate what happened. The following events are supported:

* New issue
* Issue resolved
* Comment
* New commits
* New stargazers
* Fork

## Setup

### Arduino

Stuff needed:

* Arduino Uno R3 (any other will also do, I guess)
* Servo motor that can rotate 180°
* A piece of round cardboard with Star Wars illustrations

Instructions:

1. Mount cardboard to the servo motor
2. Connect servo motor to Arduino (the servo pin, which is #9 in our example, has to be a PWM pin!)
3. Load the Arduino program onto your board

### Processing

Instructions:

1. Put your Github username/password as well as the details of the repository you want to watch in `Config.pde`.
2. Check the correct Serial port number, and correct it as needed
3. Run the program and watch the magic happen!

## License

What? License? Do whatever you want :)
