# Peono

This is a very simple bash tasks runner.

## Usage

```bash
# Create a tasks file
$ cat > .peonotasks.sh <<- EOF
task_hello () {
    echo "Hello world!"
}
EOF

# Show peono usage
$ peono
Usage: peono [list|l|run|r] TASK

# List current directory tasks
$ peono list
hello

# Run "hello" task
$ peono run hello
Running "hello" task (from: /home/toxinu/Code/other/peono/.peonotasks.sh)
#==========> BEGIN
Hello world!
#==========> END
```

## Installation

```bash
curl https://raw.githubusercontent.com/toxinu/peono/master/peono.sh -o ~/.local/bin/peono && chmod +x ~/.local/bin/peono
```

## Configuration

You can edit `$HOME/.config/peono.conf` file.

```bash
$ cat $HOME/.config/peono.conf
TASKS_FILE=".peonotasks.sh"
LOG_LEVEL=1
```

License is WTFPL.
