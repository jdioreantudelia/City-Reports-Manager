# City Reports Manager

A command-line application for managing city inspection reports, developed in C for Linux as a university Operating Systems project.

The project demonstrates Linux and operating systems concepts, including process management, inter-process communication, signal handling, file permissions and low-level file I/O.

## Features

- **Districts:** each district is a directory containing `reports.dat`, `district.cfg` and `logged_district`, plus a symlink `active_reports-<district>`.
- **Role-based permissions:** Supports two roles: `manager` (user permissions) and `inspector` (group permissions).
- **Binary report storage:** reports are stored as binary `REPORT` structures with sequential IDs.
- **Dynamic filtering:** by severity, category, inspector, and timestamp, using the operators `==`, `!=`, `<`, `<=`, `>`, and `>=`.
- **Signal-based monitoring:** A separate monitor process receives `SIGUSR1` through `sigaction()`. Its output is forwarded to the hub through a pipe.
- **Parallel score computation:** The hub creates one scorer process per district using `fork()` and collects their results through pipes.
- **Input validation:** District names are validated against an allowed character set. Category and severity are validated when adding a report.


## Build

Requires Linux (or WSL), `gcc` and `make`.

Compile all executables:

```bash
make # builds city_manager, city_hub, monitor_reports, scorer
```

Remove generated executables and runtime files:

```bash
make clean
```

The build produces four executables:

- `city_manager`
- `city_hub`
- `monitor_reports`
- `scorer`

**Important:** Keep these executable names unchanged because the hub launches `./monitor_reports` and `./scorer`.

## Usage

Run all commands from the project directory. The monitor stores its process ID in `.monitor_pid`.
District names may contain letters, digits, `_` and `-`.

### 1. Start the hub

Open the first terminal:

```bash
./city_hub
```

Available hub commands:

```text
city_hub> start_monitor
city_hub> calculate_scores Nord Elisabetin
city_hub> exit
```

### 2. Manage reports

Open a second terminal and execute commands such as:

**Add a report as an inspector:**

```bash
./city_manager --role inspector --user Delia --add Nord
```

**List reports:**

```bash
./city_manager --role manager --user Delia --list Nord
```

**View a report by ID:**

```bash
./city_manager --role manager --user Delia --view Nord 1
```

**Update the district threshold:**

```bash
./city_manager --role manager --user Delia --update_threshold Nord 3
```

**Remove a report:**

```bash
./city_manager --role manager --user Delia --remove_report Nord 1
```

**Filter reports:**

```bash
./city_manager --role manager --user Delia --filter Nord "severity:>=:2" "category:==:road"
```

**Remove a district:**

```bash
./city_manager --role manager --user Delia --remove_district Nord
```

Filter conditions should be enclosed in quotes so that the shell does not interpret `<` or `>` as redirection operators.

### 3. Stop the monitor

To stop the monitor from another terminal:

```bash
kill -INT $(cat .monitor_pid)
```

The monitor handles `SIGINT` and removes its PID file when it exits.

## Project Structure

| File | Description                                             |
|---|---------------------------------------------------------|
| `main.c` | `city_manager` handles report and district operations   |
| `city_hub.c` | Interactive hub; starts the monitor and computes scores |
| `monitor_reports.c` | Signal-driven monitor process                           |
| `scorer.c` | Calculates inspector workload for a district            |
| `library.h` | Shared structures and includes                          |