#!/bin/bash

# spinner() {
#     local pid=$1
#     local delay=0.1
#     local spin_chars="⠋⠙⠹⠸⠼⠴⠦⠧⠇⠏"
#
#     while kill -0 "$pid" 2>/dev/null; do
#         for (( i=0; i<${#spin_chars}; i++ )); do
#             echo -ne "\r${spin_chars:$i:1} "
#             sleep "$delay"
#         done
#     done
#     echo -ne "\r✓ Done! \n"
# }
#
# # Start the spinner in the background and detach from the shell
# while true; do
#     sleep 1 &
#     spinner $!
# done
