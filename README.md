# Geoblock

Change the allowed-countries array to contain the list of countries that you don't want to blacklist, all other countries in the world will be blacklisted, you must use the ISO 3166-1 alpha-2 code for the countries.

The result is 2 files that contain ipv4 and ipv6 CIDR format IP ranges, you can then use that to create rulesets for nftables, iptables, ufw or whatever firewall you use.

It is not perfect, some connections from the countries you want to block will still go through but it will be a minority, also some connections from countries you dont want to block might be blocked by accident.

In order to keep it as accurate as possible it is recommended to run the script often so the lists will be updated, you can automate it with a cronjob and add some code to make it work for your firewall.

ipv6 ranges are assigned to countries very often apparently, so they might change a lot more often than the ipv4 ones.

You can check if your firewall is filtering the countries correctly here https:⁄⁄check-host.net

Personally I only recommend to use this if you just want to reduce the number of illegitimate connections to a server, and don't use the server for serious business stuff, because this will block a lot of legitimate users as well.
