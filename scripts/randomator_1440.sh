#!/usr/bin/env sh

usage="
Randomator 1440: Low dependency randomness for all your educational needs.

Warning: 
\tRandomator 1440 should be as dependable as /dev/random.
\tExperimental script for education purposes with no warranties.

Usage: $0 [options]

Where Options:
\t --help\tShow this usage
\t<dir>\tUse <dir> as output directory

Notes:
\t<dir> will be created if it does not exist
\tFilename will be in the format YYYY-MM-dd.json, e.g. 2023-01-16.json

Examples:
\t$0\t\t\t will create a json file in the current directory
\t$0 /some/folder\t will create a json file in /some/folder/

The content of the file will contain JSON as in this the example:

{
\t\"2023-01-16\": {
\t\t\"values_hash\": {
\t\t\t\"type:\": \"sha512\",
\t\t\t\"hash\": <sha512 hash of the json string of the field values>
\t\t},
\t\t\"values\": {
\t\t\t\"unsigned_32_bit\": [
\t\t\t\t4107879905,
\t\t\t\t79905,
\t\t\t\t... contains a total of 24*60 entries
\t\t\t],
\t\t\t\"signed_32_bit\": [
\t\t\t\t-1877367571,
\t\t\t\t7367571,
\t\t\t\t... contains a total of 24*60 entries
\t\t\t],
\t\t\t\"byte\": [
\t\t\t\t63,
\t\t\t\t127,
\t\t\t\t... contains a total of 24*60 entries
\t\t\t],
\t\t\t\"coin_flips\": [
\t\t\t\t0,
\t\t\t\t1,
\t\t\t\t... contains a total of 24*60 entries
\t\t\t]
\t\t}
\t}
}
"

output_dir="./"
if [ $# -ge 1 ]; then
    len=$(expr length $1)
    if [ $len -ge 1 ]; then
        if [ "$1" = "--help" ]; then
            echo "$usage"            
            exit 0;
        else
            output_dir="$1"
            if [ ! -d $output_dir ]; then
                mkdir -p $output_dir
            fi
        fi
    fi
fi

#total elements in the vectors (1 per minute for 24 hours)
total=$(expr 24 \* 60)

#sizes
decimal_bytes=4 #32bit
decimal_total=$(expr $decimal_bytes \* $total)

utc_date="$(date -u +"%F")"
unsigned_decimal="\"unsigned_32_bit\":[$(od -v -t u$decimal_bytes -w$decimal_bytes -An -N$decimal_total </dev/random | tr -d ' ' | paste -s -d',' -)]"
signed_decimal="\"signed_32_bit\":[$(od -v -t d$decimal_bytes -w$decimal_bytes -An -N$decimal_total </dev/random | tr -d ' ' | paste -s -d',' -)]"
bytes="\"byte\":[$(od -v -t u1 -w1 -An -N$total </dev/random | tr -d ' ' | paste -s -d',' -)]"
coin_flips="\"coin_flips\":[$(od -v -t u2 -N$total -w2 -An </dev/random | tr -d ' ' | xargs -I§ -n1 expr § % 2 | paste -s -d',' -)]"
randoms="{$unsigned_decimal,$signed_decimal,$bytes,$coin_flips}"
hash=$(echo $randoms | sha512sum -z | cut -d' ' -f1)

filename="$output_dir/$utc_date.json"

echo "{\"$utc_date\": {\"values_hash\":{\"type:\":\"sha512\",\"hash\":\"$hash\"}, \"values\":$randoms} }" >$filename
