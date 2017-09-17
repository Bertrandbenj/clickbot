# clickbot
Clickbot for elvenar on linux 
[the script](https://github.com/Bertrandbenj/clickbot/blob/master/elvenar/clickbot.pl) fragment the steps to automate clicks on the browser and farm on elvenar


## Pre-requisite
Have Perl installed with switch library as well as xmacro
all available on Ubuntu repos
```
sudo apt-get install perl libswitch-perl xmacro
```

## Usage 
- Record a macro file for each category of building. this records the position of each building. execute the macro, click & escape (safe click) on each building.
```
xmacrorec2 > openpage 
xmacrorec2 > atelier 
xmacrorec2 > manufacture 
xmacrorec2 > caserne 
xmacrorec2 > popul
xmacrorec2 > closepage 
``` 

- use the script ./clickbot [atelier 1-6] [manufacture time] [caserne 1-5]
```
./clickbot.pl 3 0 2
```


