#!/bin/bash
for f in event_*
do
  touch post.json
  echo '''{"Message":{"Subject": "SeismiQuery request: '"$f"'" ,"Importance": "Normal","Body": {"ContentType": "text","Content": " ''' > post.json
  cat $f >> post.json
  echo '''"},"ToRecipients": [{"EmailAddress": {"Name": "breq_fast@iris.washington.edu","Address": "breq_fast@iris.washington.edu"}}]}} ''' >> post.json
  curl -X POST --data-binary "@post.json" https://outlook.office365.com/api/v1.0/me/sendmail --header "Content-Type:application/json" --insecure --verbose --user "asaxena@memphis.edu:Ivegotthis03"
 #curl POST -d '{"Message":{"Subject": "SeismiQuery request: '"$f"'" ,"Importance": "Normal","Body": {"ContentType": "text","Content": "'`cat $f`'"},"ToRecipients": [{"EmailAddress": {"Name": "Arushi Saxena","Address": "al.arushievil@gmail.com"}}]}}' https://outlook.office365.com/api/v1.0/me/sendmail --header "Content-Type:application/json" --insecure --verbose --user "asaxena@memphis.edu:Ivegotthis02"
  rm post.json
done;
