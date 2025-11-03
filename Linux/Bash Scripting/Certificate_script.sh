#!/usr/bin/env bash

echo "Select the service to update SSL certificate:"
echo "1. Xbroker"
echo "2. Livestream"
echo "3. Exit"

read -p "Enter your choice : " choice

case "$choice" in
  1)
    echo "------ You selected Xbroker ------"

    # Prompt user for domain
    read -p "Enter the domain (hostname or IP): " domain
    if [[ -z "$domain" ]]; then
      echo "Domain is required. Exiting."
      exit 1
    fi

    echo "------ Check Connections on Xbroker ------"
    curl http://$domain/broker/status

    echo ""
    echo "-------------------------------------------"

    # Prompt for server certificate path
    read -p "Enter location of ServerCertificate.crt: " ServerCertificate
    if [[ ! -f "$ServerCertificate" ]]; then
      echo "Certificate file not found at $ServerCertificate. Exiting."
      exit 1
    fi

    # Prompt for private key path
    read -p "Enter the location of PrivateKey.key: " PrivateKey
    if [[ ! -f "$PrivateKey" ]]; then
      echo "Private key file not found at $PrivateKey. Exiting."
      exit 1
    fi

    certpath="/opt/xcloud/conf/xbroker"
    echo "---------------Copy Files to /tmp on $domain--------------------------"
    scp -r "$ServerCertificate" ec2-user@"$domain":/tmp
    scp -r "$PrivateKey" ec2-user@"$domain":/tmp

    date="$(date +'%d%m%Y')"

    echo "---------------Backup of Existing Certificates on $domain--------------------------"

    # Restart and replace logic could go here..

        ssh $domain -t " sudo cp $certpath/ServerCertificate.crt $certpath/ServerCertificate.crt_$date ;
                sudo cp $certpath/PrivateKey.key $certpath/PrivateKey.key_$date ;
                sudo ls -larth /opt/xcloud/conf/xbroker/;

                echo "---------------Adding Certificate--------------------------";
                sudo cp /tmp/ServerCertificate.crt $certpath/ ;
                sudo cp /tmp/PrivateKey.key $certpath;
                echo "---------------Restarting xbroker Service--------------------------";
                sudo service xcloud stop;
                sleep 5;
                sudo service xcloud start;
                sleep 10;
                sudo service xcloud status;"

    echo "---------------CHECKING SERVER SSL CERTIFICATE-----------------"
    expiration_date=$(echo | openssl s_client -servername "$domain" -connect "$domain":443 2>/dev/null | openssl x509 -noout -dates)
    aliases=$(echo | openssl s_client -servername "$domain" -connect "$domain":443 2>/dev/null | openssl x509 -text -noout | grep "DNS")
    common_name=$(echo | openssl s_client -servername "$domain" -connect "$domain":443 2>/dev/null | openssl x509 -noout -subject -nameopt multiline | grep "commonName")

    echo -e "Certificate Expiration Date:\n$expiration_date"
    echo -e "-------"
    echo -e "Aliases:\n$aliases"
    echo -e "-------"
    echo -e "Common Name:\n$common_name"
    echo "Host name under validation = $domain"
    echo "-----------------------DONE----------------------------"
    ;;

  2)
    echo "------ You selected Livestream ------"

    # Prompt for multiple domains
    read -p "Enter domains (space-separated): " -a domains
    if [[ ${#domains[@]} -eq 0 ]]; then
      echo "At least one domain is required. Exiting."
      exit 1
    fi

    # Prompt for wss.pem
    read -p "Enter location of wss.pem: " wss
    if [[ ! -f "$wss" ]]; then
      echo "Certificate file not found at $wss. Exiting."
      exit 1
    fi

    cert_path="/usr/local/hmsopensip/etc/opensips/tls"
    date="$(date +'%d%m%Y')"

    for domain in "${domains[@]}"; do
      echo "---------------Processing $domain--------------------------"

      echo "Copying wss.pem to /tmp on $domain..."
      #scp -r "$wss" ec2-user@"$domain":/tmp

      # Optional: Add SSH block to install certificate & restart service if needed
      # ssh ec2-user@"$domain" -t "
      #   sudo cp $cert_path/wss.pem $cert_path/wss_$date ;
      #   sudo cp /tmp/wss.pem $cert_path/ ;
      #   sudo systemctl restart hmsopensip
      # "

      echo "Checking SSL certificate for $domain..."
      expiration_date=$(echo | openssl s_client -servername "$domain" -connect "$domain":443 2>/dev/null | openssl x509 -noout -dates)
      aliases=$(echo | openssl s_client -servername "$domain" -connect "$domain":443 2>/dev/null | openssl x509 -text -noout | grep "DNS")
      common_name=$(echo | openssl s_client -servername "$domain" -connect "$domain":443 2>/dev/null | openssl x509 -noout -subject -nameopt multiline | grep "commonName")

      echo -e "Certificate Expiration Date:\n$expiration_date"
      echo -e "Aliases:\n$aliases"
      echo -e "Common Name:\n$common_name"
      echo "Host name under validation = $domain"
      echo "------------------------------------------------------------"
      echo ""
    done
    ;;

  3)
    echo "Exiting script"
    exit 0
    ;;

  *)
    echo "Invalid choice. Please run the script again and select a valid option."
    exit 1
    ;;
esac