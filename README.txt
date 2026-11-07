PAR Final Project - Autonomous Drone Planning for Smart-City Emergency Response
===============================================================================
Authors:
  Soham Chakraborty
  Luis David Landicho Antonio
Course: Planning and Approximate Reasoning (MIA-MESIIA), URV, 2026

1. Contents
-----------
  domain-A.pddl             First domain model (Model A: full recharge to max-level in one action)
  domain-B.pddl             Alternative domain model (Model B: incremental +1 level recharge via next-level)
  problem-small.pddl        Small problem instance (1 drone, 5 locations, capacity b4, forced recharge)
  problem-medium.pddl       Medium problem instance (2 drones, 8 locations, capacity b6, inspection-locked s5)
  problem-large.pddl        Large problem instance (3 drones, 11 locations, capacity b6, delivery-locked s4)
  problem-large-1drone.pddl Single-drone variant of the large instance (Section 5 comparison)
  plans/                    Generated plan files from Fast Downward (16 plans across all combinations)
  logs/                     Full Fast Downward console logs, one per run (<plan-name>.log)
  validation/               VAL validation outputs, one per plan (<plan-name>.txt)
  README.txt                Exact commands used to run Fast Downward and VAL (this file)
  report.pdf                Final project report

2. Environment & Setup
----------------------
- Planner: Fast Downward (revision ed3d389bf), compiled natively on macOS
- Validator: VAL (KCL-Planning), `Validate` binary
- Hardware/OS: Apple MacBook (macOS Golden Gate 27.2, 36 GB RAM)

Before running the commands below from the project root directory, set aliases for the Fast Downward driver script and VAL binary:

  alias fd="$HOME/downward/fast-downward.py" # e.g. /Users/<you>/downward/fast-downward.py
  alias validate="/path/to/VAL/build/bin/Validate" # e.g. /Users/<you>/VAL/build/bin/Validate

If using the official Fast Downward Docker image (Linux/macOS/WSL) instead of a native build:

  alias fd='docker run --rm -v "$PWD":/work -w /work aibasel/downward'

(The Docker image contains Fast Downward only; VAL must still be installed separately.)

Operating systems:
- macOS / Linux: the commands below run as written in bash or zsh.
- Windows: easiest is WSL (Ubuntu), where the Linux commands run unchanged.
  Natively in PowerShell, aliases cannot take arguments, so replace `fd` with
  `python C:\path\to\downward\fast-downward.py` and `validate` with
  `C:\path\to\VAL\bin\Validate.exe` in each command; the `>` and `2>&1`
  redirects work as written. Create the folders with:
      mkdir plans, logs, validation
  With Docker in PowerShell, use ${PWD} instead of "$PWD".

Create the output folders before running anything (redirects fail if they do not exist):

  mkdir -p plans logs validation

3. Exact Commands to Run Fast Downward (All 16 Experimental Configurations)
---------------------------------------------------------------------------
Note on macOS memory limit: On macOS, `ulimit` virtual memory restrictions are unsupported by the kernel, causing Fast Downward's `--overall-memory-limit 4G` flag to abort immediately with `Setting memory limits is not supported on your platform` (translate exit code 37). Therefore, runs on macOS use `--overall-time-limit 5m` (all runs finish in < 0.6s and use < 20 MB of RAM). On Linux, `--overall-memory-limit 4G` can be appended directly.

Each command saves its plan to plans/<name> and its full console output to logs/<name>.log.

--- Instance 1: Small ---
  fd --overall-time-limit 5m --plan-file plans/small-A-astar domain-A.pddl problem-small.pddl --search "astar(lmcut())" > logs/small-A-astar.log 2>&1
  fd --overall-time-limit 5m --plan-file plans/small-A-lama  --alias lama-first domain-A.pddl problem-small.pddl > logs/small-A-lama.log 2>&1
  fd --overall-time-limit 5m --plan-file plans/small-B-astar domain-B.pddl problem-small.pddl --search "astar(lmcut())" > logs/small-B-astar.log 2>&1
  fd --overall-time-limit 5m --plan-file plans/small-B-lama  --alias lama-first domain-B.pddl problem-small.pddl > logs/small-B-lama.log 2>&1

--- Instance 2: Medium ---
  fd --overall-time-limit 5m --plan-file plans/medium-A-astar domain-A.pddl problem-medium.pddl --search "astar(lmcut())" > logs/medium-A-astar.log 2>&1
  fd --overall-time-limit 5m --plan-file plans/medium-A-lama  --alias lama-first domain-A.pddl problem-medium.pddl > logs/medium-A-lama.log 2>&1
  fd --overall-time-limit 5m --plan-file plans/medium-B-astar domain-B.pddl problem-medium.pddl --search "astar(lmcut())" > logs/medium-B-astar.log 2>&1
  fd --overall-time-limit 5m --plan-file plans/medium-B-lama  --alias lama-first domain-B.pddl problem-medium.pddl > logs/medium-B-lama.log 2>&1

--- Instance 3: Large (3 Drones) ---
  fd --overall-time-limit 5m --plan-file plans/large-A-astar domain-A.pddl problem-large.pddl --search "astar(lmcut())" > logs/large-A-astar.log 2>&1
  fd --overall-time-limit 5m --plan-file plans/large-A-lama  --alias lama-first domain-A.pddl problem-large.pddl > logs/large-A-lama.log 2>&1
  fd --overall-time-limit 5m --plan-file plans/large-B-astar domain-B.pddl problem-large.pddl --search "astar(lmcut())" > logs/large-B-astar.log 2>&1
  fd --overall-time-limit 5m --plan-file plans/large-B-lama  --alias lama-first domain-B.pddl problem-large.pddl > logs/large-B-lama.log 2>&1

--- Instance 3 Variant: Large (1 Drone) ---
  fd --overall-time-limit 5m --plan-file plans/large-1drone-A-astar domain-A.pddl problem-large-1drone.pddl --search "astar(lmcut())" > logs/large-1drone-A-astar.log 2>&1
  fd --overall-time-limit 5m --plan-file plans/large-1drone-A-lama  --alias lama-first domain-A.pddl problem-large-1drone.pddl > logs/large-1drone-A-lama.log 2>&1
  fd --overall-time-limit 5m --plan-file plans/large-1drone-B-astar domain-B.pddl problem-large-1drone.pddl --search "astar(lmcut())" > logs/large-1drone-B-astar.log 2>&1
  fd --overall-time-limit 5m --plan-file plans/large-1drone-B-lama  --alias lama-first domain-B.pddl problem-large-1drone.pddl > logs/large-1drone-B-lama.log 2>&1

4. Exact Commands to Validate Plans with VAL
--------------------------------------------
Note on plan filenames: Our VAL build rejects filenames ending with `.plan` (`Bad plan file!`), so all plan files in `plans/` are stored without a file extension.

  validate -v domain-A.pddl problem-small.pddl        plans/small-A-astar        > validation/small-A-astar.txt
  validate -v domain-A.pddl problem-small.pddl        plans/small-A-lama         > validation/small-A-lama.txt
  validate -v domain-B.pddl problem-small.pddl        plans/small-B-astar        > validation/small-B-astar.txt
  validate -v domain-B.pddl problem-small.pddl        plans/small-B-lama         > validation/small-B-lama.txt

  validate -v domain-A.pddl problem-medium.pddl       plans/medium-A-astar       > validation/medium-A-astar.txt
  validate -v domain-A.pddl problem-medium.pddl       plans/medium-A-lama        > validation/medium-A-lama.txt
  validate -v domain-B.pddl problem-medium.pddl       plans/medium-B-astar       > validation/medium-B-astar.txt
  validate -v domain-B.pddl problem-medium.pddl       plans/medium-B-lama        > validation/medium-B-lama.txt

  validate -v domain-A.pddl problem-large.pddl        plans/large-A-astar        > validation/large-A-astar.txt
  validate -v domain-A.pddl problem-large.pddl        plans/large-A-lama         > validation/large-A-lama.txt
  validate -v domain-B.pddl problem-large.pddl        plans/large-B-astar        > validation/large-B-astar.txt
  validate -v domain-B.pddl problem-large.pddl        plans/large-B-lama         > validation/large-B-lama.txt

  validate -v domain-A.pddl problem-large-1drone.pddl plans/large-1drone-A-astar > validation/large-1drone-A-astar.txt
  validate -v domain-A.pddl problem-large-1drone.pddl plans/large-1drone-A-lama  > validation/large-1drone-A-lama.txt
  validate -v domain-B.pddl problem-large-1drone.pddl plans/large-1drone-B-astar > validation/large-1drone-B-astar.txt
  validate -v domain-B.pddl problem-large-1drone.pddl plans/large-1drone-B-lama  > validation/large-1drone-B-lama.txt

5. Expected Results
-------------------
Plan costs, plan lengths, expanded states and search times for every run are reported in
the results tables of report.pdf. Every validation file should contain "Plan valid"
and report the same final value of (total-cost) as the corresponding plan file.
