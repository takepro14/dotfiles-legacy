# ===================================
# Joke commands utilities
# ===================================

# https://raintrees.net/news/93
allf() {
  C=$(tput cols);L=$(tput lines);while :;do x=$((($RANDOM%$C+$RANDOM%$C+$RANDOM%$C)/3));y=$((($RANDOM%$L+$RANDOM%$L+$RANDOM%$L)/3));printf "\033[${y};${x}fF";done
}
