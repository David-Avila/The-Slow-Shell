# The Slow Shell (DSS)
DSS is a small custom shell for MiniMicro.

# NOTE:
This projects is **WIP**. Expect bugs

# How to install
Just copy and paste this line into MiniMicro's terminal

```
f=file.open("_temp.ms","w+");f.write(http.get("https://github.com/David-Avila/The-Slow-Shell/raw/refs/heads/main/installer.ms"));f.close;load"_temp";run;delete"_temp.ms"
```

# Shell documentation
`preset` allows you to see and change the default terminal theme.


`!` gives you acces to the files in buffer. To add a file to the buffer just open it in the editor. Then type `!` + the file name, or just the first couple of letters.


`chuser` allows you to change the username shown in the terminal. See 'Custom keywords' for more information.


The `update` is used to grab the latest version of DSS from github.


# Shell customization
The config file is placed in `/usr/.config/dss_conf.ms`, the default file should look like this:

```
custom = {}
custom.user = "user"
custom.newLine = "1"
custom.prompt = "%#55ee55$->%"
custom.defaultConfigFile = "/usr/.config/dss_conf.ms"
custom.configFile = "/usr/.config/dss_conf.ms"
```

`custom.newLine` controls whether or not to add a new empty line before printing the prompt, so it's easier to read. Set it to `"0"` to disable it.

DSS allows you to customize your terminal prompt with colors, strings and a couple of built-in keywords. Edit `custom.prompt` to change the look of your terminal.

## Undestanding the formatter
To print stuff with a custom color, write a `%` sign followed by the color in hex code, then your text, then close the block with another `%` to avoid writing everything with that color

An example:
```
custom.prompt = "%#ffffff Hello DSS %"
```

This code will write " Hello DSS " in white. Try changing the hex code and see how the prompt behaves.

If you want to use multiple lines (like presets 1 and 2), you can add `\n` to the string to add a new line.

## Keywords
You can use a couple of keywords to make the terminal more dynamic. They are used with the `%{KEYWORDS}` sintax.

For instance:
```
custom.prompt = "%{PWD} $>"
```
That code will print your current working directoy followed by `$>`, it would look something like:

`/usr/cool_project/ $>`


**Current available keywords**:
`USER`: Displays the username

`PWD` : Displays current working directory

`DATE`: Displays current date in format "dd-MM", i.e: "28-10" for October 28th.

`TIME`: Displays the current time in format "HH:mm", i.e: "11:06"


If you mess up the prompt, just type `preset` + a number between 1 and 3 to reload the prompt to one of the defaults.
