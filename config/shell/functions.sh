#!/bin/sh

# function kfr stands for kill all file reference in current folder
# > lsof +D ./ | awk '{print $2}' | tail -n +2 | xargs -r kill -9
# > awk grabs the PIDs.
# > tail gets rid of the pesky first entry: "PID".
# > xargs executes kill -9 on the PIDs. The -r / --no-run-if-empty, prevents kill command failure, in case lsof did not return any PID.
# See: https://unix.stackexchange.com/a/216520
f_kfr() {
    lsof +D ./ | awk '{print $2}' | tail -n +2 | xargs -r kill -9
}
