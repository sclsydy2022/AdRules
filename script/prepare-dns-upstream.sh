#!/bin/bash

source /etc/profile

cd $(cd "$(dirname "$0")";pwd)
rm -f ./origin-files/*
dead_hosts=(
  "https://raw.githubusercontent.com/notracking/hosts-blocklists-scripts/master/domains.dead.txt"
  "https://raw.githubusercontent.com/notracking/hosts-blocklists-scripts/master/hostnames.dead.txt"
  "https://raw.githubusercontent.com/privacy-protection-tools/dead-horse/master/anti-ad-white-list.txt"
  "https://raw.githubusercontent.com/anudeepND/whitelist/master/domains/whitelist.txt"
  "https://raw.githubusercontent.com/anudeepND/whitelist/master/domains/optional-list.txt"
  "https://raw.githubusercontent.com/Ultimate-Hosts-Blacklist/whitelist/master/domains.list"
  "https://raw.githubusercontent.com/neodevpro/neodevhost/master/customallowlist"
  "https://raw.githubusercontent.com/EnergizedProtection/unblock/master/basic/formats/domains.txt"
  "https://raw.githubusercontent.com/eded333/TheFuckingList/main/whitelist.txt"
  "https://raw.githubusercontent.com/Ultimate-Hosts-Blacklist/blacklist/master/whitelisted.list"
  "https://raw.githubusercontent.com/AdguardTeam/AdguardFilters/master/ChineseFilter/sections/whitelist.txt"
  "https://gitlab.com/ZeroDot1/CoinBlockerLists/-/raw/master/white_list.txt"
  "https://raw.githubusercontent.com/EnergizedProtection/unblock/master/basic/formats/domains.txt"
  "https://raw.githubusercontent.com/Ultimate-Hosts-Blacklist/whitelist/master/domains.list"
  "https://raw.githubusercontent.com/notracking/hosts-blocklists-scripts/master/hostnames.whitelist.txt"
)
for i in "${!dead_hosts[@]}"
do
  echo "开始下载 dead-hosts${i}..."
  curl -o "./origin-files/dead-hosts${i}.txt" --connect-timeout 60 -s "${dead_hosts[$i]}"
done
cp ../mod/rules/*rule* ./origin-files/
cp ../tmp/{*easy*,dns*,base*,hosts*} ./origin-files/
cd origin-files
cat hosts*.txt | grep -v -E "^((#.*)|(\s*))$" \
 | grep -v -E "^[0-9\.:]+\s+(ip6\-)?(localhost|loopback)$" \
 | sed s/0.0.0.0/127.0.0.1/g | sed s/::/127.0.0.1/g | sort \
 | uniq >base-src-hosts.txt

cat dead-hosts*.txt | grep -v -E "^(#|\!)" \
 | sort \
 | uniq >base-dead-hosts.txt

cat easylist*.txt dns* *rule*| grep -E "^\|\|[^\*\^]+?\^" | sort | uniq >base-src-easylist.txt
cat easylist*.txt dns* *rule*| grep -E "^\|\|?([^\^=\/:]+)?\*([^\^=\/:]+)?\^" | sort | uniq >wildcard-src-easylist.txt
cat easylist*.txt dns* *rule*| grep -E "^@@\|\|?[^\^=\/:]+?\^([^\/=\*]+)?$" | sort | uniq >whiterule-src-easylist.txt

cd ../
bash ./build-dns-list.sh
