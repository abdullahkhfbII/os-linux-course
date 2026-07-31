# 2. Introduction to Bash Scripting

*Corresponds to: Lab 2*

Now that you can type individual commands, this module teaches you to save
a whole sequence of commands into one file and run them all at once — a
**script**. This is the single most tested skill in this course: every exam
scenario asks you to write one script that solves a multi-step problem.

## 2.1 What is Bash?

**Bash** (Bourne Again SHell) is both:

1. The shell program that reads and runs the commands you type interactively, and
2. A full scripting/programming language you can use to automate tasks.

A **Bash script** is just a plain text file containing a sequence of
commands, saved with a `.sh` extension by convention (the extension itself
is not required for it to work — it's just a naming convention so humans and
editors recognize it).

Why automate with scripts instead of typing commands one at a time?

- **Automation** — repetitive tasks run instantly, without you typing them by hand each time.
- **Consistency** — no risk of forgetting a step or making a typo halfway through.
- **Integration** — scripts can call other programs, other scripts, and be scheduled (see Module 5, cron).

## 2.2 Writing your first script

Create a new file with `nano`:

```bash
nano myfirstbashscript.sh
```

Every Bash script **must start** with this exact line, called the
**shebang**:

```bash
#!/bin/bash
```

- `#!` is a special marker the operating system looks for at the very start
  of a file, called an interpreter directive.
- `/bin/bash` is the absolute path to the Bash program itself.
- Together, this line tells the OS: "run every line below using Bash,
  regardless of what shell the user is currently in."

A minimal script:

```bash
#!/bin/bash
echo "Hello, world!"
```

`echo` prints text to the screen — you already met it in Module 1.

## 2.3 Running your script

```bash
./myfirstbashscript.sh
```

The first time, you'll likely see `Permission denied`. Scripts are just
text files by default — Linux won't execute them until you explicitly mark
them as executable (this is covered properly in Module 3, but the quick fix
is `chmod +x myfirstbashscript.sh`).

> **Note:** you can also run a script with `bash myfirstbashscript.sh`, but
> using `./script.sh` (after making it executable) is the convention you'll
> see throughout this course and in the exam-style answers.

## 2.4 Variables

```bash
name="Yahia"
age=21
echo "$name is $age years old"
```

Critical rules that trip up beginners:

- **No spaces** around the `=` sign. `name = "Yahia"` is an **error** — Bash
  will think `name` is a command it should run, with `=` and `"Yahia"` as
  arguments to it.
- Use `$name` to read the variable's value ("variable expansion").
- Prefer **double quotes** (`"$name"`) when using a variable: they still
  expand the variable, but they also preserve spacing/special characters
  inside the value. **Single quotes** (`'$name'`) do **not** expand
  variables at all — `'$name'` prints the literal text `$name`.

### Where do variables "live"? (Scope)

This is a subtlety the original lab covers but is easy to misread — here it
is laid out plainly:

| How you run the script | Does it start a new process? | Do the variables survive afterward? |
|---|---|---|
| `./script.sh` | Yes | No |
| `bash script.sh` | Yes | No |
| `source script.sh` | No | Yes |

`./script.sh` and `bash script.sh` both launch the script as a **separate,
child process** with its own private memory — once the script ends, its
variables vanish, and they were never visible to your terminal's shell in
the first place. `source script.sh` instead runs the script's commands
*directly inside your current shell*, as if you'd typed them yourself, so
any variables it creates remain available afterward.

```bash
source myfirstbashscript.sh
echo $name        # this WILL show the value, because source didn't spawn a new process
```

## 2.5 Taking input from the user

```bash
#!/bin/bash
echo "What is your name?"
read name
echo "Hello, $name!"
```

`read variable_name` pauses the script, waits for the user to type
something and press Enter, then stores what they typed into that variable.

## 2.6 `if` conditions

```bash
#!/bin/bash
read -p "Enter a number: " number

if [ "$number" -gt 10 ]; then
    echo "Greater than 10"
elif [ "$number" -eq 10 ]; then
    echo "Exactly 10"
else
    echo "Less than 10"
fi
```

Breaking down every piece:

- `if [ condition ]; then` — starts the conditional block. If the condition
  is true, the block underneath runs.
- `[ ... ]` is actually a command called `test` in disguise (see the
  Prerequisites module). **Spaces are mandatory** around the brackets:
  `[ $number -gt 10 ]` is correct, `[$number -gt 10]` is a syntax error.
- `;` separates two commands written on the same line (here, the `if [...]`
  test and the `then` that follows). A space after the `;` is required.
- `elif` = "else if" — checked only if the previous condition was false.
- `else` = runs if nothing above matched.
- `fi` = closes the `if` block (it's literally "if" spelled backwards —
  Bash does this for every block keyword: `if`/`fi`, `case`/`esac`).

### Comparing strings vs. numbers

Bash has **completely different operators** for comparing text versus
numbers — mixing them up is one of the most common beginner mistakes.

**String comparison:**

```bash
[ "$str1" = "$str2" ]     # equal
[ "$str1" != "$str2" ]    # not equal
[ -z "$str" ]             # true if string is EMPTY
[ -n "$str" ]             # true if string is NOT empty
```

**Numeric comparison (integers only):**

```bash
[ "$num1" -eq "$num2" ]   # equal to
[ "$num1" -ne "$num2" ]   # not equal to
[ "$num1" -gt "$num2" ]   # greater than
[ "$num1" -lt "$num2" ]   # less than
[ "$num1" -ge "$num2" ]   # greater than or equal to
[ "$num1" -le "$num2" ]   # less than or equal to
```

> **⚠ Important limitation:** `-eq`, `-gt`, etc. only work correctly on
> **whole numbers (integers)**. A grade like `85.5` will cause an error if
> you try `[ "$grade" -ge 85 ]` directly.

### Comparing floating-point (decimal) numbers

Bash's built-in `[ ]` test cannot do decimal math at all. The workaround
used throughout the labs is the external calculator program `bc`:

```bash
result=$(echo "$grade >= 85" | bc -l)
if (( result == 1 )); then
    echo "Excellent"
fi
```

- `echo "$grade >= 85"` builds a math expression as plain text.
- `| bc -l` pipes that text into `bc`, a command-line calculator, which
  evaluates it and prints `1` (true) or `0` (false).
- `$( ... )` is **command substitution** — it captures whatever a command
  prints and lets you store it in a variable.
- `(( ... ))` is **arithmetic evaluation** — used for math with numbers,
  as opposed to `[ ... ]` which is used for general conditions/tests.

## 2.7 Loops

### `for` loop over a fixed list

```bash
for item in "apple" "banana" "cherry"; do
    echo "Fruit: $item"
done
```

- `item` is the loop variable — on each pass ("iteration") it takes the next
  value from the list.
- `in "apple" "banana" "cherry"` is the list being iterated over — three
  quoted items means three iterations.
- `do` begins the loop's body; `done` closes it (again, note there's no
  clever backwards spelling here, just a plain keyword).

### `for` loop over a number range

```bash
for i in {1..5}; do
    echo "Number: $i"
done
```

`{1..5}` is **brace expansion** — Bash automatically turns it into
`1 2 3 4 5` before running the loop.

### `for` loop over files (glob patterns)

```bash
for file in *.txt; do
    echo "Found file: $file"
done
```

`*.txt` is a **glob pattern** — Bash expands it to match every file ending
in `.txt` in the current directory *before* the loop even starts, so this
is really equivalent to typing out every matching filename explicitly.

### `while` loop

```bash
count=1
while [ "$count" -le 5 ]; do
    echo "Count is $count"
    count=$((count + 1))
done
```

`while` repeats its body **as long as** the condition stays true — unlike
`for`, which iterates over a known list, `while` is **condition-controlled**
and can, in principle, run forever if the condition never becomes false.
`count=$((count + 1))` uses `(( ))` arithmetic to increment the counter
(equivalent to `count++` in other languages, and Bash does also support
`((count++))` directly).

### `until` loop

```bash
count=1
until [ "$count" -gt 5 ]; do
    echo "Count is $count"
    count=$((count + 1))
done
```

`until` is the mirror image of `while`: it keeps running **until** the
condition becomes true (i.e., it runs while the condition is *false*).

> **Quick reference:** `[ ]` square brackets are for conditions/tests.
> `(( ))` double parentheses are for arithmetic (math).

## 2.8 Arrays

```bash
courses=("Math" "Physics" "Chemistry")

echo "${courses[0]}"      # first element -> Math (indexing starts at 0!)
echo "${courses[1]}"      # second element -> Physics
echo "${courses[@]}"      # ALL elements
echo "${#courses[@]}"     # the NUMBER of elements -> 3
```

- Parentheses `()` define the array; elements are separated by spaces (use
  quotes for any element containing spaces of its own).
- Array indexing starts at **0**, not 1.
- `${ }` curly braces are required whenever you access an array element or
  its properties — `$courses[0]` (without braces) does **not** work as
  expected.
- `@` inside `${courses[@]}` expands to every element.
- `#` before the array name (`${#courses[@]}`) returns the count of elements.

## 2.9 Try it yourself

Work through
[`scenarios/scenario_1_grade_evaluator.sh`](scenarios/scenario_1_grade_evaluator.sh)
and
[`scenarios/scenario_2_password_checker.sh`](scenarios/scenario_2_password_checker.sh)
on your own first. See [`examples/`](examples/) for every concept above
demonstrated as its own runnable file.

Next: [`03-users-groups-permissions/README.md`](../03-users-groups-permissions/README.md)
