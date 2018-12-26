# Make sure the script is being executed with superuser privileges.
if [[ "${UID}" != 0 ]]
then
	echo "Script should be executed with superuser privileges."
	exit 1
fi
# Get the username (login).
read -p "Please enter username for new user: " USERNAME
# Get the real name (contents for the description field).
read -p "Please enter Full Name: " COMMENT
# Get the password.
read -p "Please enter password: " PASSWORD
# Create the user with the password.
useradd -c '${COMMENT}' -m $USERNAME
# Check to see if the useradd command succeeded.
if [[ "$?" -ne 0 ]]
then
	echo "Something went wrong with user creating"
	exit 1
fi
# Set the password.
echo "${PASSWORD}" | passwd --stdin $USERNAME
# Check to see if the passwd command succeeded.
if [[ "$?" -ne 0 ]]
then 
	echo "Something went wrong with new password"
fi
# Force password change on first login.
passwd -e $USERNAME
# Display the username, password, and the host where the user was created.
echo "username: ${USERNAME}"
echo "password: ${PASSWORD}"
echo "hostname: " | hostname
