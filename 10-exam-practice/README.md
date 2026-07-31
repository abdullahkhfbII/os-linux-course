# 10. Exam Practice — Every Scenario, One File Each

This is the most important folder for actually passing the Lab Test. It
takes every scenario question from the original lab documents and the two
revision/practice documents, and gives each one **its own standalone `.sh`
file** — matching the exact format your real Lab Test answer should take:

- Starts with `#!/bin/bash`
- One command per line
- Comments explaining *why* each command/flag is used
- No unnecessary complexity — just what the scenario asks for

**How to actually study with this folder:** read the scenario description
at the top of a file, then close it, and try to write the whole script
yourself from scratch in a text editor. Only after you've genuinely tried
should you open the file and compare your answer to the provided solution.
Simply reading solutions without attempting them yourself will not prepare
you for writing one under exam conditions.

## Folder breakdown

### `lab-test-1-style/`

Lab Test 1 (Week 6) covers roughly Modules 1–5 (Linux fundamentals, Bash
scripting, users/permissions, monitoring, cron/backups). This folder
contains the practice scenarios from the revision materials that focus on
*just* those topics, one lab at a time:

| File | Focus |
|------|-------|
| `q1_photographer_portfolio.sh` | Module 1 only — directories, moving files, archiving |
| `q2_bookstore_inventory_backup.sh` | Module 3 + Module 5 — users/permissions combined with loops and scheduled backups |
| `q3_bakery_sales_and_orders.sh` | Module 5 only — backups and cleanup with `find` |
| `q4_retail_chain_monitoring.sh` | Module 5 only — backups, cleanup, and a disk-usage alert |

### `lab-test-2-style/`

This folder is a direct, one-file-per-question breakdown of the real
**"Lab test 2 scenarios"** revision document, which focuses heavily on
Module 8 (multiprocessing) and Module 9 (advanced permissions), combined
with earlier topics (users, cron, backups, networking). This is the
closest thing to an actual past paper available for this course — study it
carefully.

| File | Focus |
|------|-------|
| `q1_secure_env_process_management.sh` | Modules 8 + 9 |
| `q2_team_projects_directory.sh` | Modules 3 + 8 + 9 |
| `q3_shared_secure_ssh_control.sh` | Modules 6 + 8 + 9 |
| `q4_research_team_backup_processes.sh` | Modules 3 + 5 + 8 |
| `q5_university_lab_full_combo.sh` | Modules 3 + 5 + 8 |
| `q6_network_interface_monitoring.sh` | Modules 5 + 6 |
| `q7_devops_shared_directory.sh` | Modules 3 + 5 + 6 + 9 |
| `q8_cs_students_lab_setup.sh` | Modules 3 + 5 + 6 + 8 + 9 |
| `q9_it_staff_log_backup_processes.sh` | Modules 3 + 5 + 8 |
| `q10_full_maintenance_solution.sh` | Modules 4 + 5 + 8 |
| `q11_student_backup_and_process_manager.sh` | Modules 5 + 8 |
| `q12_bonus_shared_secure_run_script.sh` | Module 9 only (bonus question) |

### `extra-revision/`

The remaining "combination of all labs" scenarios from the general revision
document — the broadest, most comprehensive practice questions, each
touching almost every module in the course at once.

| File | Focus |
|------|-------|
| `q1_bakery_inventory_system.sh` | Modules 3 + 5 |
| `q2_faculty_computer_science.sh` | Modules 2 + 3 + 5 |
| `q3_university_it_department.sh` | Modules 2 + 3 + 5 |
| `q4_remote_dev_team_maintenance.sh` | Modules 3 + 5 |
| `q5_bakery_recipes_and_orders.sh` | Modules 2 + 3 + 5 |

## A note on realism

Some solutions below use placeholder paths or usernames (e.g.
`/path/to/...`, `student1`) exactly as they appeared in the original
revision material — in a real exam, replace these with whatever the actual
scenario specifies. A few original answers also contain small
inconsistencies (e.g. a stray space in `crontab –` using the wrong dash
character, or referencing a variable/file from a different scenario by
mistake); where a scenario's original answer had a clear error, this
version corrects it and adds a note explaining the fix, so you don't learn
the mistake along with the concept.

Good luck.
