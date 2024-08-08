# WireGuard Setup Scripts
This repository contains scripts to set up WireGuard using wg-easy. You have three options :

1) Password-Protected Setup
2) Non-Protected Setup
3) Create a New User

Scripts

	'setup_wireguard_protected.sh': Configures WireGuard with an admin password.
	'setup_wireguard_non_protected.sh': Configures WireGuard without an admin password.
	'setup_new_user.sh': Creates a new user and installs Docker for that user.


Prerequisites

	Ubuntu server
	SSH access to the server
	Git installed on the server


Instructions

	1. Clone the Repository
		
		git clone https://github.com/xabcd001/wireguard-setup.git
		cd wireguard-setup
  
	2. Run the Password-Protected Script
		2.1 Download the Script:

			curl -O https://raw.githubusercontent.com/xabcd001/wireguard-setup/main/setup_wireguard_protected.sh

		2.2 Make the Script Executable:
			
			chmod +x setup_wireguard_protected.sh

		2.3 Run the Script:

			./setup_wireguard_protected.sh

		Follow the Prompts:
				The script will ask for your server IP address and admin password.

	3. Run the Non-Protected Script 
 		Not Working Properly ❌
		3.1 Download the Script:
			
			curl -O https://raw.githubusercontent.com/xabcd001/wireguard-setup/main/setup_wireguard_non_protected.sh
		
		3.2 Make the Script Executable:

			chmod +x setup_wireguard_non_protected.sh

		3.3 Run the Script:

			./setup_wireguard_non_protected.sh
		
		Follow the Prompts:

			The script will ask for your server IP address.

	4. Run the New User Script
		4.1 Download the Script:

			curl -O https://raw.githubusercontent.com/xabcd001/wireguard-setup/main/setup_new_user.sh

		4.2 Make the Script Executable:

			chmod +x setup_new_user.sh
		
		4.3 Run the Script:
            		
			./setup_new_user.sh
		
		Follow the Prompts:

The script will prompt you to enter a new username (default is wireguard).

Notes
Ensure Docker is not already installed on your server as the script will install it.
The scripts are designed for Ubuntu servers. Adjustments may be needed for other distributions.
