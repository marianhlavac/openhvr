#!/usr/bin/env zsh

function progress {
    PERCENT=$(($2*100/$3))
    echo -en "\033[1m$1\033[0m\t$2/$3\t($PERCENT%)\t"
    if [ $2 -le $(($3/10)) ]; then echo -en "\033[31m"; fi
    if [ $2 -ge $(($3 - $3/10)) ]; then echo -en "\033[32m"; fi
    WIDTH=50
    BLOCKS=$(($PERCENT/(100/$WIDTH)))
    REST=$(($WIDTH-$BLOCKS))
    [[ $BLOCKS -gt 0 ]] && printf '◼︎%.0s' {1..$BLOCKS}
    [[ $REST -gt 0 ]] && printf '◻︎%.0s' {1..$REST}
    echo -e "\033[0m"
}

function limit {
    PERCENT=$(($2*100/$4))
    echo -en "\033[1m$1\033[0m \t$2\t$5 \t"
    if [ $2 -ge $3 ]; then echo -en "\033[31m"; fi
    if [ $2 -lt $3 ]; then echo -en "\033[32m"; fi
    WIDTH=50
    BLOCKS=$(($PERCENT/(100/$WIDTH)))
    [[ $BLOCKS -gt 0 ]] && printf '◼︎%.0s' {1..$BLOCKS}
    echo -e "\033[0m"
}

# --- Stats

CHAPTERS=$(ls -1 chapters | wc -l | tr -d ' ')
TARGET_CHAPTERS=14

CHARS=$(find . -name "*.adoc" -type f | xargs wc -c | awk -F ' ' '{sum += $1} END {print sum}')
TARGET_CHARS=$((1800 * 100))

find . -iname "*.adoc" -type f -exec sh -c 'cat "$0" >> /tmp/freqtmp' {} \;
MOST_REPEATING_EXCLUDE="(the|and|for|are|with)"
REPEATS=$(cat /tmp/freqtmp | grep -hEo "\w{3,}" | sort | uniq -c | sort -r | grep -vE $MOST_REPEATING_EXCLUDE | head -n 8)
MOST_REPEATING_WORD=$(echo $REPEATS | head -n 1 | awk -F ' ' '{print $2}')
MOST_REPEATING_FREQ=$(echo $REPEATS | head -n 1 | awk -F ' ' '{print $1}')
rm /tmp/freqtmp

# --- Printout

echo -e "\033[4mMaster Thesis Progress Overview\033[0m"
PROGRESS_REPORT=$(
    progress "Total character count" $CHARS $TARGET_CHARS
    progress "Chapters created" $CHAPTERS $TARGET_CHAPTERS
    limit "Most repeating word frequency" $MOST_REPEATING_FREQ 30 100 "\"$MOST_REPEATING_WORD\""
)

echo $PROGRESS_REPORT | column -t -s $'\t'

echo -e "\n\033[4mMost repeating words\033[0m\n$REPEATS\n"

echo -e "\033[4mList of acronyms\033[0m"
find . -iname "*.adoc" -type f -exec sh -c $'
  echo "📄 $0: ";
  cat "$0" | grep -hEo "[[:upper:]]{3,}" | sort | uniq | awk \'{print "    ● "$0 }\'
' {} \;
