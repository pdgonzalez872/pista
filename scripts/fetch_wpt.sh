#!/bin/bash

echo "Start fetch"

urls=(
  "areco-malm-padel-open-2023"
  "estrella-damm-menorca-open-2023"
  "decathlon-amsterdam-open-2023"
  "boss-german-padel-open-2023"
  "sixt-comunidad-de-madrid-master-2023"
  "aare-invest-finland-padel-open-2023"
  "cervezas-victoria-malaga-open-2023"
  "adeslas-valencia-open-2023"
  "barcelo-valladolid-master-2023"
  "human-french-padel-open-2023"
  "cervezas-victoria-marbella-master-2023"
  "boss-vienna-padel-open-2023"
  "cupra-danish-padel-open-2023"
  "estrella-damm-vigo-open-2023"
  "tau-ceramica-alicante-open-500"
  "circus-brussels-padel-open-2023"
  "cervezas-victoria-granada-open-2023"
  "tau-ceramica-reus-costa-daurada-open-500"
  "paraguay-padel-open-2023"
  "btg-pactual-chile-padel-open-2023"
  "la-rioja-open-2023"
  "modon-abu-dhabi-master-2023"
)

for url in "${urls[@]}"; do
  echo "Sending curl to $url"

  output_file="test/support/fixtures/static_html/results_wpt_${url}.html"

  echo $url

  curl "https://worldpadeltour.com/en/tournaments/${url}/2023?tab=results" --compressed -H 'User-Agent: Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:109.0) Gecko/20100101 Firefox/119.0' -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,*/*;q=0.8' -H 'Accept-Language: en-US,en;q=0.5' -H 'Accept-Encoding: gzip, deflate, br' -H 'Referer: https://worldpadeltour.com/en/tournaments/areco-malm-padel-open-2023/2023' -H 'DNT: 1' -H 'Connection: keep-alive' -H 'Cookie: CookieConsent={stamp:%27xPVfaUYNBq2rJM/b1L5l/wFk2iMD9DnnnvRfEChktrSPtuaDld5OvA==%27%2Cnecessary:true%2Cpreferences:true%2Cstatistics:true%2Cmarketing:true%2Cmethod:%27explicit%27%2Cver:1%2Cutc:1700943182883%2Cregion:%27us%27}; _gcl_au=1.1.1878869129.1700943184; ci_session=6108fdfe6e9aa69d183a25b89a7f994752beea67' -H 'Upgrade-Insecure-Requests: 1' -H 'Sec-Fetch-Dest: document' -H 'Sec-Fetch-Mode: navigate' -H 'Sec-Fetch-Site: same-origin' -H 'Sec-GPC: 1' > $output_file

  head $output_file

  echo "Finished fetch, check ${output_file}"
done

echo "Finish fetch"
