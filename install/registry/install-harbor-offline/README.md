# Follow docs
## Prep
On RHEL run `sudo visudo` and update `secure_path` to be
`Defaults    secure_path = /sbin:/bin:/usr/sbin:/usr/bin:/usr/local/bin` </br>
Afterwards ensure `sudo docker-compose` works </br>
</br>
Create /data/cert and set to be owned by the user </br>
Copy pem files for the harbor pair, plus the ca public key to /data/cert

## Follow the docs!


