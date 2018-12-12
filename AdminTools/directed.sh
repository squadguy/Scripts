#!/bin/bash

#Useage: directed [from] [to]
#This scripts takes a from URI and a to URI and determines if the first redirects to the second by using curl and getting the http header reponse value.
# Useful for checking if URL redirects on apache or nginx servers were entered correctly without having to use a browser

#This can probably be removed since we'v migrated to nginx
#checks if nursing eval application is up.
redirectStatus=`curl -s -o /dev/null -w "%{http_code}" https://proc.aurora.edu/secure/forms/nursing/PDF`


# Lets user know if Nursing Eval Application is up
if [ "$redirectStatus" -eq 401 ]; then

echo $redirectStatus

echo "Enter the \"From\""
read from
echo
echo "Enter the \"To:\""
read to
echo

newfrom=$from

gwc=`echo $from | cut -d'.' -f1`

echo $gwc

# Ensure we use port 443 for our redirects
if [ "$gwc" = "gwc" ]; then
 from="https://$newfrom"
elif [ "$gwc" = "aurora" ]; then
 from="https://$newfrom"
fi 

echo $from

# Gt the redirect value using curl
redirectedValue=`curl -s -o /dev/null -w "%{redirect_url}" $from`

echo $redirectedValue

#Determine if the redirect was successful
echo $redirectedValue
 if [ "$to" == "$redirectedValue" ]; then

  echo "Good to go!"

 else
  
  echo "Failure"
fi

else 
#In place for old 501 error when we used apache
  echo "501 error RESTART APACHE SERVICE"
fi
